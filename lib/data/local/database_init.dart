import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../core/constants/storage_paths.dart';
import 'app_database.dart';

/// Database initialization singleton
class DatabaseInit {
  DatabaseInit._();

  static AppDatabase? _instance;

  /// Get database instance (singleton)
  static AppDatabase getInstance() {
    if (_instance != null) return _instance!;

    _instance = AppDatabase(_createDatabase());
    return _instance!;
  }

  /// Create database connection
  static LazyDatabase _createDatabase() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, StoragePaths.databaseName));
      return NativeDatabase.createInBackground(file);
    });
  }

  /// Close database connection
  static Future<void> close() async {
    await _instance?.close();
    _instance = null;
  }
}
