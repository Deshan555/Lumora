/// Repository interface for AI chat
abstract class ICorrectionRepository {
  /// Initialize the LLM with a model file
  Future<void> initializeModel(String modelPath);

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
