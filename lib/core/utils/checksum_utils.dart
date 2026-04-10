import 'dart:io';
import 'package:crypto/crypto.dart';

/// SHA-256 checksum verification utility
class ChecksumUtils {
  ChecksumUtils._();

  /// Calculate SHA-256 checksum of a file
  static Future<String> calculateChecksum(File file) async {
    final bytes = await file.readAsBytes();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify file integrity against expected checksum
  /// Returns true if checksum matches
  static Future<bool> verifyChecksum(File file, String expectedChecksum) async {
    if (expectedChecksum.isEmpty) {
      // Skip verification if no checksum provided
      return true;
    }
    
    final actualChecksum = await calculateChecksum(file);
    return actualChecksum.toLowerCase() == expectedChecksum.toLowerCase();
  }

  /// Get file size in human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}
