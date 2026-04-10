import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/edge_theme.dart';
import '../../../core/di/state_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  String _status = 'Initializing Core...';

  @override
  void initState() {
    super.initState();
    _startAuth();
  }

  Future<void> _startAuth() async {
    try {
      final settings = ref.read(settingsProvider);
      if (!settings.biometricLock) {
        _proceed();
        return;
      }

      await Future.delayed(const Duration(milliseconds: 500));

      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        _proceed();
        return;
      }

      if (mounted) setState(() => _status = 'Authenticating...');
      
      final bool authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to access BRAINY.AI',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        setState(() {
          _isAuthenticated = true;
          _status = 'Authentication Successful';
        });
        _proceed();
      } else {
        setState(() => _status = 'Authentication Failed. Try again.');
      }
    } catch (e) {
      debugPrint('Biometric Error: $e');
      _proceed(); // Fallback to normal flow if error
    }
  }

  Future<void> _proceed() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    if (mounted) {
      if (!hasSeenOnboarding) {
        context.go('/onboarding');
      } else {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EdgeTheme.primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: EdgeTheme.surfaceColor,
                shape: BoxShape.circle,
                border: Border.all(color: EdgeTheme.lavender.withValues(alpha: 0.2)),
                boxShadow: EdgeTheme.purpleGlow(EdgeTheme.lavender),
              ),
              child: const FaIcon(
                FontAwesomeIcons.robot,
                size: 80,
                color: EdgeTheme.lavender,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'BRAINY.AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'SECURE • OFFLINE • PRIVATE',
              style: TextStyle(
                color: EdgeTheme.lavender.withValues(alpha: 0.6),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            if (!_isAuthenticated)
              const CircularProgressIndicator(color: EdgeTheme.lavender, strokeWidth: 2),
            const SizedBox(height: 24),
            Text(
              _status.toUpperCase(),
              style: TextStyle(
                color: EdgeTheme.textTertiary,
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),
            const FaIcon(
              FontAwesomeIcons.shieldHalved,
              size: 16,
              color: EdgeTheme.lavender,
            ),
          ],
        ),
      ),
    );
  }
}
