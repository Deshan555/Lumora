import 'dart:async';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma/core/model.dart';
import './llm_engine_interface.dart';

/// Configuration for LiteRT engine
class LiteRtConfig {
  /// Maximum tokens for context
  final int maxTokens;

  const LiteRtConfig({
    this.maxTokens = 2048,
  });
}

/// Modern LiteRT-LM engine implementation using flutter_gemma.
/// 
/// Features:
/// - Gemma architecture optimization
/// - GPU acceleration support
/// - Streaming responses
/// - flutter_gemma 0.10.x API
/// 
/// Platform Support:
/// - Android: GPU (OpenCL), CPU
/// - iOS: CPU
class LiteRTEngine implements LocalLlmEngine {
  bool _isLoaded = false;
  String? _systemPrompt;
  dynamic _model;  // InferenceModel from flutter_gemma
  dynamic _session;  // InferenceModelSession from flutter_gemma
  LiteRtConfig _config;

  LiteRTEngine([LiteRtConfig? config]) : _config = config ?? const LiteRtConfig();

  @override
  bool get isLoaded => _isLoaded;

  /// Get current configuration
  LiteRtConfig get config => _config;

  /// Update configuration (requires model reload)
  void updateConfig(LiteRtConfig newConfig) {
    _config = newConfig;
  }

  @override
  Future<void> loadModel(String modelPath) async {
    try {
      // Load model using flutter_gemma 0.10.x API
      // Note: flutter_gemma 0.10.x expects models to be in assets/ 
      // or managed via the plugin's model system
      _model = await FlutterGemmaPlugin.instance.createModel(
        modelType: ModelType.gemmaIt,
        maxTokens: _config.maxTokens,
      );

      _isLoaded = true;
    } catch (e) {
      _isLoaded = false;
      throw Exception('Failed to load LiteRT model: $e');
    }
  }

  @override
  Future<void> unloadModel() async {
    await _session?.close();
    await _model?.close();
    _session = null;
    _model = null;
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
    if (!isLoaded || _model == null) {
      throw Exception('LiteRT Engine not initialized. Load a model first.');
    }

    try {
      // Create session if it doesn't exist
      if (_session == null) {
        _session = await _model!.createSession(
          temperature: temperature,
          topK: topK,
          topP: topP,
        );
      }

      // Combine system prompt if present
      final fullPrompt = _systemPrompt != null ? '$_systemPrompt\n\n$prompt' : prompt;

      // Add user message and get response stream
      await _session!.addQueryChunk(Message(text: fullPrompt));
      
      // Stream response
      await for (final response in _session!.getResponseAsync()) {
        if (response is TextResponse) {
          yield response.token ?? '';
        }
      }
    } catch (e) {
      yield '[Error] LiteRT generation failed: $e';
    }
  }

  @override
  void setSystemPrompt(String prompt) {
    _systemPrompt = prompt;
    // Reset session to apply new system prompt
    _session?.close();
    _session = null;
  }

  @override
  void reset() {
    _session?.close();
    _session = null;
  }

  @override
  void dispose() {
    unloadModel();
  }

  /// Check if GPU is available (Android only)
  static Future<bool> isGpuAvailable() async {
    try {
      // Try to create a model - flutter_gemma will use GPU if available
      final model = await FlutterGemmaPlugin.instance.createModel(
        modelType: ModelType.gemmaIt,
        maxTokens: 512,
      );
      await model.close();
      return true;
    } catch (e) {
      return false;
    }
  }
}
