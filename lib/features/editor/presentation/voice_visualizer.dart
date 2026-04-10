import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui';
import '../../../core/theme/edge_theme.dart';

class VoiceVisualizerOverlay extends StatelessWidget {
  final VoidCallback onStop;

  const VoiceVisualizerOverlay({
    super.key,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: Colors.black.withValues(alpha: 0.6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'BRAINY IS SPEAKING',
                style: TextStyle(
                  color: EdgeTheme.lavender,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 60),
              
              // Wave Visualizer
              const Center(
                child: SpinKitWave(
                  color: EdgeTheme.lavender,
                  size: 80.0,
                  type: SpinKitWaveType.center,
                ),
              ),
              
              const SizedBox(height: 80),
              
              // Stop Button
              GestureDetector(
                onTap: onStop,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: EdgeTheme.errorRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: EdgeTheme.errorRed.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FaIcon(FontAwesomeIcons.circleStop, color: EdgeTheme.errorRed, size: 16),
                      const SizedBox(width: 12),
                      const Text(
                        'STOP SPEAKING',
                        style: TextStyle(
                          color: EdgeTheme.errorRed,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
