import 'package:flutter/foundation.dart' show VoidCallback;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

/// Voice input service for Edge LLM
class VoiceInputService {
  static final stt.SpeechToText _speech = stt.SpeechToText();
  static bool _isInitialized = false;
  static bool _isListening = false;
  static String _lastWords = '';
  static Function(String)? _onResult;

  // Silence detection for Live Mode
  static Timer? _silenceTimer;
  static VoidCallback? _onSilence;
  static const Duration _silenceThreshold = Duration(milliseconds: 2500);

  /// Initialize speech recognition
  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    _isInitialized = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _isListening = false;
          if (_onSilence != null && _lastWords.isNotEmpty) {
            _onSilence?.call();
            _lastWords = '';
          }
        }
      },
      onError: (error) {
        _isListening = false;
        _silenceTimer?.cancel();
      },
    );

    return _isInitialized;
  }

  /// Check if speech recognition is available
  static Future<bool> get isAvailable async {
    if (!_isInitialized) {
      await initialize();
    }
    return _isInitialized;
  }

  /// Standard one-shot listening (tap to talk)
  static Future<void> startListening({Function(String)? onResult}) async {
    if (!await isAvailable) return;

    _onResult = onResult;
    _isListening = true;
    _lastWords = '';

    await _speech.listen(
      onResult: (result) {
        _lastWords = result.recognizedWords;
        _onResult?.call(_lastWords);
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      listenOptions: stt.SpeechListenOptions(partialResults: true),
    );
  }

  /// Live continuous listening with automatic silence detection.
  /// [onPartialResult] is called continuously as the user speaks.
  /// [onSilence] is triggered after [_silenceThreshold] of silence
  /// following detected speech — use this to auto-send the message.
  static Future<void> startLiveListening({
    required Function(String) onPartialResult,
    required VoidCallback onSilence,
  }) async {
    if (!await isAvailable) return;

    _onSilence = onSilence;
    _isListening = true;
    _lastWords = '';
    _silenceTimer?.cancel();

    await _speech.listen(
      onResult: (result) {
        final words = result.recognizedWords;
        _lastWords = words;
        onPartialResult(words);

        // Reset silence timer on every incoming word
        _silenceTimer?.cancel();
        if (words.isNotEmpty) {
          _silenceTimer = Timer(_silenceThreshold, () {
            if (_isListening && _lastWords.isNotEmpty) {
              _onSilence?.call();
            }
          });
        }
      },
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 10),
      localeId: 'en_US', // enforce better default locale if system is weird
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  /// Stop listening
  static Future<void> stopListening() async {
    _silenceTimer?.cancel();
    _onSilence = null; // Prevent double trigger
    _lastWords = '';
    await _speech.stop();
    _isListening = false;
  }

  /// Cancel silence timer (e.g., user is speaking again)
  static void cancelSilenceTimer() {
    _silenceTimer?.cancel();
  }

  /// Check if currently listening
  static bool get isListening => _isListening;

  /// Get last recognized words
  static String get lastWords => _lastWords;

  /// Cancel listening entirely
  static Future<void> cancel() async {
    _silenceTimer?.cancel();
    await _speech.cancel();
    _isListening = false;
  }
}
