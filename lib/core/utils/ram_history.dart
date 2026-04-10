import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'system_info.dart';

/// RAM usage history entry
class RamUsageEntry {
  final DateTime timestamp;
  final int totalRamMB;
  final int usedRamMB;
  final double usagePercent;
  final String? activeModel;

  const RamUsageEntry({
    required this.timestamp,
    required this.totalRamMB,
    required this.usedRamMB,
    required this.usagePercent,
    this.activeModel,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'totalRamMB': totalRamMB,
        'usedRamMB': usedRamMB,
        'usagePercent': usagePercent,
        'activeModel': activeModel,
      };

  factory RamUsageEntry.fromJson(Map<String, dynamic> json) => RamUsageEntry(
        timestamp: DateTime.parse(json['timestamp']),
        totalRamMB: json['totalRamMB'],
        usedRamMB: json['usedRamMB'],
        usagePercent: json['usagePercent'],
        activeModel: json['activeModel'],
      );
}

/// RAM usage history tracker
class RamHistoryTracker {
  static const _key = 'ram_history';
  static const _maxEntries = 100;

  /// Add current RAM usage to history
  static Future<void> recordUsage({String? activeModel}) async {
    final prefs = await SharedPreferences.getInstance();
    final history = await getHistory();

    final total = await SystemInfoService.getTotalRamMB();
    final available = await SystemInfoService.getAvailableRamMB();
    final used = total - available;

    final entry = RamUsageEntry(
      timestamp: DateTime.now(),
      totalRamMB: total,
      usedRamMB: used,
      usagePercent: (used / total) * 100,
      activeModel: activeModel,
    );

    history.insert(0, entry);

    // Keep only last N entries
    if (history.length > _maxEntries) {
      history.removeRange(_maxEntries, history.length);
    }

    final jsonList = history.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  /// Get RAM usage history
  static Future<List<RamUsageEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null) return [];

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList.map((e) => RamUsageEntry.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Clear history
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Get current RAM usage stats
  static Future<Map<String, dynamic>> getCurrentStats() async {
    final total = await SystemInfoService.getTotalRamMB();
    final available = await SystemInfoService.getAvailableRamMB();
    final used = total - available;

    return {
      'total': total,
      'available': available,
      'used': used,
      'percent': (used / total * 100).toStringAsFixed(1),
    };
  }
}
