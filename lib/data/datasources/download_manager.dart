import 'dart:io';
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/checksum_utils.dart';

/// Download state enumeration
enum DownloadState {
  idle,
  downloading,
  paused,
  completed,
  failed,
}

/// Download manager for handling model downloads with pause/resume support
class DownloadManager {
  final Dio _dio;
  final Map<String, DownloadTask> _activeDownloads = {};

  DownloadManager(this._dio);

  /// Check if a model is currently being downloaded
  bool isDownloading(String modelId) {
    return _activeDownloads.containsKey(modelId) &&
        _activeDownloads[modelId]!.state == DownloadState.downloading;
  }

  /// Start or resume download
  Future<void> download({
    required String modelId,
    required String url,
    required String destinationPath,
    String? checksum,
    required void Function(double progress) onProgress,
    required void Function() onComplete,
    required void Function(String error) onError,
  }) async {
    // Check if already downloading
    if (isDownloading(modelId)) {
      return;
    }

    final task = DownloadTask(
      id: modelId,
      url: url,
      destinationPath: destinationPath,
      checksum: checksum,
      cancelToken: CancelToken(),
    );

    _activeDownloads[modelId] = task;

    try {
      // Check if partial file exists (for resume)
      int startByte = 0;
      final destFile = File(destinationPath);
      
      if (await destFile.exists()) {
        startByte = await destFile.length();
        // If file is complete, skip download
        // For simplicity, we'll restart if file exists
        await destFile.delete();
        startByte = 0;
      }

      final downloadDir = destinationPath.split('/').sublist(0, destinationPath.split('/').length - 1).join('/');
      if (!await Directory(downloadDir).exists()) {
        await Directory(downloadDir).create(recursive: true);
      }

      // Start download
      await _dio.download(
        url,
        destinationPath,
        cancelToken: task.cancelToken,
        options: Options(
          receiveTimeout: const Duration(hours: 2),
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (startByte + received) / (startByte + total);
            onProgress(progress);
          }
        },
      );

      // Verify checksum if provided
      if (checksum != null && checksum.isNotEmpty) {
        final file = File(destinationPath);
        final isValid = await ChecksumUtils.verifyChecksum(file, checksum);
        if (!isValid) {
          await file.delete();
          throw Exception('Checksum verification failed');
        }
      }

      task.state = DownloadState.completed;
      onComplete();
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        task.state = DownloadState.paused;
      } else {
        task.state = DownloadState.failed;
        onError(e.toString());
        
        // Clean up partial download
        try {
          final file = File(destinationPath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (_) {}
      }
    }
  }

  /// Pause an ongoing download
  void pauseDownload(String modelId) {
    final task = _activeDownloads[modelId];
    if (task != null && task.cancelToken != null && !task.cancelToken!.isCancelled) {
      task.cancelToken!.cancel('Download paused');
      task.state = DownloadState.paused;
    }
  }

  /// Resume a paused download
  Future<void> resumeDownload({
    required String modelId,
    required String url,
    required String destinationPath,
    String? checksum,
    required void Function(double progress) onProgress,
    required void Function() onComplete,
    required void Function(String error) onError,
  }) async {
    // Just restart the download
    await download(
      modelId: modelId,
      url: url,
      destinationPath: destinationPath,
      checksum: checksum,
      onProgress: onProgress,
      onComplete: onComplete,
      onError: onError,
    );
  }

  /// Cancel and remove download
  void cancelDownload(String modelId) {
    final task = _activeDownloads[modelId];
    if (task != null && task.cancelToken != null && !task.cancelToken!.isCancelled) {
      task.cancelToken!.cancel('Download cancelled');
    }
    _activeDownloads.remove(modelId);
  }

  /// Get download progress for a model
  DownloadTask? getDownloadTask(String modelId) {
    return _activeDownloads[modelId];
  }

  /// Clear completed download
  void clearDownload(String modelId) {
    _activeDownloads.remove(modelId);
  }

  /// Dispose all downloads
  void dispose() {
    for (final task in _activeDownloads.values) {
      if (task.cancelToken != null && !task.cancelToken!.isCancelled) {
        task.cancelToken!.cancel('Disposing download manager');
      }
    }
    _activeDownloads.clear();
  }
}

/// Download task information
class DownloadTask {
  final String id;
  final String url;
  final String destinationPath;
  final String? checksum;
  final CancelToken? cancelToken;
  DownloadState state;

  DownloadTask({
    required this.id,
    required this.url,
    required this.destinationPath,
    this.checksum,
    this.cancelToken,
    this.state = DownloadState.idle,
  });
}
