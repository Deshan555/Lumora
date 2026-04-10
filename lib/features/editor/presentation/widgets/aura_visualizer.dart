import 'dart:math';
import 'package:flutter/material.dart';
import '../../../../core/theme/edge_theme.dart';

enum AuraState { idle, listening, thinking, speaking }

/// Premium pulsing aura visualizer for Live Chat Mode.
class AuraVisualizer extends StatefulWidget {
  final AuraState state;
  final double amplitude; // 0.0 to 1.0

  const AuraVisualizer({
    super.key,
    required this.state,
    this.amplitude = 0.0,
  });

  @override
  State<AuraVisualizer> createState() => _AuraVisualizerState();
}

class _AuraVisualizerState extends State<AuraVisualizer>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _pulseAnim = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  Color get _primaryColor {
    switch (widget.state) {
      case AuraState.listening:
        return const Color(0xFF00E5FF); // Cyan
      case AuraState.thinking:
        return EdgeTheme.lavender;
      case AuraState.speaking:
        return const Color(0xFF69FF47); // Green
      case AuraState.idle:
        return Colors.white38;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseController, _waveController, _rotateController]),
      builder: (context, _) {
        final pulse = _pulseAnim.value;
        final wave = _waveController.value;
        final rotate = _rotateController.value;
        final amp = widget.amplitude.clamp(0.0, 1.0);

        return SizedBox(
          width: 240,
          height: 240,
          child: CustomPaint(
            painter: _AuraPainter(
              pulse: pulse,
              wave: wave,
              rotate: rotate,
              amplitude: amp,
              primaryColor: _primaryColor,
              state: widget.state,
            ),
          ),
        );
      },
    );
  }
}

class _AuraPainter extends CustomPainter {
  final double pulse;
  final double wave;
  final double rotate;
  final double amplitude;
  final Color primaryColor;
  final AuraState state;

  _AuraPainter({
    required this.pulse,
    required this.wave,
    required this.rotate,
    required this.amplitude,
    required this.primaryColor,
    required this.state,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.width * 0.3;
    final dynamicRadius = baseRadius + (amplitude * baseRadius * 0.4) + (pulse * 8);

    // Draw outer glow rings
    for (int i = 3; i >= 1; i--) {
      final ringRadius = dynamicRadius + (i * 18.0) + (pulse * i * 6);
      final glowPaint = Paint()
        ..color = primaryColor.withValues(alpha: (0.06 * (4 - i)).clamp(0.0, 1.0))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
      canvas.drawCircle(center, ringRadius, glowPaint);
    }

    // Draw orbiting particles
    if (state != AuraState.idle) {
      final particlePaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.7)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      final numParticles = state == AuraState.speaking ? 8 : 5;
      for (int i = 0; i < numParticles; i++) {
        final angle = (2 * pi * i / numParticles) + (rotate * 2 * pi);
        final orbitRadius = dynamicRadius + 28;
        final px = center.dx + orbitRadius * cos(angle);
        final py = center.dy + orbitRadius * sin(angle);
        final r = 2.5 + (sin(wave * 2 * pi + i) * 1.5);
        canvas.drawCircle(Offset(px, py), r.abs(), particlePaint);
      }
    }

    // Draw wave ring (waveform effect when speaking/listening)
    if (state == AuraState.listening || state == AuraState.speaking) {
      final wavePaint = Paint()
        ..color = primaryColor.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

      final path = Path();
      const segments = 120;
      for (int i = 0; i <= segments; i++) {
        final angle = (2 * pi * i / segments);
        final waveAmp = (amplitude * 12) + 4;
        final r = dynamicRadius + waveAmp * sin(segments * 0.15 * angle + wave * 2 * pi);
        final px = center.dx + r * cos(angle);
        final py = center.dy + r * sin(angle);
        if (i == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();
      canvas.drawPath(path, wavePaint);
    }

    // Draw core circle
    final corePaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withValues(alpha: 0.9),
          primaryColor.withValues(alpha: 0.3),
          primaryColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: dynamicRadius));
    canvas.drawCircle(center, dynamicRadius, corePaint);
  }

  @override
  bool shouldRepaint(covariant _AuraPainter old) => true;
}
