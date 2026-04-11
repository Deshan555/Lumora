import 'dart:async';
import '../../domain/entities/model_info.dart';
import './llm_engine_interface.dart';
import './llama_cpp_engine.dart';

/// Configuration for LLM service
class LLMServiceConfig {
  /// Enable verbose logging
  final bool verboseLogging;

  const LLMServiceConfig({
    this.verboseLogging = false,
  });

  LLMServiceConfig copyWith({
    bool? verboseLogging,
  }) {
    return LLMServiceConfig(
      verboseLogging: verboseLogging ?? this.verboseLogging,
    );
  }
}

/// Master LLM Service for running on-device inference with multiple engines.
///
/// Supported Engines:
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

    // GGUF format
    if (lower.endsWith('.gguf') || lower.endsWith('.gguf.bin')) {
      // Default to CPU, will be upgraded if GPU is available
      return LlmRuntime.llamaCpp;
    }

    throw Exception('Unknown model format. Supported: .gguf');
  }

  /// Check if runtime is available on current device
  static Future<bool> isRuntimeAvailable(LlmRuntime runtime) async {
    try {
      switch (runtime) {
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
  }

  /// Get all available runtimes on current device
  static Future<List<LlmRuntime>> getAvailableRuntimes() async {
    final available = <LlmRuntime>[];

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
      recommendedRuntime: LlmRuntime.llamaCpp,
      availableRamGB: 4,
      hasGpu: false,
      hasNpu: false,
    );
  }

  /// Initialize model using specified runtime
  /// 
  /// Parameters:
  /// - [modelPath]: Path to the model file
  /// - [runtime]: Explicitly choose the engine/runtime to use
  ///   If null, auto-detects from file extension
  /// - [forceEngine]: If true, uses the specified runtime even if the file 
  ///   extension doesn't match (useful for testing or special cases)
  Future<void> initializeModel(
    String modelPath, {
    LlmRuntime? runtime,
    bool forceEngine = false,
  }) async {
    try {
      // Determine which runtime to use
      final detectedRuntime = detectRuntime(modelPath);
      final selectedRuntime = forceEngine ? (runtime ?? detectedRuntime) : (runtime ?? detectedRuntime);

      // Dispose existing engine if any
      await unloadModel();

      // Create appropriate engine based on selected runtime
      switch (selectedRuntime) {
        case LlmRuntime.llamaCpp:
        case LlmRuntime.llamaCppCuda:
        case LlmRuntime.llamaCppMetal:
        case LlmRuntime.llamaCppVulkan:
        case LlmRuntime.llamaCppOpenCL:
          _activeEngine = LlamaCppEngine();
          _activeRuntime = selectedRuntime;
          break;
      }

      await _activeEngine!.loadModel(modelPath);
      _currentModelPath = modelPath;
      _isLoaded = true;

      if (_config.verboseLogging) {
        print('[LLMService] Model loaded: $modelPath');
        print('[LLMService] Auto-detected runtime: $detectedRuntime');
        print('[LLMService] Selected runtime: $selectedRuntime');
        if (forceEngine) {
          print('[LLMService] ⚠️ Forced engine selection (file extension: $detectedRuntime)');
        }
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

    if (_activeEngine is LlamaCppEngine) {
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
