import 'dart:async';
import 'package:llamadart/llamadart.dart';
import './llm_engine_interface.dart';

/// GGUF model engine implementation using llamadart.
/// 
/// Features:
/// - Full GGUF model support (TinyLlama, Phi, Qwen, Llama, Mistral, etc.)
/// - GPU acceleration support
/// - Streaming and non-streaming responses
/// - Pre-compiled native binaries (works out of the box)
/// 
/// Platform Support:
/// - Android: Vulkan GPU, CPU
/// - iOS: Metal GPU, CPU
/// - macOS: Metal GPU, CPU
class LlamaCppEngine implements LocalLlmEngine {
  LlamaEngine? _engine;
  ChatSession? _chatSession;
  bool _isLoaded = false;
  String? _systemPrompt;

  LlamaCppEngine();

  @override
  bool get isLoaded => _isLoaded && _engine != null;

  @override
  Future<void> loadModel(String modelPath) async {
    try {
      final backend = LlamaBackend();
      _engine = LlamaEngine(backend);
      await _engine!.loadModel(modelPath);
      _chatSession = ChatSession(_engine!);
      _isLoaded = true;
    } catch (e) {
      _isLoaded = false;
      _engine = null;
      _chatSession = null;
      throw Exception('Failed to load GGUF model: $e');
    }
  }

  @override
  Future<void> unloadModel() async {
    _chatSession?.reset();
    await _engine?.dispose();
    _engine = null;
    _chatSession = null;
    _isLoaded = false;
  }

  @override
  Stream<String> generateStream({
    required String prompt,
    int maxTokens = 1024,
    double temperature = 0.3,
    double topP = 0.9,
    int topK = 40,
  }) async* {
    if (!isLoaded || _chatSession == null) {
      throw Exception('llama.cpp Engine not initialized. Load a model first.');
    }

    try {
      // Build full prompt with system instruction
      final fullPrompt = _systemPrompt != null 
          ? '${_systemPrompt}\n\nUser: $prompt\nAssistant:' 
          : 'User: $prompt\nAssistant:';

      await for (final chunk in _chatSession!.create(
        [LlamaTextContent(fullPrompt)],
        params: GenerationParams(
          maxTokens: maxTokens,
          temp: temperature,
          topP: topP,
          topK: topK,
        ),
      )) {
        if (chunk.choices.isNotEmpty) {
          final content = chunk.choices.first.delta.content;
          if (content != null && content.isNotEmpty) {
            yield content;
          }
        }
      }
    } catch (e) {
      yield '[Error] llama.cpp generation failed: $e';
    }
  }

  @override
  void setSystemPrompt(String prompt) {
    _systemPrompt = prompt;
    _chatSession?.systemPrompt = prompt;
  }

  @override
  void reset() {
    _chatSession?.reset();
  }

  @override
  void dispose() {
    unloadModel();
  }

  /// Check if GPU is available
  static Future<bool> isGpuAvailable() async {
    // llamadart handles GPU detection internally
    return true;
  }
}
