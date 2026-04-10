/// Device information utility for RAM detection and model recommendation
class DeviceUtils {
  DeviceUtils._();

  /// Get device RAM in GB
  /// Note: device_info_plus doesn't directly expose total RAM
  /// For production, consider using a platform channel or native code
  static Future<int> getDeviceRamGB() async {
    try {
      // Default to 4GB - conservative estimate
      // TODO: Implement proper RAM detection via platform channel
      return 4;
    } catch (e) {
      return 4;
    }
  }

  /// Recommend model based on available RAM
  /// Returns: 'tinyllama', 'phi3', or 'gemma'
  static String recommendModel(int ramGB) {
    if (ramGB <= 4) {
      return 'tinyllama';
    } else if (ramGB <= 6) {
      return 'phi3';
    } else {
      return 'gemma';
    }
  }

  /// Get recommended model ID based on device capabilities
  static Future<String> getRecommendedModelId() async {
    final ramGB = await getDeviceRamGB();
    return recommendModel(ramGB);
  }

  /// Check if device can run a specific model
  /// Returns true if device has enough RAM
  static bool canRunModel(String modelId, int ramGB) {
    switch (modelId) {
      case 'tinyllama':
        return ramGB >= 4;
      case 'phi3':
        return ramGB >= 6;
      case 'gemma':
        return ramGB >= 8;
      default:
        return ramGB >= 4;
    }
  }
}
