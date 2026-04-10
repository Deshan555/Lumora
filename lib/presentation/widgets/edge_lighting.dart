import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme/edge_theme.dart';

/// Premium Brainy.Ai Edge lighting effect
/// Creates a pulsing lavender glow around the screen or container
class EdgeLightingEffect extends StatefulWidget {
  final Widget child;
  final bool isActive;
  final double borderWidth;
  final double borderRadius;

  const EdgeLightingEffect({
    super.key,
    required this.child,
    required this.isActive,
    this.borderWidth = 2.0,
    this.borderRadius = 24.0,
  });

  @override
  State<EdgeLightingEffect> createState() => _EdgeLightingEffectState();
}

class _EdgeLightingEffectState extends State<EdgeLightingEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(EdgeLightingEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && _controller.isAnimating) {
      _controller.stop();
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
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: widget.isActive
                ? [
                    BoxShadow(
                      color: EdgeTheme.lavender.withValues(alpha: 0.15 * _pulseAnimation.value),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: EdgeTheme.lavender.withValues(alpha: 0.1 * _pulseAnimation.value),
                      blurRadius: 40,
                      spreadRadius: 4,
                    ),
                  ]
                : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: Stack(
              children: [
                child!,
                if (widget.isActive)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          border: Border.all(
                            color: EdgeTheme.lavender.withValues(alpha: 0.3 * _pulseAnimation.value),
                            width: widget.borderWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Simple glowing border effect for cards and inputs
class GlowingBorder extends StatelessWidget {
  final Widget child;
  final bool isActive;
  final Color? glowColor;
  final double borderRadius;

  const GlowingBorder({
    super.key,
    required this.child,
    required this.isActive,
    this.glowColor,
    this.borderRadius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = glowColor ?? EdgeTheme.lavender;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 16,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: child,
    );
  }
}
