import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/constants/storage_paths.dart';

/// Service for managing model files in external storage
/// Models stored here persist after app uninstall
class ExternalModelStorageService {
  ExternalModelStorageService._();

  static Directory? _modelsDirectory;

  /// Initialize external storage directory
  /// Returns true if successful
  static Future<bool> initialize() async {
    try {
      // Request storage permission (Android 10+ may not need this for external app-specific dir)
      if (await _checkStoragePermission()) {
        // Try to get external storage directory
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          _modelsDirectory = Directory(
            '${externalDir.parent.parent.parent.path}/${StoragePaths.externalModelsDir}',
          );
          
          if (!await _modelsDirectory!.exists()) {
            await _modelsDirectory!.create(recursive: true);
          }
          return true;
        }
      }
      
      // Fallback to application support directory
      _modelsDirectory = await getApplicationSupportDirectory();
      _modelsDirectory = Directory('${_modelsDirectory!.path}/${StoragePaths.externalModelsDir}');
      
      if (!await _modelsDirectory!.exists()) {
        await _modelsDirectory!.create(recursive: true);
      }
      
      return true;
    } catch (e) {
      print('Error initializing external storage: $e');
      return false;
    }
  }

  /// Check and request storage permission
  static Future<bool> _checkStoragePermission() async {
    if (Platform.isAndroid) {
      // Android 10+ (API 29+) uses scoped storage
      // We can use getExternalStorageDirectory without permission
      if (await Permission.storage.isGranted || 
          await Permission.manageExternalStorage.isGranted) {
        return true;
      }
      
      // Request permission for broader access (optional)
      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return false;
  }

  /// Get models directory path
  static Directory? get modelsDirectory => _modelsDirectory;

  /// Get all model files in storage
  static Future<List<File>> getModelFiles() async {
    if (_modelsDirectory == null || !await _modelsDirectory!.exists()) {
      return [];
    }

    try {
      final files = await _modelsDirectory!
          .list()
          .where((entity) => entity is File)
          .cast<File>()
          .where((file) => StoragePaths.supportedExtensions
              .any((ext) => file.path.endsWith(ext)))
          .toList();
      
      return files;
    } catch (e) {
      print('Error getting model files: $e');
      return [];
    }
  }

  /// Import a model file from user's phone (via file picker)
  static Future<File?> importModelFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['gguf', 'bin', 'litertlm', 'task'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      final sourcePath = result.files.single.path;
      if (sourcePath == null) {
        return null;
      }

      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('Source file does not exist');
      }

      // Generate destination filename
      final filename = sourceFile.uri.pathSegments.last;
      final destPath = '${_modelsDirectory!.path}/$filename';
      
      // Check if file already exists
      final destFile = File(destPath);
      if (await destFile.exists()) {
        // Add timestamp to avoid conflicts
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final nameWithoutExt = filename.split('.').first;
        final ext = filename.split('.').last;
        final newFilename = '${nameWithoutExt}_$timestamp.$ext';
        return await sourceFile.copy('${_modelsDirectory!.path}/$newFilename');
      }

      // Copy file to external storage
      return await sourceFile.copy(destPath);
    } catch (e) {
      print('Error importing model file: $e');
      return null;
    }
  }

  /// Delete a model file
  static Future<bool> deleteModelFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting model file: $e');
      return false;
    }
  }

  /// Get total storage used by models
  static Future<int> getStorageUsed() async {
    try {
      final files = await getModelFiles();
      int total = 0;
      for (final file in files) {
        if (await file.exists()) {
          total += await file.length();
        }
      }
      return total;
    } catch (e) {
      print('Error calculating storage used: $e');
      return 0;
    }
  }

  /// Check if a model file exists
  static Future<bool> modelExists(String filename) async {
    final file = File('${_modelsDirectory!.path}/$filename');
    return await file.exists();
  }

  /// Get model file by name
  static Future<File?> getModelFile(String filename) async {
    final file = File('${_modelsDirectory!.path}/$filename');
    if (await file.exists()) {
      return file;
    }
    return null;
  }
}
