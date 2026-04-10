import 'dart:io';
import '../../domain/entities/model_info.dart';
import '../../data/datasources/llama_cpp_engine.dart';
import '../../data/datasources/litert_engine.dart';

/// Model metadata extracted from file
class ExtractedModelMetadata {
  /// Model architecture (e.g., llama, gemma, phi3, qwen2)
  final String architecture;

  /// Number of parameters
  final int parameterCount;

  /// Quantization type (e.g., Q4_K_M, Q5_K_M, F16)
  final String quantizationType;

  /// Context length the model was trained with
  final int contextLength;

  /// Recommended context size
  final int recommendedContext;

  /// Model file size in bytes
  final int fileSize;

  /// Model format (GGUF, LiteRT, etc.)
  final String format;

  /// Whether the file is valid
  final bool isValid;

  /// Error message if invalid
  final String? error;

  const ExtractedModelMetadata({
    required this.architecture,
    required this.parameterCount,
    required this.quantizationType,
    required this.contextLength,
    required this.recommendedContext,
    required this.fileSize,
    required this.format,
    required this.isValid,
    this.error,
  });

  /// Get human-readable parameter count
  String get parameterCountFormatted {
    if (parameterCount >= 1000000000) {
      return '${(parameterCount / 1000000000).toStringAsFixed(1)}B';
    }
    return '${(parameterCount / 1000000).toStringAsFixed(0)}M';
  }

  /// Get human-readable file size
  String get fileSizeFormatted {
    if (fileSize >= 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(0)} MB';
  }

  /// Get estimated RAM requirement
  int get estimatedRamRequirementGB {
    // Rough estimate: model size + overhead
    final sizeGB = fileSize / (1024 * 1024 * 1024);
    return (sizeGB * 1.5).ceil().clamp(2, 16);
  }
}

/// Utility for extracting and validating model metadata
class ModelMetadataExtractor {
  /// Extract metadata from a model file
  static Future<ExtractedModelMetadata> extractMetadata(String modelPath) async {
    final file = File(modelPath);
    
    if (!await file.exists()) {
      return ExtractedModelMetadata(
        architecture: 'unknown',
        parameterCount: 0,
        quantizationType: 'unknown',
        contextLength: 0,
        recommendedContext: 2048,
        fileSize: 0,
        format: 'unknown',
        isValid: false,
        error: 'File not found: $modelPath',
      );
    }

    final fileSize = await file.length();
    final lowerPath = modelPath.toLowerCase();

    // Extract based on format
    if (lowerPath.endsWith('.gguf')) {
      return await _extractGgufMetadata(modelPath, fileSize);
    } else if (lowerPath.endsWith('.litertlm') || lowerPath.endsWith('.task')) {
      return await _extractLitertMetadata(modelPath, fileSize);
    } else if (lowerPath.endsWith('.bin') || lowerPath.endsWith('.tflite')) {
      return await _extractLegacyMetadata(modelPath, fileSize);
    }

    return ExtractedModelMetadata(
      architecture: 'unknown',
      parameterCount: 0,
      quantizationType: 'unknown',
      contextLength: 0,
      recommendedContext: 2048,
      fileSize: fileSize,
      format: 'unknown',
      isValid: false,
      error: 'Unknown model format',
    );
  }

  /// Extract GGUF model metadata using llama.cpp
  static Future<ExtractedModelMetadata> _extractGgufMetadata(
    String modelPath,
    int fileSize,
  ) async {
    try {
      final metadata = await LlamaCppEngine.extractMetadata(modelPath);
      
      if (metadata == null) {
        return ExtractedModelMetadata(
          architecture: 'unknown',
          parameterCount: 0,
          quantizationType: 'unknown',
          contextLength: 0,
          recommendedContext: 2048,
          fileSize: fileSize,
          format: 'GGUF',
          isValid: false,
          error: 'Failed to read GGUF metadata',
        );
      }

      // Extract values from metadata
      final architecture = metadata.architecture ?? 'unknown';
      final parameterCount = metadata.parameterCount ?? 0;
      final quantizationType = metadata.quantizationType ?? 'unknown';
      final contextLength = metadata.contextLength ?? 0;

      return ExtractedModelMetadata(
        architecture: architecture,
        parameterCount: parameterCount,
        quantizationType: quantizationType,
        contextLength: contextLength,
        recommendedContext: contextLength > 0 ? contextLength : 2048,
        fileSize: fileSize,
        format: 'GGUF',
        isValid: true,
      );
    } catch (e) {
      return ExtractedModelMetadata(
        architecture: 'unknown',
        parameterCount: 0,
        quantizationType: 'unknown',
        contextLength: 0,
        recommendedContext: 2048,
        fileSize: fileSize,
        format: 'GGUF',
        isValid: false,
        error: 'Error extracting GGUF metadata: $e',
      );
    }
  }

  /// Extract LiteRT model metadata
  static Future<ExtractedModelMetadata> _extractLitertMetadata(
    String modelPath,
    int fileSize,
  ) async {
    try {
      // LiteRT models don't have easy metadata extraction
      // We can infer some information from the filename
      final filename = modelPath.split('/').last.toLowerCase();
      
      String architecture = 'unknown';
      if (filename.contains('gemma')) {
        architecture = 'gemma';
      } else if (filename.contains('llama')) {
        architecture = 'llama';
      } else if (filename.contains('phi')) {
        architecture = 'phi';
      } else if (filename.contains('qwen')) {
        architecture = 'qwen';
      }

      // Estimate parameters based on file size
      // Rough estimation for quantized models
      final bytesPerParam = 0.8; // Average for Q4 quantization
      final parameterCount = (fileSize / bytesPerParam).round();

      return ExtractedModelMetadata(
        architecture: architecture,
        parameterCount: parameterCount,
        quantizationType: 'LiteRT',
        contextLength: 0,
        recommendedContext: 4096,
        fileSize: fileSize,
        format: 'LiteRT-LM',
        isValid: true,
      );
    } catch (e) {
      return ExtractedModelMetadata(
        architecture: 'unknown',
        parameterCount: 0,
        quantizationType: 'unknown',
        contextLength: 0,
        recommendedContext: 2048,
        fileSize: fileSize,
        format: 'LiteRT-LM',
        isValid: false,
        error: 'Error extracting LiteRT metadata: $e',
      );
    }
  }

  /// Extract legacy model metadata
  static Future<ExtractedModelMetadata> _extractLegacyMetadata(
    String modelPath,
    int fileSize,
  ) async {
    try {
      final filename = modelPath.split('/').last.toLowerCase();
      
      String architecture = 'unknown';
      if (filename.contains('gemma')) {
        architecture = 'gemma';
      } else if (filename.contains('llama')) {
        architecture = 'llama';
      } else if (filename.contains('phi')) {
        architecture = 'phi';
      }

      return ExtractedModelMetadata(
        architecture: architecture,
        parameterCount: 0,
        quantizationType: 'unknown',
        contextLength: 0,
        recommendedContext: 2048,
        fileSize: fileSize,
        format: 'Legacy',
        isValid: true,
      );
    } catch (e) {
      return ExtractedModelMetadata(
        architecture: 'unknown',
        parameterCount: 0,
        quantizationType: 'unknown',
        contextLength: 0,
        recommendedContext: 2048,
        fileSize: fileSize,
        format: 'Legacy',
        isValid: false,
        error: 'Error extracting legacy metadata: $e',
      );
    }
  }

  /// Validate a model file can be loaded
  static Future<ModelValidationResult> validateModel(String modelPath) async {
    final metadata = await extractMetadata(modelPath);
    
    if (!metadata.isValid) {
      return ModelValidationResult(
        isValid: false,
        metadata: metadata,
        errors: [metadata.error ?? 'Unknown error'],
        warnings: [],
      );
    }

    final warnings = <String>[];
    final errors = <String>[];

    // Check file size
    if (metadata.fileSize < 100 * 1024 * 1024) {
      warnings.add('Model file is unusually small (< 100MB)');
    }

    // Check context length
    if (metadata.contextLength > 0 && metadata.contextLength < 1024) {
      warnings.add('Very small context length (${metadata.contextLength} tokens)');
    }

    // Check if format is supported
    if (!['GGUF', 'LiteRT-LM', 'Legacy'].contains(metadata.format)) {
      errors.add('Unsupported model format: ${metadata.format}');
    }

    return ModelValidationResult(
      isValid: errors.isEmpty,
      metadata: metadata,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Detect the appropriate runtime for a model file
  static LlmRuntime detectRuntime(String modelPath) {
    final lowerPath = modelPath.toLowerCase();

    if (lowerPath.endsWith('.litertlm')) {
      return LlmRuntime.liteRTGpu;
    }
    if (lowerPath.endsWith('.task')) {
      return LlmRuntime.liteRT;
    }
    if (lowerPath.endsWith('.gguf')) {
      return LlmRuntime.llamaCpp;
    }
    if (lowerPath.endsWith('.bin') || lowerPath.endsWith('.tflite')) {
      return LlmRuntime.liteRT;
    }

    throw Exception('Unknown model format');
  }

  /// Get recommended configuration for a model
  static ModelRecommendation getRecommendation(String modelPath) async {
    final metadata = await extractMetadata(modelPath);
    final runtime = detectRuntime(modelPath);

    // Get device RAM (TODO: implement actual detection)
    final deviceRamGB = 4; // Placeholder

    // Recommend configuration based on model size and device
    int contextSize = metadata.recommendedContext;
    int gpuLayers = 0;

    if (runtime == LlmRuntime.llamaCpp) {
      // Adjust based on available RAM
      if (deviceRamGB <= 4) {
        contextSize = contextSize.clamp(512, 2048);
        gpuLayers = 0; // CPU only for low RAM
      } else if (deviceRamGB <= 6) {
        contextSize = contextSize.clamp(1024, 4096);
        gpuLayers = 20; // Partial GPU offload
      } else {
        contextSize = contextSize.clamp(2048, 8192);
        gpuLayers = 99; // Full GPU offload
      }
    }

    return ModelRecommendation(
      runtime: runtime,
      contextSize: contextSize,
      gpuLayers: gpuLayers,
      estimatedRamGB: metadata.estimatedRamRequirementGB,
    );
  }
}

/// Model validation result
class ModelValidationResult {
  final bool isValid;
  final ExtractedModelMetadata metadata;
  final List<String> errors;
  final List<String> warnings;

  const ModelValidationResult({
    required this.isValid,
    required this.metadata,
    required this.errors,
    required this.warnings,
  });
}

/// Model configuration recommendation
class ModelRecommendation {
  final LlmRuntime runtime;
  final int contextSize;
  final int gpuLayers;
  final int estimatedRamGB;

  const ModelRecommendation({
    required this.runtime,
    required this.contextSize,
    required this.gpuLayers,
    required this.estimatedRamGB,
  });
}
