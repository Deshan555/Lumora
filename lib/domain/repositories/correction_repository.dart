import '../entities/model_info.dart';

/// Repository interface for AI chat
abstract class ICorrectionRepository {
  /// Initialize the LLM with a model file
  /// Auto-detects the engine based on file extension
  Future<void> initializeModel(String modelPath);

  /// Initialize model with explicit engine selection
  /// 
  /// Parameters:
  /// - [modelPath]: Path to the model file
  /// - [runtime]: Explicitly choose which engine to use
  /// - [forceEngine]: If true, bypasses file extension check
  Future<void> initializeModelWithEngine(
    String modelPath, {
    required LlmRuntime runtime,
    bool forceEngine = false,
  });

  /// Unload the current model from memory
  Future<void> unloadModel();

  /// Check if model is loaded
  bool isModelLoaded();

  /// Chat with streaming response
  /// Returns a stream of response tokens
  Stream<String> correctTextStream(
    String message,
    String context,
    {List<String>? imagePaths}
  );

  /// Chat and return full response
  Future<String> correctText(
    String message,
    String context,
    {List<String>? imagePaths}
  );

  /// Image generation
  Future<List<int>> generateImage(String modelId, String prompt);

  /// Cancel ongoing generation
  Future<void> cancelGeneration();
}
