import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/app_database.dart';
import '../../core/di/database_provider.dart';

/// History repository provider
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return HistoryRepository(database);
});

/// History repository implementation
class HistoryRepository {
  final AppDatabase _database;

  HistoryRepository(this._database);

  /// Get correction history
  Future<List<CorrectionHistoryData>> getHistory({int limit = 50}) async {
    return await _database.getHistory(limit: limit);
  }

  /// Save correction to history
  Future<int> saveHistory({
    required String originalText,
    required String correctedText,
    required List<String> explanation,
    required String style,
    String? modelName,
  }) async {
    // Use companion to let Drift auto-generate the ID
    final companion = CorrectionHistoryCompanion(
      originalText: Value(originalText),
      correctedText: Value(correctedText),
      explanation: Value(explanation.join('\n')),
      style: Value(style),
      modelName: Value(modelName),
      timestamp: Value(DateTime.now()),
    );
    return await _database.into(_database.correctionHistory).insert(companion);
  }

  /// Delete history entry
  Future<bool> deleteHistory(int id) async {
    return await _database.deleteHistoryEntry(id);
  }

  /// Clear all history
  Future<int> clearAllHistory() async {
    return await _database.clearAllHistory();
  }

  /// Get history count
  Future<int> getHistoryCount() async {
    return await _database.getHistoryCount();
  }
}
