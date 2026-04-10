import 'dart:async';
import '../../domain/entities/model_info.dart';
import './llm_engine_interface.dart';
import './llama_cpp_engine.dart';
import './litert_engine.dart';

/// Configuration for LLM service
class LLMServiceConfig {
  /// LiteRT configuration
  final LiteRtConfig liteRtConfig;

  /// Enable verbose logging
  final bool verboseLogging;

  const LLMServiceConfig({
    LiteRtConfig? liteRtConfig,
    this.verboseLogging = false,
  })  : liteRtConfig = liteRtConfig ?? const LiteRtConfig();

  LLMServiceConfig copyWith({
    LiteRtConfig? liteRtConfig,
    bool? verboseLogging,
  }) {
    return LLMServiceConfig(
      liteRtConfig: liteRtConfig ?? this.liteRtConfig,
      verboseLogging: verboseLogging ?? this.verboseLogging,
    );
  }
}

/// Master LLM Service for running on-device inference with multiple engines.
///
/// Supported Engines:
/// - **LiteRT-LM**: Google's high-performance runtime with NPU/GPU acceleration
///   - Best for: Gemma models, maximum speed on Android
///   - Formats: .litertlm, .task
///   - Backends: NPU (Android), GPU (OpenCL/Vulkan/Metal), CPU
///
/// - **llama.cpp**: Industry-standard GGUF runtime with extensive model support
///   - Best for: Wide model compatibility, cross-platform
///   - Formats: .gguf
///   - Backends: CPU, CUDA (NVIDIA), Metal (Apple), Vulkan, OpenCL
///
/// Features:
/// - Automatic engine selection based on model type
/// - GPU/NPU acceleration with fallback
/// - Memory-efficient loading/unloading
/// - Streaming responses
/// - Configuration presets for different device tiers
class LLMService {
  LocalLlmEngine? _activeEngine;
  LlmRuntime? _activeRuntime;
  bool _isLoaded = false;
  LLMServiceConfig _config;
  String? _currentModelPath;

  LLMService([LLMServiceConfig? config]) : _config = config ?? const LLMServiceConfig();

  /// Get current configuration
  LLMServiceConfig get config => _config;

  /// Update configuration
  void updateConfig(LLMServiceConfig newConfig) {
    _config = newConfig;
  }

  /// Check if model is loaded
  bool get isModelLoaded => _isLoaded && _activeEngine != null;

  /// Get currently active runtime
  LlmRuntime? get activeRuntime => _activeRuntime;

  /// Get currently active engine
  LocalLlmEngine? get activeEngine => _activeEngine;

  /// Get current model path
  String? get currentModelPath => _currentModelPath;

  /// Detect the best runtime for a model file
  static LlmRuntime detectRuntime(String modelPath) {
    final lower = modelPath.toLowerCase();

    // LiteRT formats
    if (lower.endsWith('.litertlm') || lower.endsWith('.task')) {
      return LlmRuntime.liteRT;
    }

    // GGUF format
    if (lower.endsWith('.gguf') || lower.endsWith('.gguf.bin')) {
      // Default to CPU, will be upgraded if GPU is available
      return LlmRuntime.llamaCpp;
    }

    // Legacy formats
    if (lower.endsWith('.bin') || lower.endsWith('.tflite')) {
      return LlmRuntime.liteRT;
    }

    throw Exception('Unknown model format. Supported: .gguf, .litertlm, .task, .bin, .tflite');
  }

  /// Check if runtime is available on current device
  static Future<bool> isRuntimeAvailable(LlmRuntime runtime) async {
    try {
      switch (runtime) {
        case LlmRuntime.liteRT:
        case LlmRuntime.liteRTNpu:
        case LlmRuntime.liteRTGpu:
          // Test LiteRT availability
          await LiteRTEngine.isGpuAvailable();
          return true;

        case LlmRuntime.llamaCpp:
        case LlmRuntime.llamaCppCuda:
        case LlmRuntime.llamaCppMetal:
        case LlmRuntime.llamaCppVulkan:
        case LlmRuntime.llamaCppOpenCL:
          // flutter_llama auto-compiles, so it's always available
          return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  /// Get all available runtimes on current device
  static Future<List<LlmRuntime>> getAvailableRuntimes() async {
    final available = <LlmRuntime>[];

    // Test LiteRT
    if (await isRuntimeAvailable(LlmRuntime.liteRT)) {
      available.add(LlmRuntime.liteRT);
      available.add(LlmRuntime.liteRTGpu);

      if (await LiteRTEngine.isGpuAvailable()) {
        available.add(LlmRuntime.liteRTNpu);
      }
    }

    // Test llama.cpp
    if (await isRuntimeAvailable(LlmRuntime.llamaCpp)) {
      available.add(LlmRuntime.llamaCpp);
      available.add(LlmRuntime.llamaCppVulkan);  // Android/iOS GPU
    }

    return available;
  }

  /// Get device recommendation based on hardware
  static Future<DeviceRecommendation> getDeviceRecommendation() async {
    // TODO: Implement RAM/CPU/GPU detection
    return const DeviceRecommendation(
      recommendedRuntime: LlmRuntime.liteRT,
      availableRamGB: 4,
      hasGpu: false,
      hasNpu: false,
    );
  }

  /// Initialize model using specified runtime
  Future<void> initializeModel(String modelPath, {LlmRuntime? runtime}) async {
    try {
      // Auto-detect runtime if not specified
      final detectedRuntime = runtime ?? detectRuntime(modelPath);

      // Dispose existing engine if any
      await unloadModel();

      // Create appropriate engine based on runtime
      switch (detectedRuntime) {
        case LlmRuntime.liteRT:
        case LlmRuntime.liteRTNpu:
        case LlmRuntime.liteRTGpu:
          final liteRtConfig = LiteRtConfig(
            maxTokens: _config.liteRtConfig.maxTokens,
          );

          _activeEngine = LiteRTEngine(liteRtConfig);
          _activeRuntime = detectedRuntime;
          break;

        case LlmRuntime.llamaCpp:
        case LlmRuntime.llamaCppCuda:
        case LlmRuntime.llamaCppMetal:
        case LlmRuntime.llamaCppVulkan:
        case LlmRuntime.llamaCppOpenCL:
          _activeEngine = LlamaCppEngine();
          _activeRuntime = detectedRuntime;
          break;
      }

      await _activeEngine!.loadModel(modelPath);
      _currentModelPath = modelPath;
      _isLoaded = true;

      if (_config.verboseLogging) {
        print('[LLMService] Model loaded: $modelPath with runtime: $detectedRuntime');
      }
    } catch (e) {
      _isLoaded = false;
      _activeEngine = null;
      _activeRuntime = null;
      throw Exception('Failed to load model: $e');
    }
  }

  /// Generate response (non-streaming)
  Future<String> generate({
    required String prompt,
    int maxTokens = 1024,
    double temperature = 0.3,
    double topP = 0.9,
    int topK = 40,
  }) async {
    if (!isModelLoaded) throw Exception('Model not loaded');

    final sb = StringBuffer();
    await for (final token in generateStream(
      prompt: prompt,
      maxTokens: maxTokens,
      temperature: temperature,
      topP: topP,
      topK: topK,
    )) {
      sb.write(token);
    }
    return sb.toString();
  }

  /// Generate responses with streaming
  Stream<String> generateStream({
    required String prompt,
    int maxTokens = 1024,
    double temperature = 0.3,
    double topP = 0.9,
    int topK = 40,
  }) async* {
    if (!isModelLoaded) throw Exception('Model not loaded');
    yield* _activeEngine!.generateStream(
      prompt: prompt,
      maxTokens: maxTokens,
      temperature: temperature,
      topP: topP,
      topK: topK,
    );
  }

  /// Unload model from memory
  Future<void> unloadModel() async {
    await _activeEngine?.unloadModel();
    _activeEngine?.dispose();
    _activeEngine = null;
    _activeRuntime = null;
    _currentModelPath = null;
    _isLoaded = false;
  }

  /// Cancel ongoing generation
  Future<void> cancelGeneration() async {
    _activeEngine?.reset();
  }

  /// Clear chat history (keep model loaded)
  void clearHistory() {
    _activeEngine?.reset();
  }

  /// Set system prompt for the session
  void setSystemPrompt(String prompt) {
    _activeEngine?.setSystemPrompt(prompt);
  }

  /// Get engine-specific metadata
  Future<Map<String, dynamic>> getEngineInfo() async {
    final info = <String, dynamic>{
      'isLoaded': _isLoaded,
      'runtime': _activeRuntime?.name ?? 'none',
      'modelPath': _currentModelPath,
    };

    if (_activeEngine is LiteRTEngine) {
      info['engine'] = 'LiteRT-LM';
      info['gpuAvailable'] = await LiteRTEngine.isGpuAvailable();
    } else if (_activeEngine is LlamaCppEngine) {
      info['engine'] = 'llama.cpp';
      info['gpuAvailable'] = await LlamaCppEngine.isGpuAvailable();
    }

    return info;
  }

  /// Dispose service
  void dispose() {
    unloadModel();
  }
}

/// Device recommendation info
class DeviceRecommendation {
  final LlmRuntime recommendedRuntime;
  final int availableRamGB;
  final bool hasGpu;
  final bool hasNpu;

  const DeviceRecommendation({
    required this.recommendedRuntime,
    required this.availableRamGB,
    required this.hasGpu,
    required this.hasNpu,
  });
}
