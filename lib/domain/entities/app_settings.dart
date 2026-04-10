import '../../core/models/ai_personality.dart';

/// App settings entity with memory optimization flags
class AppSettings {
  final String selectedStyle;
  final String? activeModelId;
  final String themeMode; // 'light', 'dark', 'system'
  final bool autoDownloadRecommended;
  final AIPersonality personality;
  final bool lowRamMode;
  final bool terminateOnBackground;
  final bool aggressiveMemorySaving;
  final bool clearCacheOnExit;
  final bool biometricLock;
  final bool disableDeepReasoning;
  
  // Model Fine Tuning & Management
  final double modelTemperature;
  final double modelTopP;
  final int modelTopK;
  final int modelMaxTokens;
  final int contextSizeLimit;

  // AI Voice Settings
  final bool aiVoiceEnabled;
  final double aiVoicePitch;
  final double aiVoiceSpeed;

  const AppSettings({
    this.selectedStyle = 'Formal',
    this.activeModelId,
    this.themeMode = 'system',
    this.autoDownloadRecommended = false,
    this.personality = PredefinedPersonalities.friendlyAssistant,
    this.lowRamMode = false,
    this.terminateOnBackground = true,
    this.aggressiveMemorySaving = false,
    this.clearCacheOnExit = false,
    this.biometricLock = false,
    this.disableDeepReasoning = false,
    this.responseSummaryEnabled = true,
    this.voiceVisualizerEnabled = true,
    this.modelTemperature = 0.3,
    this.modelTopP = 0.9,
    this.modelTopK = 40,
    this.modelMaxTokens = 1024,
    this.contextSizeLimit = 2048,
    this.aiVoiceEnabled = true,
    this.aiVoicePitch = 1.0,
    this.aiVoiceSpeed = 0.5,
  });

  final bool responseSummaryEnabled;
  final bool voiceVisualizerEnabled;

  AppSettings copyWith({
    String? selectedStyle,
    String? activeModelId,
    String? themeMode,
    bool? autoDownloadRecommended,
    AIPersonality? personality,
    bool? lowRamMode,
    bool? terminateOnBackground,
    bool? aggressiveMemorySaving,
    bool? clearCacheOnExit,
    bool? biometricLock,
    bool? disableDeepReasoning,
    bool? responseSummaryEnabled,
    bool? voiceVisualizerEnabled,
    double? modelTemperature,
    double? modelTopP,
    int? modelTopK,
    int? modelMaxTokens,
    int? contextSizeLimit,
    bool? aiVoiceEnabled,
    double? aiVoicePitch,
    double? aiVoiceSpeed,
  }) {
    return AppSettings(
      selectedStyle: selectedStyle ?? this.selectedStyle,
      activeModelId: activeModelId ?? this.activeModelId,
      themeMode: themeMode ?? this.themeMode,
      autoDownloadRecommended: autoDownloadRecommended ?? this.autoDownloadRecommended,
      personality: personality ?? this.personality,
      lowRamMode: lowRamMode ?? this.lowRamMode,
      terminateOnBackground: terminateOnBackground ?? this.terminateOnBackground,
      aggressiveMemorySaving: aggressiveMemorySaving ?? this.aggressiveMemorySaving,
      clearCacheOnExit: clearCacheOnExit ?? this.clearCacheOnExit,
      biometricLock: biometricLock ?? this.biometricLock,
      disableDeepReasoning: disableDeepReasoning ?? this.disableDeepReasoning,
      responseSummaryEnabled: responseSummaryEnabled ?? this.responseSummaryEnabled,
      voiceVisualizerEnabled: voiceVisualizerEnabled ?? this.voiceVisualizerEnabled,
      modelTemperature: modelTemperature ?? this.modelTemperature,
      modelTopP: modelTopP ?? this.modelTopP,
      modelTopK: modelTopK ?? this.modelTopK,
      modelMaxTokens: modelMaxTokens ?? this.modelMaxTokens,
      contextSizeLimit: contextSizeLimit ?? this.contextSizeLimit,
      aiVoiceEnabled: aiVoiceEnabled ?? this.aiVoiceEnabled,
      aiVoicePitch: aiVoicePitch ?? this.aiVoicePitch,
      aiVoiceSpeed: aiVoiceSpeed ?? this.aiVoiceSpeed,
    );
  }
}
