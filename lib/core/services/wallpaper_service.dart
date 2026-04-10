import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:flutter/services.dart';

/// Service to set device wallpaper using async_wallpaper
class WallpaperService {
  static Future<bool> setWallpaper(String path) async {
    try {
      final result = await AsyncWallpaper.setWallpaper(
        WallpaperRequest(
          target: WallpaperTarget.both,
          sourceType: WallpaperSourceType.file,
          source: path,
          goToHome: true,
        ),
      );
      return result.isSuccess;
    } on PlatformException catch (e) {
      print('Wallpaper Error: ${e.message}');
      return false;
    } catch (e) {
      print('Wallpaper Unknown Error: $e');
      return false;
    }
  }
}
