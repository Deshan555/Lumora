import 'dart:io';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../data/local/app_database.dart';
import '../../core/di/database_provider.dart';

/// Saved data repository provider
final savedDataRepositoryProvider = Provider<SavedDataRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return SavedDataRepository(database);
});

/// Repository for managing user-saved Creations and Artifacts
class SavedDataRepository {
  final AppDatabase _database;

  SavedDataRepository(this._database);

  /// Save an image to 'Creations'
  Future<int> saveCreation({
    required String sourcePath,
    required String title,
    String? prompt,
    String? description,
  }) async {
    // 1. Copy image to permanent storage
    final appDir = await getApplicationSupportDirectory();
    final creationsDir = Directory(p.join(appDir.path, 'creations'));
    if (!creationsDir.existsSync()) {
      creationsDir.createSync(recursive: true);
    }

    final filename = '${DateTime.now().millisecondsSinceEpoch}${p.extension(sourcePath)}';
    final destinationPath = p.join(creationsDir.path, filename);
    await File(sourcePath).copy(destinationPath);

    // 2. Save metadata to database
    final companion = SavedDataCompanion(
      type: const Value('CREATION'),
      title: Value(title),
      content: Value(destinationPath),
      prompt: Value(prompt),
      description: Value(description),
      timestamp: Value(DateTime.now()),
    );

    return await _database.saveDatum(companion);
  }

  /// Save a code snippet to 'Artifacts'
  Future<int> saveArtifact({
    required String code,
    required String title,
    required String language,
    String? description,
  }) async {
    final companion = SavedDataCompanion(
      type: const Value('ARTIFACT'),
      title: Value(title),
      content: Value(code),
      language: Value(language),
      description: Value(description),
      timestamp: Value(DateTime.now()),
    );

    return await _database.saveDatum(companion);
  }

  /// Get all saved data
  Future<List<SavedDatum>> getAllSavedData() async {
    return await _database.getAllSavedData();
  }

  /// Get saved data by type (CREATION/ARTIFACT)
  Future<List<SavedDatum>> getSavedDataByType(String type) async {
    return await _database.getSavedDataByType(type);
  }

  /// Delete saved datum
  Future<bool> deleteSavedDatum(int id) async {
    // If it's a creation, we might want to delete the file too
    final item = await ( _database.select(_database.savedData)..where((t) => t.id.equals(id)) ).getSingleOrNull();
    if (item != null && item.type == 'CREATION') {
      try {
        final file = File(item.content);
        if (file.existsSync()) file.deleteSync();
      } catch (_) {}
    }
    
    return await _database.deleteSavedDatum(id);
  }
}
