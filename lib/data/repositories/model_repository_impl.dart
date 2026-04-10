import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/constants/model_catalog.dart';
import '../../domain/entities/model_info.dart';
import '../../core/utils/checksum_utils.dart';
import '../../core/utils/device_utils.dart';
import '../../domain/repositories/model_repository.dart';
import '../datasources/external_model_storage.dart';

/// Implementation of model repository
class ModelRepositoryImpl implements IModelRepository {
  final Dio _dio;
  bool _isDownloading = false;
  CancelToken? _cancelToken;

  ModelRepositoryImpl(this._dio);

  @override
  Future<List<ModelInfo>> getAvailableModels() async {
    // Get predefined models
    final predefinedModels = _getPredefinedModels();
    
    // Scan external storage for downloaded models
    final downloadedModels = await scanExternalStorage();
    
    // Create a map of matched predefined models
    final matchedFilenames = <String, String>{}; // predefined filename -> downloaded path
    final unmatchedDownloads = <ModelInfo>[];
    
    // Try to match downloaded files with predefined models
    for (final downloaded in downloadedModels) {
      final matched = _matchWithPredefinedModel(downloaded, predefinedModels);
      if (matched != null) {
        matchedFilenames[matched.filename] = downloaded.localPath!;
      } else {
        // Unmatched download - show as standalone model
        unmatchedDownloads.add(downloaded);
      }
    }
    
    // Build final list: predefined models (with download status) + unmatched models
    final result = predefinedModels.map((model) {
      final downloadedPath = matchedFilenames[model.filename];
      if (downloadedPath != null) {
        final downloaded = downloadedModels.firstWhere(
          (m) => m.localPath == downloadedPath,
        );
        return model.copyWith(
          isDownloaded: true,
          localPath: downloadedPath,
          downloadedAt: downloaded.downloadedAt,
        );
      }
      return model;
    }).toList();
    
    // Add unmatched downloaded models
    result.addAll(unmatchedDownloads);
    
    return result;
  }

  /// Try to match a downloaded file with a predefined model
  /// Uses fuzzy matching based on model keywords
  ModelInfo? _matchWithPredefinedModel(
    ModelInfo downloaded,
    List<ModelInfo> predefined,
  ) {
    final filename = downloaded.filename.toLowerCase();
    
    // Match by keywords in filename
    for (final model in predefined) {
      // Extract key identifiers from model ID
      // e.g., 'tinyllama-1.1b-q4_k_m' -> ['tinyllama', '1.1b']
      final keywords = model.id.toLowerCase().split('-').take(2).toList();
      
      // Check if filename contains ALL keywords
      final hasAllKeywords = keywords.every(filename.contains);
      
      if (hasAllKeywords) {
        return model;
      }
    }
    
    return null;
  }

  @override
  Future<ModelInfo?> getActiveModel() async {
    // This would read from settings - simplified for now
    return null;
  }

  @override
  Future<void> setActiveModel(String modelId) async {
    // This would update settings - simplified for now
  }

  @override
  Future<void> downloadModel(
    String modelId, {
    required void Function(double progress) onProgress,
  }) async {
    final model = _getModelById(modelId);
    if (model == null) {
      throw Exception('Model not found: $modelId');
    }

    if (model.isDownloaded) {
      throw Exception('Model already downloaded');
    }

    if (model.downloadUrl == null) {
      throw Exception('No download URL for this model');
    }

    _isDownloading = true;
    _cancelToken = CancelToken();

    try {
      // Ensure storage is initialized
      await ExternalModelStorageService.initialize();
      final modelsDir = ExternalModelStorageService.modelsDirectory;
      
      if (modelsDir == null) {
        throw Exception('Storage not initialized');
      }

      final destPath = '${modelsDir.path}/${model.filename}';

      // Download with progress tracking
      await _dio.download(
        model.downloadUrl!,
        destPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = received / total;
            onProgress(progress);
          }
        },
        options: Options(
          receiveTimeout: const Duration(hours: 2),
          sendTimeout: const Duration(minutes: 5),
        ),
      );

      _isDownloading = false;
    } catch (e) {
      _isDownloading = false;
      if (e is DioException && e.type == DioExceptionType.cancel) {
        print('Download cancelled');
      } else {
        throw Exception('Download failed: $e');
      }
    }
  }

  @override
  Future<void> pauseDownload(String modelId) async {
    if (_isDownloading && _cancelToken != null) {
      _cancelToken!.cancel('Download paused');
      _isDownloading = false;
    }
  }

  @override
  Future<void> resumeDownload(String modelId) async {
    // Resume by restarting download with range header
    final model = _getModelById(modelId);
    if (model == null) {
      throw Exception('Model not found: $modelId');
    }

    // TODO: Implement resume with range header
    // For now, just restart the download
    await downloadModel(modelId, onProgress: (_) {});
  }

  @override
  Future<void> deleteModel(String modelId) async {
    final model = _getModelById(modelId);
    if (model == null || model.localPath == null) {
      throw Exception('Model not found or not downloaded');
    }

    final file = File(model.localPath!);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<bool> verifyModel(String modelId) async {
    final model = _getModelById(modelId);
    if (model == null || model.localPath == null) {
      return false;
    }

    final file = File(model.localPath!);
    return await file.exists();
  }

  ModelType _determineModelType(String filename) {
    final lowerFilename = filename.toLowerCase();
    if (lowerFilename.contains('stable-diffusion') || 
        lowerFilename.contains('sd1') || 
        lowerFilename.contains('sdxl')) {
      return ModelType.diffusion;
    }
    return ModelType.text;
  }

  @override
  Future<ModelInfo?> importModelFromDevice() async {
    final importedFile = await ExternalModelStorageService.importModelFile();
    if (importedFile == null) {
      return null;
    }

    // Create model info from imported file
    final filename = importedFile.uri.pathSegments.last;
    final size = await importedFile.length();
    
    return ModelInfo(
      id: filename.split('.').first.toLowerCase().replaceAll(' ', '_'),
      name: filename.split('.').first,
      description: 'Imported model',
      filename: filename,
      sizeBytes: size,
      category: ModelCategories.text,
      type: _determineModelType(filename),
      recommendedRamGB: 4,
      isDownloaded: true,
      localPath: importedFile.path,
      downloadedAt: DateTime.now(),
    );
  }

  @override
  Future<List<ModelInfo>> scanExternalStorage() async {
    await ExternalModelStorageService.initialize();
    final files = await ExternalModelStorageService.getModelFiles();
    
    return files.map((file) {
      final filename = file.uri.pathSegments.last;
      return ModelInfo(
        id: filename.split('.').first.toLowerCase().replaceAll(' ', '_'),
        name: _getNameFromFilename(filename),
        description: 'Imported/Downloaded model',
        filename: filename,
        sizeBytes: file.lengthSync(),
        category: ModelCategories.text,
        type: _determineModelType(filename),
        recommendedRamGB: 4,
        isDownloaded: true,
        localPath: file.path,
        downloadedAt: file.lastModifiedSync(),
      );
    }).toList();
  }

  @override
  Future<String> getRecommendedModelId() async {
    final ramGB = await DeviceUtils.getDeviceRamGB();
    return DeviceUtils.recommendModel(ramGB);
  }

  // ========== Helper Methods ==========

  /// Get display name from filename
  String _getNameFromFilename(String filename) {
    final nameWithoutExt = filename.split('.').first;
    return nameWithoutExt
        .replaceAll(RegExp(r'[_-]'), ' ')
        .split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1)}' 
            : '')
        .join(' ')
        .trim();
  }

  /// Get predefined models from catalog
  List<ModelInfo> _getPredefinedModels() {
    return AvailableModels.getAll();
  }

  /// Get model by ID
  ModelInfo? _getModelById(String modelId) {
    try {
      return AvailableModels.getAll().firstWhere(
        (m) => m.id == modelId,
      );
    } catch (e) {
      return null;
    }
  }
}
