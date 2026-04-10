import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static const int _systemMonitorNotificationId = 1;

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  static Future<void> showResponseNotification({
    required String summary,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'ai_response_channel',
      'AI Responses',
      channelDescription: 'Notifications when AI finishes responding',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id: 0,
      title: 'Brainy.Ai Responded',
      body: summary,
      notificationDetails: platformChannelSpecifics,
    );
  }

  /// Show persistent notification with RAM/CPU usage in the status bar
  static Future<void> showSystemMonitorNotification({
    required String ramInfo,
    required String cpuInfo,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'system_monitor_channel',
      'System Monitor',
      channelDescription: 'Shows real-time RAM and CPU usage',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      onlyAlertOnce: true,
      showWhen: false,
      category: AndroidNotificationCategory.service,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id: _systemMonitorNotificationId,
      title: 'Brainy.Ai - System Monitor',
      body: 'RAM: $ramInfo | CPU: $cpuInfo',
      notificationDetails: platformChannelSpecifics,
    );
  }

  /// Update the persistent notification with new RAM/CPU data
  static Future<void> updateSystemMonitorNotification({
    required String ramInfo,
    required String cpuInfo,
  }) async {
    // Just call show with same ID to update
    await showSystemMonitorNotification(ramInfo: ramInfo, cpuInfo: cpuInfo);
  }

  /// Remove the persistent system monitor notification
  static Future<void> hideSystemMonitorNotification() async {
    try {
      // Cancel notification using the platform-specific Android implementation
      final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImpl?.cancel(id: _systemMonitorNotificationId);
    } catch (e) {
      debugPrint('Error hiding system monitor notification: $e');
    }
  }

  /// Remove all notifications (helper method)
  static Future<void> hideAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
