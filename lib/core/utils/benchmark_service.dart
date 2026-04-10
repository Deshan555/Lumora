import 'dart:io';
import '../../data/datasources/llm_service.dart';
import 'system_info.dart';

/// Model benchmark results
class BenchmarkResult {
  final String modelName;
  final DateTime timestamp;
  final int tokensGenerated;
  final double tokensPerSecond;
  final int promptTokens;
  final double promptProcessingTime;
  final int peakRamMB;
  final Map<String, dynamic> details;

  const BenchmarkResult({
    required this.modelName,
    required this.timestamp,
    required this.tokensGenerated,
    required this.tokensPerSecond,
    required this.promptTokens,
    required this.promptProcessingTime,
    required this.peakRamMB,
    required this.details,
  });

  String get summary => '$modelName: ${tokensPerSecond.toStringAsFixed(1)} tok/s';
}

/// Benchmark service for testing model performance
class BenchmarkService {
  final LLMService _llmService;

  BenchmarkService(this._llmService);

  /// Run a comprehensive benchmark
  Future<BenchmarkResult> runBenchmark(String modelName) async {
    if (!_llmService.isModelLoaded) {
      throw Exception('Model not loaded');
    }

    final startTime = DateTime.now();
    int peakRamMB = 0;

    // Test prompts
    const promptTests = [
      'Write a short story about a robot learning to paint.',
      'Explain quantum computing in simple terms.',
      'Write Python code to sort a list using merge sort.',
      'What are the main differences between TCP and UDP?',
      'Solve: If a train travels 120km in 2 hours, what is its speed?',
    ];

    int totalTokens = 0;
    double totalTime = 0;
    final results = <Map<String, dynamic>>[];

    for (final prompt in promptTests) {
      // Measure RAM before
      final ramBefore = await SystemInfoService.getAvailableRamMB();

      // Time the generation
      final genStart = DateTime.now().millisecondsSinceEpoch;
      
      String fullResponse = '';
      int tokenCount = 0;

      await for (final token in _llmService.generateStream(
        prompt: prompt,
        maxTokens: 256,
        temperature: 0.7,
      )) {
        fullResponse += token;
        tokenCount++;
      }

      final genEnd = DateTime.now().millisecondsSinceEpoch;
      final genTime = (genEnd - genStart) / 1000.0; // seconds

      // Measure RAM after
      final ramAfter = await SystemInfoService.getAvailableRamMB();
      final ramUsed = ramBefore - ramAfter;
      if (ramUsed > peakRamMB) peakRamMB = ramUsed;

      totalTokens += tokenCount;
      totalTime += genTime;

      results.add({
        'prompt': prompt.substring(0, 50),
        'tokens': tokenCount,
        'time': genTime,
        'tokPerSec': tokenCount / genTime,
        'ramUsed': ramUsed,
      });
    }

    final endTime = DateTime.now();
    final avgTokPerSec = totalTokens / totalTime;
    final initialRam = await SystemInfoService.getTotalRamMB();

    return BenchmarkResult(
      modelName: modelName,
      timestamp: startTime,
      tokensGenerated: totalTokens,
      tokensPerSecond: avgTokPerSec,
      promptTokens: promptTests.length,
      promptProcessingTime: totalTime,
      peakRamMB: peakRamMB,
      details: {
        'totalTime': (endTime.difference(startTime).inMilliseconds / 1000.0),
        'avgTokensPerPrompt': totalTokens / promptTests.length,
        'avgTimePerPrompt': totalTime / promptTests.length,
        'initialRam': initialRam,
        'peakRamMB': peakRamMB,
        'testResults': results,
      },
    );
  }

  /// Get benchmark grade based on tokens per second
  static String getGrade(double tokensPerSecond) {
    if (tokensPerSecond >= 50) return 'Excellent';
    if (tokensPerSecond >= 30) return 'Very Good';
    if (tokensPerSecond >= 20) return 'Good';
    if (tokensPerSecond >= 10) return 'Fair';
    return 'Slow';
  }

  /// Get performance tier
  static String getTier(double tokensPerSecond) {
    if (tokensPerSecond >= 50) return '🏆';
    if (tokensPerSecond >= 30) return '⭐';
    if (tokensPerSecond >= 20) return '👍';
    if (tokensPerSecond >= 10) return '⚡';
    return '🐌';
  }
}
