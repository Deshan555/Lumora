import 'dart:math';
import 'package:flutter/material.dart';

class FullscreenThinkingVisualizer extends StatefulWidget {
  const FullscreenThinkingVisualizer({super.key});

  @override
  State<FullscreenThinkingVisualizer> createState() => _FullscreenThinkingVisualizerState();
}

class _FullscreenThinkingVisualizerState extends State<FullscreenThinkingVisualizer> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _opacityController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
    
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_waveController, _opacityController]),
      builder: (context, _) {
        return CustomPaint(
          size: Size.infinite,
          painter: _NeonWavePainter(time: _waveController.value, opacityPulse: _opacityController.value),
        );
      },
    );
  }
}

class _NeonWavePainter extends CustomPainter {
  final double time;
  final double opacityPulse;

  _NeonWavePainter({required this.time, required this.opacityPulse});

  @override
  void paint(Canvas canvas, Size size) {
    final double midY = size.height / 2;
    final double midX = size.width / 2;
    
    // Draw sweeping abstract Siri-style glowing waves mixed with a soft background gradient
    final colors = [
      const Color(0xFF00E5FF), // Cyan
      const Color(0xFF8B5CF6), // Violet
      const Color(0xFF3B82F6), // Blue
      const Color(0xFFF472B6), // Pink
    ];

    // Center circular glow ring to match the OpenAI ring concept
    final ringRadius = size.width * 0.4 + (opacityPulse * 20);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

    // Give the ring a beautiful sweeping gradient shader
    ringPaint.shader = SweepGradient(
      colors: [colors[0], colors[1], colors[2], colors[3], colors[0]],
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(time * pi * 2), // Rotates over time
    ).createShader(Rect.fromCircle(center: Offset(midX, midY), radius: ringRadius));

    final coreRingPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white.withValues(alpha: 0.5 + (opacityPulse * 0.3));

    canvas.drawCircle(Offset(midX, midY), ringRadius, ringPaint);
    canvas.drawCircle(Offset(midX, midY), ringRadius, coreRingPaint);
    
    // Horizontal glowing neon waves passing through the center (Siri style)
    for (int i = 0; i < 3; i++) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.0
        ..color = colors[i % colors.length]
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12); // strong glow

      final path = Path();
      final frequency = 1.5 + (i * 0.5);
      final amplitude = 120.0 + (i * 30);
      final phase = time * pi * 2 * (i % 2 == 0 ? 1 : -1) + (i * pi / 3);

      path.moveTo(0, midY);

      for (double x = 0; x <= size.width; x += 5) {
        final normalizedX = x / size.width;
        final envelope = sin(normalizedX * pi); // Tapers at edges
        
        final y = midY + sin((normalizedX * pi * frequency) + phase) * amplitude * envelope;
        path.lineTo(x, y);
      }

      final coreWavePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..color = Colors.white.withValues(alpha: 0.6 + (opacityPulse * 0.2));

      canvas.drawPath(path, paint);
      canvas.drawPath(path, paint); // Double up the glow intensity
      canvas.drawPath(path, coreWavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _NeonWavePainter oldDelegate) => true;
}
