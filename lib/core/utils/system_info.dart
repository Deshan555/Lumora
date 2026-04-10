import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// RAM usage tracking and system info
class SystemInfoService {
  SystemInfoService._();

  /// Get total device RAM in MB
  static Future<int> getTotalRamMB() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      await deviceInfo.androidInfo;

      // Get RAM from /proc/meminfo
      final meminfo = await File('/proc/meminfo').readAsString();
      final match = RegExp(r'MemTotal:\s+(\d+)').firstMatch(meminfo);

      if (match != null) {
        // Value is in KB, convert to MB
        return int.parse(match.group(1)!) ~/ 1024;
      }

      // Fallback estimation
      return 4096; // 4GB default
    } catch (e) {
      return 4096;
    }
  }

  /// Get available RAM in MB
  static Future<int> getAvailableRamMB() async {
    try {
      final meminfo = await File('/proc/meminfo').readAsString();
      final match = RegExp(r'MemAvailable:\s+(\d+)').firstMatch(meminfo);

      if (match != null) {
        return int.parse(match.group(1)!) ~/ 1024;
      }

      return 2048; // 2GB default
    } catch (e) {
      return 2048;
    }
  }

  /// Get RAM usage percentage
  static Future<double> getRamUsagePercent() async {
    final total = await getTotalRamMB();
    final available = await getAvailableRamMB();
    final used = total - available;
    return (used / total) * 100;
  }

  /// Get formatted RAM info
  static Future<String> getRamInfo() async {
    final total = await getTotalRamMB();
    final available = await getAvailableRamMB();
    final used = total - available;

    return '${used ~/ 1024}GB / ${total ~/ 1024}GB (${((used / total) * 100).toStringAsFixed(1)}% used)';
  }

  /// Get compact RAM info for status bar (e.g., "2.1/4GB 52%")
  static Future<String> getCompactRamInfo() async {
    final total = await getTotalRamMB();
    final available = await getAvailableRamMB();
    final used = total - available;
    final percent = ((used / total) * 100).toStringAsFixed(0);
    final usedGB = (used / 1024).toStringAsFixed(1);
    final totalGB = (total / 1024).round();
    return '$usedGB/${totalGB}GB $percent%';
  }

  /// Check if device can run a model requiring specific RAM
  static Future<bool> canRunModel(int requiredRamGB) async {
    final totalRamGB = (await getTotalRamMB()) ~/ 1024;
    return totalRamGB >= requiredRamGB;
  }

  /// Get device info summary
  static Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final totalRam = await getTotalRamMB();
    final availableRam = await getAvailableRamMB();

    return {
      'device': androidInfo.model,
      'manufacturer': androidInfo.manufacturer,
      'androidVersion': androidInfo.version.release,
      'sdkVersion': androidInfo.version.sdkInt,
      'totalRam': totalRam,
      'availableRam': availableRam,
      'usedRam': totalRam - availableRam,
      'ramUsagePercent': ((totalRam - availableRam) / totalRam * 100).toStringAsFixed(1),
    };
  }

  /// Get CPU usage percentage (reads from /proc/stat)
  static Future<double> getCpuUsagePercent() async {
    try {
      // Read first CPU stat sample
      final stat1 = await File('/proc/stat').readAsString();
      final cpuLine1 = stat1.split('\n').firstWhere((line) => line.startsWith('cpu '));
      final cpuParts1 = cpuLine1.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
      
      // Skip first field ('cpu') and parse times
      final cpuTimes1 = cpuParts1.sublist(1).map(int.parse).toList();
      final total1 = cpuTimes1.fold<int>(0, (a, b) => a + b);
      final idle1 = cpuTimes1[3]; // idle is 4th field

      // Wait briefly for second sample
      await Future.delayed(const Duration(milliseconds: 500));

      // Read second CPU stat sample
      final stat2 = await File('/proc/stat').readAsString();
      final cpuLine2 = stat2.split('\n').firstWhere((line) => line.startsWith('cpu '));
      final cpuParts2 = cpuLine2.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
      
      final cpuTimes2 = cpuParts2.sublist(1).map(int.parse).toList();
      final total2 = cpuTimes2.fold<int>(0, (a, b) => a + b);
      final idle2 = cpuTimes2[3];

      // Calculate CPU usage percentage
      final totalDiff = total2 - total1;
      final idleDiff = idle2 - idle1;
      
      if (totalDiff == 0) return 0.0;
      
      return ((totalDiff - idleDiff) / totalDiff) * 100;
    } catch (e) {
      return 0.0;
    }
  }

  /// Get compact CPU info for status bar (e.g., "CPU 25%")
  static Future<String> getCompactCpuInfo() async {
    final cpuPercent = await getCpuUsagePercent();
    return '${cpuPercent.toStringAsFixed(0)}%';
  }

  /// Get combined system stats for status bar display
  static Future<Map<String, String>> getSystemStats() async {
    final ramInfo = await getCompactRamInfo();
    final cpuInfo = await getCompactCpuInfo();
    
    return {
      'ram': ramInfo,
      'cpu': cpuInfo,
    };
  }
}
