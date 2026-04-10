import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/edge_theme.dart';

class ParticleBackground extends StatefulWidget {
  final bool isThinking;
  const ParticleBackground({super.key, this.isThinking = false});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final int _particleCount = 40;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < _particleCount; i++) {
      _particles.add(Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 3 + 1,
        speed: _random.nextDouble() * 0.02 + 0.01,
        opacity: _random.nextDouble() * 0.5 + 0.2,
        angle: _random.nextDouble() * math.pi * 2,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            isThinking: widget.isThinking,
            accentColor: EdgeTheme.lavender,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double angle;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
  });

  void update(double progress, bool isThinking) {
    final currentSpeed = isThinking ? speed * 3 : speed;
    x += math.cos(angle) * currentSpeed * 0.01;
    y += math.sin(angle) * currentSpeed * 0.01;

    if (x < -0.1) x = 1.1;
    if (x > 1.1) x = -0.1;
    if (y < -0.1) y = 1.1;
    if (y > 1.1) y = -0.1;
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final bool isThinking;
  final Color accentColor;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.isThinking,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    // Draw central glow orb
    final center = Offset(size.width / 2, size.height / 2);
    final orbRadius = size.width * 0.3;
    final orbPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          accentColor.withValues(alpha: isThinking ? 0.15 : 0.08),
          accentColor.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: orbRadius));
    
    canvas.drawCircle(center, orbRadius, orbPaint);

    // Draw particles
    for (var particle in particles) {
      particle.update(progress, isThinking);
      
      final position = Offset(particle.x * size.width, particle.y * size.height);
      paint.color = accentColor.withValues(alpha: particle.opacity);
      
      canvas.drawCircle(position, particle.size, paint);
      
      // Add a subtle glow to each particle
      final glowPaint = Paint()
        ..color = accentColor.withValues(alpha: particle.opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(position, particle.size * 2, glowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter oldDelegate) => true;
}
