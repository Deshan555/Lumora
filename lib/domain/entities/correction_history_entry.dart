/// Correction history entry entity
class CorrectionHistoryEntry {
  final int? id;
  final String originalText;
  final String correctedText;
  final List<String> explanation;
  final String style;
  final String? modelName;
  final DateTime timestamp;

  const CorrectionHistoryEntry({
    this.id,
    required this.originalText,
    required this.correctedText,
    required this.explanation,
    required this.style,
    this.modelName,
    required this.timestamp,
  });

  /// Convert to JSON string for storage
  String explanationToJson() {
    return explanation.map((e) => '- $e').join('\n');
  }

  /// Create from JSON string
  static List<String> explanationFromJson(String json) {
    return json
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .map((line) => line.replaceAll(RegExp(r'^-\s*'), '').trim())
        .toList();
  }
}
