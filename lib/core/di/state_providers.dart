import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/model_catalog.dart';
import '../../domain/entities/model_info.dart';
import '../models/ai_personality.dart';
import '../../domain/entities/app_settings.dart';
import '../services/system_monitor_service.dart';

// ========== Model State Providers ==========

/// Provider for list of all models
final modelsListProvider = StateNotifierProvider<ModelsListNotifier, List<ModelInfo>>((ref) {
  return ModelsListNotifier();
});

/// Provider for active model
final activeModelProvider = StateProvider<ModelInfo?>((ref) => null);

/// Models list state notifier
class ModelsListNotifier extends StateNotifier<List<ModelInfo>> {
  ModelsListNotifier() : super([]);

  void updateModels(List<ModelInfo> models) => state = models;
  void updateModel(ModelInfo m) {
    state = [for (final model in state) if (model.id == m.id) m else model];
  }
}

// ========== Settings State Providers ==========
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

/// Settings state notifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings());

  void updateStyle(String style) {
    state = state.copyWith(selectedStyle: style);
  }

  void updateActiveModel(String? modelId) {
    state = state.copyWith(activeModelId: modelId);
  }

  void updateThemeMode(String themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }

  void updatePersonality(AIPersonality personality) {
    state = state.copyWith(personality: personality);
  }

  void updateLowRamMode(bool value) {
    state = state.copyWith(lowRamMode: value);
  }

  void updateTerminateOnBackground(bool value) {
    state = state.copyWith(terminateOnBackground: value);
  }

  void updateAggressiveMemorySaving(bool value) {
    state = state.copyWith(aggressiveMemorySaving: value);
  }

  void updateClearCacheOnExit(bool value) {
    state = state.copyWith(clearCacheOnExit: value);
  }

  void updateBiometricLock(bool value) {
    state = state.copyWith(biometricLock: value);
  }

  void updateDisableDeepReasoning(bool value) {
    state = state.copyWith(disableDeepReasoning: value);
  }

  void updateResponseSummaryEnabled(bool value) {
    state = state.copyWith(responseSummaryEnabled: value);
  }

  void updateVoiceVisualizerEnabled(bool value) {
    state = state.copyWith(voiceVisualizerEnabled: value);
  }

  void updateModelTemperature(double value) {
    state = state.copyWith(modelTemperature: value);
  }

  void updateModelTopP(double value) {
    state = state.copyWith(modelTopP: value);
  }

  void updateModelTopK(int value) {
    state = state.copyWith(modelTopK: value);
  }

  void updateModelMaxTokens(int value) {
    state = state.copyWith(modelMaxTokens: value);
  }

  void updateContextSizeLimit(int value) {
    state = state.copyWith(contextSizeLimit: value);
  }

  void updateAiVoiceEnabled(bool value) {
    state = state.copyWith(aiVoiceEnabled: value);
  }

  void updateAiVoicePitch(double value) {
    state = state.copyWith(aiVoicePitch: value);
  }

  void updateAiVoiceSpeed(double value) {
    state = state.copyWith(aiVoiceSpeed: value);
  }

  void loadSettings(AppSettings settings) {
    state = settings;
  }
}

// ========== Download State Providers ==========

enum DownloadStatus { idle, downloading, paused, completed, failed }

class DownloadState {
  final double progress;
  final DownloadStatus status;
  final String? error;
  const DownloadState({this.progress = 0.0, this.status = DownloadStatus.idle, this.error});
  DownloadState copyWith({double? progress, DownloadStatus? status, String? error}) {
    return DownloadState(progress: progress ?? this.progress, status: status ?? this.status, error: error ?? this.error);
  }
}

final downloadStatesProvider = StateNotifierProvider<DownloadStatesNotifier, Map<String, DownloadState>>((ref) {
  return DownloadStatesNotifier();
});

class DownloadStatesNotifier extends StateNotifier<Map<String, DownloadState>> {
  DownloadStatesNotifier() : super({});
  void updateProgress(String id, double p) {
    state = {...state, id: (state[id] ?? const DownloadState()).copyWith(progress: p, status: DownloadStatus.downloading)};
  }
  void setPaused(String id) {
    state = {...state, id: (state[id] ?? const DownloadState()).copyWith(status: DownloadStatus.paused)};
  }
  void setCompleted(String id) {
    state = {...state, id: const DownloadState(progress: 1.0, status: DownloadStatus.completed)};
  }
  void setFailed(String id, String error) {
    state = {...state, id: DownloadState(status: DownloadStatus.failed, error: error)};
  }
}

// ========== App Flow State Providers ==========

/// Provider for tracking if this is the first launch
final onboardingProvider = StateProvider<bool>((ref) => false);

/// Provider for system monitor state (RAM/CPU usage)
final systemMonitorProvider = StateProvider<SystemMonitorState>((ref) => const SystemMonitorState());

/// Provider for triggering chat actions from the drawer
final chatActionsProvider = StateNotifierProvider<ChatActionsNotifier, ChatAction?>(
  (ref) => ChatActionsNotifier(),
);

enum ChatAction { reset, clear }

class ChatActionsNotifier extends StateNotifier<ChatAction?> {
  ChatActionsNotifier() : super(null);

  void requestReset() => state = ChatAction.reset;
  void requestClear() => state = ChatAction.clear;
  void clearAction() => state = null;
}
