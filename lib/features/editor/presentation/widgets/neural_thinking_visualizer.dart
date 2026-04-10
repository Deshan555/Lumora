import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class NeuralThinkingVisualizer extends StatefulWidget {
  final double width;
  final double height;
  final bool isFinished;

  const NeuralThinkingVisualizer({
    super.key,
    this.width = 150,
    this.height = 60,
    this.isFinished = false,
  });

  @override
  State<NeuralThinkingVisualizer> createState() => _NeuralThinkingVisualizerState();
}

class _NeuralThinkingVisualizerState extends State<NeuralThinkingVisualizer> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _nodeController;
  late AnimationController _flowController;
  late AnimationController _convergeController;

  final List<_Node> _nodes = [];
  final Random _rnd = Random();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat();
    _nodeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 4000))..repeat(reverse: true);
    _flowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();
    _convergeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _generateNodes();

    if (widget.isFinished) {
      _convergeController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant NeuralThinkingVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFinished && !oldWidget.isFinished) {
      _convergeController.forward();
    } else if (!widget.isFinished && oldWidget.isFinished) {
      _convergeController.reverse();
    }
  }

  void _generateNodes() {
    final colors = [
      const Color(0xFF22D3EE),
      const Color(0xFF8B5CF6),
      const Color(0xFFF472B6),
    ];
    for (int i = 0; i < 20; i++) {
      _nodes.add(_Node(
        offset: Offset(_rnd.nextDouble() * widget.width, _rnd.nextDouble() * widget.height),
        baseX: _rnd.nextDouble() * widget.width,
        baseY: _rnd.nextDouble() * widget.height,
        color: colors[_rnd.nextInt(colors.length)],
        radius: _rnd.nextDouble() * 2 + 1.5,
        speed: _rnd.nextDouble() * 0.5 + 0.3,
      ));
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _nodeController.dispose();
    _flowController.dispose();
    _convergeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: const Color(0xFF0B1120),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ],
        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseController, _nodeController, _flowController, _convergeController]),
          builder: (context, child) {
            return CustomPaint(
              painter: _NeuralPainter(
                nodes: _nodes,
                pulseValue: _pulseController.value,
                nodeValue: _nodeController.value,
                flowValue: _flowController.value,
                convergeValue: CurvedAnimation(parent: _convergeController, curve: Curves.easeInOut).value,
                width: widget.width,
                height: widget.height,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Node {
  Offset offset;
  double baseX;
  double baseY;
  Color color;
  double radius;
  double speed;
  _Node({required this.offset, required this.baseX, required this.baseY, required this.color, required this.radius, required this.speed});
}

class _NeuralPainter extends CustomPainter {
  final List<_Node> nodes;
  final double pulseValue;
  final double nodeValue;
  final double flowValue;
  final double convergeValue;
  final double width;
  final double height;

  _NeuralPainter({
    required this.nodes,
    required this.pulseValue,
    required this.nodeValue,
    required this.flowValue,
    required this.convergeValue,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Apply bloom / subtle blur
    final paint = Paint()
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0)
      ..style = PaintingStyle.fill;

    if (convergeValue > 0) {
      // Transitioning to Green Converged State
      for (var node in nodes) {
        final targetOffset = Offset.lerp(node.offset, center, convergeValue)!;
        paint.color = Color.lerp(node.color, const Color(0xFF34D399), convergeValue)!;
        canvas.drawCircle(targetOffset, node.radius * 2, paint);
      }
      
      // Central bright glow
      final centerGlow = Paint()
        ..color = const Color(0xFF34D399).withValues(alpha: convergeValue * 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15.0);
      canvas.drawCircle(center, 20 * convergeValue, centerGlow);
      
      final centerCore = Paint()..color = Colors.white.withValues(alpha: convergeValue);
      canvas.drawCircle(center, 8 * convergeValue, centerCore);
      
      // Icon or Output Element
      if (convergeValue > 0.8) {
        final textSpan = const TextSpan(
          text: 'READY',
          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final textOffset = Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2);
        
        final bgRect = Rect.fromCenter(center: center, width: textPainter.width + 16, height: textPainter.height + 8);
        canvas.drawRRect(RRect.fromRectAndRadius(bgRect, const Radius.circular(8)), Paint()..color = const Color(0xFF34D399));
        textPainter.paint(canvas, textOffset);
      }
      
      if (convergeValue == 1.0) return;
    }

    // Update node positions organically
    for (int i = 0; i < nodes.length; i++) {
      final n = nodes[i];
      final dx = sin(nodeValue * pi * 2 * n.speed + i) * 12;
      final dy = cos(nodeValue * pi * 2 * n.speed + i) * 12;
      n.offset = Offset.lerp(Offset(n.baseX + dx, n.baseY + dy), center, convergeValue)!;
    }

    // Draw lines (connections)
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final d = (nodes[i].offset - nodes[j].offset).distance;
        if (d < 45) {
          final opacity = (1.0 - (d / 45)).clamp(0.0, 1.0) * (1.0 - convergeValue);
          if (opacity <= 0) continue;
          
          final gradient = ui.Gradient.linear(
            nodes[i].offset,
            nodes[j].offset,
            [
              nodes[i].color.withValues(alpha: opacity * 0.6),
              nodes[j].color.withValues(alpha: opacity * 0.6),
            ],
          );
          linePaint.shader = gradient;
          
          // Data flow effect
          final p1 = nodes[i].offset;
          final p2 = nodes[j].offset;
          final path = Path()..moveTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy);
          canvas.drawPath(path, linePaint);
          
          // Little spark flowing through connection
          if (opacity > 0.4) {
             final flowPoint = Offset.lerp(p1, p2, (flowValue + (i/nodes.length)) % 1.0)!;
             canvas.drawCircle(flowPoint, 1.5, Paint()..color = Colors.white.withValues(alpha: opacity));
          }
        }
      }
    }

    // Draw Input Pulse (Electric Blue) from left
    if (convergeValue < 1.0) {
      final pulseX = (pulseValue * size.width * 1.5) - (size.width * 0.5);
      final pulsePaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(pulseX - 50, size.height/2),
          Offset(pulseX + 20, size.height/2),
          [
             const Color(0xFF3B82F6).withValues(alpha: 0.0),
             const Color(0xFF3B82F6).withValues(alpha: 0.5 * (1 - convergeValue)),
          ]
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawRect(Rect.fromLTWH(pulseX - 50, 0, 70, size.height), pulsePaint);
    }

    // Draw nodes
    for (var node in nodes) {
      paint.color = Color.lerp(node.color, const Color(0xFF34D399), convergeValue)!;
      canvas.drawCircle(node.offset, node.radius, paint);
      // core
      canvas.drawCircle(node.offset, node.radius * 0.5, Paint()..color = Colors.white.withValues(alpha: 1.0 - convergeValue));
    }
  }

  @override
  bool shouldRepaint(covariant _NeuralPainter oldDelegate) => true;
}
