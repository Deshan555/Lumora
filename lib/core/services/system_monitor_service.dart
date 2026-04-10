import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/system_info.dart';
import '../services/notification_service.dart';

/// System monitor state for Riverpod
class SystemMonitorState {
  final String ramInfo;
  final String cpuInfo;
  final bool isMonitoring;

  const SystemMonitorState({
    this.ramInfo = 'N/A',
    this.cpuInfo = 'N/A',
    this.isMonitoring = false,
  });

  SystemMonitorState copyWith({
    String? ramInfo,
    String? cpuInfo,
    bool? isMonitoring,
  }) {
    return SystemMonitorState(
      ramInfo: ramInfo ?? this.ramInfo,
      cpuInfo: cpuInfo ?? this.cpuInfo,
      isMonitoring: isMonitoring ?? this.isMonitoring,
    );
  }
}

/// System monitor service that shows RAM/CPU usage in the notification bar
class SystemMonitorService {
  Timer? _monitorTimer;
  bool _isRunning = false;
  static const updateInterval = Duration(seconds: 10);

  bool get isRunning => _isRunning;

  /// Start periodic system monitoring
  void start({void Function(SystemMonitorState)? onUpdate}) {
    if (_isRunning) return;
    _isRunning = true;

    // Show initial notification immediately
    _updateNotification(onUpdate);

    // Update periodically
    _monitorTimer = Timer.periodic(updateInterval, (timer) {
      _updateNotification(onUpdate);
    });

    debugPrint('SystemMonitorService: Started');
  }

  /// Stop system monitoring
  void stop() {
    _isRunning = false;
    _monitorTimer?.cancel();
    _monitorTimer = null;
    NotificationService.hideSystemMonitorNotification();
    debugPrint('SystemMonitorService: Stopped');
  }

  /// Update the notification with current system stats
  Future<void> _updateNotification([void Function(SystemMonitorState)? onUpdate]) async {
    try {
      final stats = await SystemInfoService.getSystemStats();
      final ramInfo = stats['ram'] ?? 'N/A';
      final cpuInfo = stats['cpu'] ?? 'N/A';

      // Update callback if provided
      if (onUpdate != null) {
        onUpdate(SystemMonitorState(
          ramInfo: ramInfo,
          cpuInfo: cpuInfo,
          isMonitoring: true,
        ));
      }

      await NotificationService.updateSystemMonitorNotification(
        ramInfo: ramInfo,
        cpuInfo: cpuInfo,
      );
    } catch (e) {
      debugPrint('SystemMonitorService: Error updating notification: $e');
    }
  }

  /// Get current system stats without updating notification
  static Future<Map<String, String>> getCurrentStats() async {
    return await SystemInfoService.getSystemStats();
  }

  /// Dispose and clean up
  void dispose() {
    stop();
  }
}
