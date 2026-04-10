import '../../core/constants/model_catalog.dart';
import '../../domain/entities/model_info.dart';

/// Repository interface for model management
abstract class IModelRepository {
  /// Get list of all available models (downloadable + downloaded)
  Future<List<ModelInfo>> getAvailableModels();

  /// Get currently active model
  Future<ModelInfo?> getActiveModel();

  /// Set active model
  Future<void> setActiveModel(String modelId);

  /// Download a model with progress tracking
  /// Progress callback returns value between 0.0 and 1.0
  Future<void> downloadModel(
    String modelId, {
    required void Function(double progress) onProgress,
  });

  /// Pause an ongoing download
  Future<void> pauseDownload(String modelId);

  /// Resume a paused download
  Future<void> resumeDownload(String modelId);

  /// Delete a downloaded model
  Future<void> deleteModel(String modelId);

  /// Verify model file integrity
  Future<bool> verifyModel(String modelId);

  /// Import a model file from user's device
  Future<ModelInfo?> importModelFromDevice();

  /// Scan external storage for existing model files
  Future<List<ModelInfo>> scanExternalStorage();

  /// Get recommended model ID based on device RAM
  Future<String> getRecommendedModelId();
}
