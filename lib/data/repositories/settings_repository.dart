import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/ai_personality.dart';
import '../local/app_database.dart';
import '../../domain/entities/app_settings.dart';
import '../../core/di/database_provider.dart';

/// Settings repository provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(ref.read(databaseProvider));
});

/// Settings repository for persisting user preferences
class SettingsRepository {
  static const _keyStyle = 'selected_style';
  static const _keyActiveModel = 'active_model_id';
  static const _keyTheme = 'theme_mode';
  static const _keyAutoDownload = 'auto_download_recommended';
  static const _keyPersonality = 'active_personality_json';
  static const _keyLowRam = 'low_ram_mode';
  static const _keyTerminateBg = 'terminate_on_bg';
  static const _keyAggressiveMem = 'aggressive_mem_saving';
  static const _keyClearCache = 'clear_cache_exit';
  static const _keyBiometricLock = 'biometric_lock_enabled';
  static const _keyDisableReasoning = 'disable_deep_reasoning';
  
  static const _keyModelTemp = 'model_temperature';
  static const _keyModelTopP = 'model_top_p';
  static const _keyModelTopK = 'model_top_k';
  static const _keyModelMaxTokens = 'model_max_tokens';
  static const _keyContextSize = 'context_size_limit';

  static const _keyAiVoiceEnabled = 'ai_voice_enabled';
  static const _keyAiVoicePitch = 'ai_voice_pitch';
  static const _keyAiVoiceSpeed = 'ai_voice_speed';

  final AppDatabase _db;
  SharedPreferences? _prefs;

  SettingsRepository(this._db);

  /// Get or initialize SharedPreferences
  Future<SharedPreferences> _getPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// Get current settings
  Future<AppSettings> getSettings() async {
    final prefs = await _getPrefs();
    
    final personalityJson = prefs.getString(_keyPersonality);
    final personality = personalityJson != null 
        ? AIPersonality.fromJson(jsonDecode(personalityJson))
        : PredefinedPersonalities.friendlyAssistant;

    return AppSettings(
      selectedStyle: prefs.getString(_keyStyle) ?? 'Formal',
      activeModelId: prefs.getString(_keyActiveModel),
      themeMode: prefs.getString(_keyTheme) ?? 'system',
      autoDownloadRecommended: prefs.getBool(_keyAutoDownload) ?? false,
      personality: personality,
      lowRamMode: prefs.getBool(_keyLowRam) ?? false,
      terminateOnBackground: prefs.getBool(_keyTerminateBg) ?? true,
      aggressiveMemorySaving: prefs.getBool(_keyAggressiveMem) ?? false,
      clearCacheOnExit: prefs.getBool(_keyClearCache) ?? false,
      biometricLock: prefs.getBool(_keyBiometricLock) ?? false,
      disableDeepReasoning: prefs.getBool(_keyDisableReasoning) ?? false,
      modelTemperature: prefs.getDouble(_keyModelTemp) ?? 0.3,
      modelTopP: prefs.getDouble(_keyModelTopP) ?? 0.9,
      modelTopK: prefs.getInt(_keyModelTopK) ?? 40,
      modelMaxTokens: prefs.getInt(_keyModelMaxTokens) ?? 1024,
      contextSizeLimit: prefs.getInt(_keyContextSize) ?? 2048,
      aiVoiceEnabled: prefs.getBool(_keyAiVoiceEnabled) ?? true,
      aiVoicePitch: prefs.getDouble(_keyAiVoicePitch) ?? 1.0,
      aiVoiceSpeed: prefs.getDouble(_keyAiVoiceSpeed) ?? 0.5,
    );
  }

  /// Save all settings
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await _getPrefs();
    
    await prefs.setString(_keyStyle, settings.selectedStyle);
    if (settings.activeModelId != null) {
      await prefs.setString(_keyActiveModel, settings.activeModelId!);
    }
    await prefs.setString(_keyTheme, settings.themeMode);
    await prefs.setBool(_keyAutoDownload, settings.autoDownloadRecommended);
    await prefs.setString(_keyPersonality, jsonEncode(settings.personality.toJson()));
    await prefs.setBool(_keyLowRam, settings.lowRamMode);
    await prefs.setBool(_keyTerminateBg, settings.terminateOnBackground);
    await prefs.setBool(_keyAggressiveMem, settings.aggressiveMemorySaving);
    await prefs.setBool(_keyClearCache, settings.clearCacheOnExit);
    await prefs.setBool(_keyBiometricLock, settings.biometricLock);
    await prefs.setBool(_keyDisableReasoning, settings.disableDeepReasoning);
    await prefs.setDouble(_keyModelTemp, settings.modelTemperature);
    await prefs.setDouble(_keyModelTopP, settings.modelTopP);
    await prefs.setInt(_keyModelTopK, settings.modelTopK);
    await prefs.setInt(_keyModelMaxTokens, settings.modelMaxTokens);
    await prefs.setInt(_keyContextSize, settings.contextSizeLimit);
    await prefs.setBool(_keyAiVoiceEnabled, settings.aiVoiceEnabled);
    await prefs.setDouble(_keyAiVoicePitch, settings.aiVoicePitch);
    await prefs.setDouble(_keyAiVoiceSpeed, settings.aiVoiceSpeed);
  }

  /// Update active personality
  Future<void> updatePersonality(AIPersonality personality) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyPersonality, jsonEncode(personality.toJson()));
  }

  // ========== Custom Personalities (Database) ==========

  Future<List<AIPersonality>> getCustomPersonalities() async {
    final results = await _db.getAllCustomPersonalities();
    return results.map((row) => AIPersonality(
      id: row.id,
      name: row.name,
      gender: AIGender.values[row.gender],
      occupation: AIOccupation.values[row.occupation],
      customOccupation: row.customOccupation,
      customName: row.customName,
      traits: _parseTraits(row.traits),
      customPromptAddition: row.customPromptAddition,
      voiceLanguage: row.voiceLanguage,
      voicePitch: row.voicePitch,
      voiceSpeed: row.voiceSpeed,
      avatarIcon: AIOccupation.values[row.occupation].icon,
    )).toList();
  }

  Future<void> saveCustomPersonality(AIPersonality p) async {
    await _db.saveCustomPersonality(CustomPersonality(
      id: p.id,
      name: p.name,
      gender: p.gender.index,
      occupation: p.occupation.index,
      customOccupation: p.customOccupation,
      customName: p.customName,
      traits: jsonEncode(p.traits.map((k, v) => MapEntry(k, v.index))),
      customPromptAddition: p.customPromptAddition,
      voiceLanguage: p.voiceLanguage,
      voicePitch: p.voicePitch,
      voiceSpeed: p.voiceSpeed,
      avatarIconCode: p.avatarIcon.codePoint,
      avatarIconFontFamily: p.avatarIcon.fontFamily,
      avatarIconFontPackage: p.avatarIcon.fontPackage,
    ));
  }

  Future<void> deleteCustomPersonality(String id) async {
    await _db.deleteCustomPersonality(id);
  }

  Map<String, TraitIntensity> _parseTraits(String json) {
    try {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, TraitIntensity.values[v as int]));
    } catch (_) {
      return {};
    }
  }

  /// Update selected writing style
  Future<void> updateSelectedStyle(String style) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyStyle, style);
  }

  /// Update active model
  Future<void> updateActiveModel(String modelId) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyActiveModel, modelId);
  }

  /// Update theme mode
  Future<void> updateThemeMode(String themeMode) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyTheme, themeMode);
  }

  /// Update auto-download setting
  Future<void> updateAutoDownload(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyAutoDownload, value);
  }

  Future<void> updateLowRamMode(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyLowRam, value);
  }

  Future<void> updateTerminateOnBackground(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyTerminateBg, value);
  }

  Future<void> updateAggressiveMemorySaving(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyAggressiveMem, value);
  }

  Future<void> updateClearCacheOnExit(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyClearCache, value);
  }

  Future<void> updateBiometricLock(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyBiometricLock, value);
  }

  Future<void> updateDisableDeepReasoning(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyDisableReasoning, value);
  }

  Future<void> updateAiVoiceEnabled(bool value) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyAiVoiceEnabled, value);
  }

  Future<void> updateAiVoicePitch(double value) async {
    final prefs = await _getPrefs();
    await prefs.setDouble(_keyAiVoicePitch, value);
  }

  Future<void> updateAiVoiceSpeed(double value) async {
    final prefs = await _getPrefs();
    await prefs.setDouble(_keyAiVoiceSpeed, value);
  }

  /// Clear all settings
  /// Clear all settings
  Future<void> clearSettings() async {
    final prefs = await _getPrefs();
    await prefs.clear();
  }
}
