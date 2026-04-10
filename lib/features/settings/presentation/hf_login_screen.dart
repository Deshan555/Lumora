import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/edge_theme.dart';
import '../../../core/di/repository_providers.dart';

class HFLoginScreen extends ConsumerStatefulWidget {
  const HFLoginScreen({super.key});

  @override
  ConsumerState<HFLoginScreen> createState() => _HFLoginScreenState();
}

class _HFLoginScreenState extends ConsumerState<HFLoginScreen> {
  final TextEditingController _manualTokenController = TextEditingController();

  @override
  void dispose() {
    _manualTokenController.dispose();
    super.dispose();
  }

  Future<void> _handleManualSync() async {
    final text = _manualTokenController.text.trim();
    final hfService = ref.read(hfServiceProvider);
    
    if (hfService.isValidToken(text)) {
      await hfService.saveToken(text);
      _onSuccess();
    } else {
      _onError();
    }
  }

  void _onSuccess() {
    if (mounted) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cloud Core Synced Successfully!'),
          backgroundColor: EdgeTheme.successGreen,
        ),
      );
      ref.invalidate(hfProfileProvider);
      Navigator.pop(context, true);
    }
  }

  void _onError() {
    if (mounted) {
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Token Format. Please provide a valid Access Token (starts with hf_).'),
          backgroundColor: EdgeTheme.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EdgeTheme.primaryBackground,
      appBar: AppBar(
        title: const Text('CONNECT HUGGING FACE'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              const FaIcon(FontAwesomeIcons.key, color: EdgeTheme.lavender, size: 64),
              const SizedBox(height: 32),
              const Text(
                'Access Token',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Paste your Hugging Face Access Token below to connect your account and use cloud capabilities. You can generate a token at huggingface.co/settings/tokens.',
                textAlign: TextAlign.center,
                style: TextStyle(color: EdgeTheme.textTertiary, fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _manualTokenController,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'hf_••••••••••••••••',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                  filled: true,
                  fillColor: EdgeTheme.surfaceColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  suffixIcon: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.paste, size: 16, color: EdgeTheme.lavender),
                    onPressed: () async {
                      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                      final text = clipboardData?.text ?? '';
                      if (text.isNotEmpty) {
                        _manualTokenController.text = text;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleManualSync,
                style: ElevatedButton.styleFrom(
                  backgroundColor: EdgeTheme.lavender,
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('SYNC TOKEN', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
