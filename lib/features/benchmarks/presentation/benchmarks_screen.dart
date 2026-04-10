import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/di/repository_providers.dart';
import '../../../core/di/state_providers.dart';
import '../../../core/theme/edge_theme.dart';
import '../../../core/utils/benchmark_service.dart';
import '../../../core/utils/ram_history.dart';
import '../../../data/datasources/llm_service.dart';

/// Benchmarks screen for testing model performance
class BenchmarksScreen extends ConsumerStatefulWidget {
  const BenchmarksScreen({super.key});

  @override
  ConsumerState<BenchmarksScreen> createState() => _BenchmarksScreenState();
}

class _BenchmarksScreenState extends ConsumerState<BenchmarksScreen> {
  BenchmarkResult? _lastResult;
  bool _isRunning = false;
  String _currentStep = '';

  Future<void> _runBenchmark() async {
    final activeModel = ref.read(activeModelProvider);
    if (activeModel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please load a model first')),
      );
      return;
    }

    setState(() {
      _isRunning = true;
      _currentStep = 'Starting benchmark...';
    });

    try {
      final llmService = ref.read(llmServiceProvider);
      final benchmark = BenchmarkService(llmService);

      setState(() => _currentStep = 'Running tests...');

      final result = await benchmark.runBenchmark(activeModel.name);

      // Record RAM usage
      await RamHistoryTracker.recordUsage(activeModel: activeModel.name);

      if (mounted) {
        setState(() {
          _lastResult = result;
          _isRunning = false;
          _currentStep = '';
        });

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('✅ Benchmark Complete'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Model: ${result.modelName}'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        BenchmarkService.getTier(result.tokensPerSecond),
                        style: const TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${result.tokensPerSecond.toStringAsFixed(1)} tokens/sec',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Grade: ${BenchmarkService.getGrade(result.tokensPerSecond)}'),
                  const SizedBox(height: 8),
                  Text('Total tokens: ${result.tokensGenerated}'),
                  Text('Test prompts: ${result.promptTokens}'),
                  Text('Total time: ${result.promptProcessingTime.toStringAsFixed(1)}s'),
                  Text('Peak RAM: ${result.peakRamMB}MB'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRunning = false;
          _currentStep = '';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Benchmark failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeModel = ref.watch(activeModelProvider);

    return Scaffold(
      backgroundColor: EdgeTheme.primaryBackground,
      appBar: AppBar(
        title: const Text('Performance Metrics'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const FaIcon(FontAwesomeIcons.barsStaggered, size: 18),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: EdgeTheme.surfaceColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: EdgeTheme.lavender.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const FaIcon(FontAwesomeIcons.gaugeHigh, color: EdgeTheme.lavender, size: 20),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CORE DIAGNOSTICS',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Quantifying neural throughput',
                              style: TextStyle(
                                fontSize: 13,
                                color: EdgeTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Precision measurements across multiple neural layers:\n'
                    '• TOKENS PER SECOND (TPS)\n'
                    '• PREFILL LATENCY\n'
                    '• NEURAL MEMORY (RAM)\n'
                    '• PERFORMANCE TIER',
                    style: TextStyle(fontSize: 13, height: 1.8, color: EdgeTheme.textSecondary, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 24),
                  if (activeModel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: EdgeTheme.lavender.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'TARGET: ${activeModel.name.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: EdgeTheme.lavender,
                          letterSpacing: 1,
                        ),
                      ),
                    )
                  else
                    const Text(
                      '⚠️ No model loaded',
                      style: TextStyle(color: Colors.orange),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Run button
            Container(
              decoration: BoxDecoration(
                boxShadow: (!_isRunning && activeModel != null) ? EdgeTheme.purpleGlow(EdgeTheme.lavender.withValues(alpha: 0.2)) : [],
              ),
              child: ElevatedButton(
                onPressed: (activeModel != null && !_isRunning) ? _runBenchmark : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: EdgeTheme.lavender,
                  foregroundColor: EdgeTheme.primaryBackground,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: _isRunning
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: EdgeTheme.primaryBackground),
                          ),
                          const SizedBox(width: 16),
                          Text(_currentStep.toUpperCase(), style: const TextStyle(letterSpacing: 1, fontWeight: FontWeight.bold)),
                        ],
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(FontAwesomeIcons.bolt, size: 16),
                          const SizedBox(width: 12),
                          Text('INITIATE DIAGNOSTIC', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, letterSpacing: 1)),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 24),

            if (_lastResult != null) ...[
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: EdgeTheme.brainyGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: EdgeTheme.purpleGlow(EdgeTheme.lavender),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRECISION READOUT',
                      style: TextStyle(
                        color: EdgeTheme.primaryBackground.withValues(alpha: 0.7),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          BenchmarkService.getTier(_lastResult!.tokensPerSecond),
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${_lastResult!.tokensPerSecond.toStringAsFixed(1)} TOK/S',
                              style: const TextStyle(
                                color: EdgeTheme.primaryBackground,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              BenchmarkService.getGrade(_lastResult!.tokensPerSecond).toUpperCase(),
                              style: TextStyle(
                                color: EdgeTheme.primaryBackground.withValues(alpha: 0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('UNIT', '${_lastResult!.tokensGenerated}', isLight: true),
                        _buildStat('LATENCY', '${_lastResult!.promptProcessingTime.toStringAsFixed(1)}s', isLight: true),
                        _buildStat('MEMORY', '${_lastResult!.peakRamMB}MB', isLight: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Performance scale
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: EdgeTheme.surfaceColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Performance Scale',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildScaleItem('🏆', 'Excellent', '50+ tok/s', 'High-end devices'),
                  _buildScaleItem('⭐', 'Very Good', '30-50 tok/s', 'Mid-range devices'),
                  _buildScaleItem('👍', 'Good', '20-30 tok/s', 'Average devices'),
                  _buildScaleItem('⚡', 'Fair', '10-20 tok/s', 'Low-end devices'),
                  _buildScaleItem('🐌', 'Slow', '<10 tok/s', 'Very low-end devices'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, {bool isLight = false}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: isLight ? EdgeTheme.primaryBackground : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: isLight ? EdgeTheme.primaryBackground.withValues(alpha: 0.6) : EdgeTheme.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildScaleItem(String icon, String grade, String range, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$grade ($range)',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                  Text(
                    description.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: EdgeTheme.textTertiary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
