import 'package:flutter_tts/flutter_tts.dart';

/// Text-to-Speech service for Edge LLM
class TTSService {
  static final FlutterTts _flutterTts = FlutterTts();
  static bool _isInitialized = false;
  static bool _isSpeaking = false;

  /// Initialize TTS
  static Future<void> initialize() async {
    if (_isInitialized) return;

    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);

    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
    });

    _isInitialized = true;
  }

  /// Speak text
  static Future<void> speak(String text, {
    double? pitch,
    double? speed,
    String? language,
  }) async {
    await initialize();
    await stop();

    if (pitch != null) await _flutterTts.setPitch(pitch);
    if (speed != null) await _flutterTts.setSpeechRate(speed);
    if (language != null) await _flutterTts.setLanguage(language);

    await _flutterTts.speak(text);
  }

  /// Stop speaking
  static Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
  }

  /// Check if currently speaking
  static bool get isSpeaking => _isSpeaking;

  /// Get available languages
  static Future<List<dynamic>> getLanguages() async {
    await initialize();
    return await _flutterTts.getLanguages;
  }

  /// Dispose
  static Future<void> dispose() async {
    await stop();
    await _flutterTts.stop();
  }
}
