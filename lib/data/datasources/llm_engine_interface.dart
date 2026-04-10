import 'dart:async';

/// Common interface for local on-device LLM engines.
abstract class LocalLlmEngine {
  /// Whether the model is currently loaded in memory.
  bool get isLoaded;

  /// Load a model from a specific path.
  Future<void> loadModel(String modelPath);

  /// Unload the model to free up resources.
  Future<void> unloadModel();

  /// Generate a streaming response.
  Stream<String> generateStream({
    required String prompt,
    int maxTokens = 1024,
    double temperature = 0.3,
    double topP = 0.9,
    int topK = 40,
  });

  /// Set the system instructions for the engine.
  void setSystemPrompt(String prompt);

  /// Reset the conversation context (clear history).
  void reset();

  /// Dispose the engine.
  void dispose();
}
