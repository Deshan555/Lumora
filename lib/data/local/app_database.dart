import 'package:drift/drift.dart';
import '../../domain/entities/correction_history_entry.dart';

part 'app_database.g.dart';

// Database tables
class CorrectionHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get originalText => text().withLength(max: 10000)();
  TextColumn get correctedText => text().withLength(max: 10000)();
  TextColumn get explanation => text()(); // JSON array of explanation lines
  TextColumn get style => text().withDefault(const Constant('Formal'))();
  TextColumn get modelName => text().nullable()();
  BoolColumn get isImage => boolean().withDefault(const Constant(false))();
  TextColumn get imageUrl => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

class UserSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get selectedStyle => text().withDefault(const Constant('Formal'))();
  TextColumn get activeModelId => text().nullable()();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  BoolColumn get autoDownloadRecommended => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();
}

class CustomPersonalities extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get gender => integer()();
  IntColumn get occupation => integer()();
  TextColumn get customOccupation => text()();
  TextColumn get customName => text()();
  TextColumn get traits => text()(); // JSON string
  TextColumn get customPromptAddition => text()();
  TextColumn get voiceLanguage => text().nullable()();
  RealColumn get voicePitch => real()();
  RealColumn get voiceSpeed => real()();
  IntColumn get avatarIconCode => integer()();
  TextColumn get avatarIconFontFamily => text().nullable()();
  TextColumn get avatarIconFontPackage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SavedDatum')
class SavedData extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()(); // 'CREATION' or 'ARTIFACT'
  TextColumn get title => text()();
  TextColumn get content => text()(); // File path or Raw Text
  TextColumn get prompt => text().nullable()();
  TextColumn get language => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [CorrectionHistory, UserSettings, CustomPersonalities, SavedData])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from < 2) {
          await m.createTable(customPersonalities);
        }
        if (from < 3) {
          // Add isImage and imageUrl to correctionHistory
          await m.addColumn(correctionHistory, correctionHistory.isImage);
          await m.addColumn(correctionHistory, correctionHistory.imageUrl);
        }
        if (from < 4) {
          await m.createTable(savedData);
        }
      },
      beforeOpen: (details) async {
        // Essential for older Android versions to support certain SQL features
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // ========== Saved Data Queries ==========
  
  Future<List<SavedDatum>> getAllSavedData() {
    return (select(savedData)..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).get();
  }

  Future<List<SavedDatum>> getSavedDataByType(String type) {
    return (select(savedData)
      ..where((t) => t.type.equals(type))
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
    .get();
  }

  Future<int> saveDatum(SavedDataCompanion entry) {
    return into(savedData).insert(entry);
  }

  Future<bool> deleteSavedDatum(int id) {
    return (delete(savedData)..where((t) => t.id.equals(id)))
        .go()
        .then((count) => count > 0);
  }

  // ========== Correction History Queries ==========
  
  /// Get all correction history entries (most recent first)
  Future<List<CorrectionHistoryData>> getHistory({int limit = 50}) {
    return (select(correctionHistory)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  /// Get a single history entry by ID
  Future<CorrectionHistoryData?> getHistoryEntry(int id) {
    return (select(correctionHistory)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Save a new correction history entry
  Future<int> saveHistoryEntry(CorrectionHistoryData entry) {
    return into(correctionHistory).insert(entry);
  }

  /// Delete a history entry by ID
  Future<bool> deleteHistoryEntry(int id) {
    return (delete(correctionHistory)..where((t) => t.id.equals(id)))
        .go()
        .then((count) => count > 0);
  }

  /// Clear all history entries
  Future<int> clearAllHistory() {
    return delete(correctionHistory).go();
  }

  /// Get history count
  Future<int> getHistoryCount() {
    return select(correctionHistory).get().then((list) => list.length);
  }

  // ========== User Settings Queries ==========
  
  /// Get current user settings (assumes single row)
  Future<UserSetting?> getSettings() {
    return select(userSettings).getSingleOrNull();
  }

  /// Insert or update user settings
  Future<int> saveSettings(UserSetting setting) {
    return into(userSettings).insertOnConflictUpdate(setting);
  }

  /// Update a specific setting field
  Future<int> updateActiveModel(String modelId) {
    return update(userSettings).write(
      UserSettingsCompanion(
        activeModelId: Value(modelId),
        lastUpdated: Value(DateTime.now()),
      ),
    );
  }

  Future<int> updateSelectedStyle(String style) {
    return update(userSettings).write(
      UserSettingsCompanion(
        selectedStyle: Value(style),
        lastUpdated: Value(DateTime.now()),
      ),
    );
  }

  Future<int> updateThemeMode(String themeMode) {
    return update(userSettings).write(
      UserSettingsCompanion(
        themeMode: Value(themeMode),
        lastUpdated: Value(DateTime.now()),
      ),
    );
  }

  // ========== Custom Personalities Queries ==========
  
  Future<List<CustomPersonality>> getAllCustomPersonalities() {
    return select(customPersonalities).get();
  }

  Future<int> saveCustomPersonality(CustomPersonality personality) {
    return into(customPersonalities).insertOnConflictUpdate(personality);
  }

  Future<int> deleteCustomPersonality(String id) {
    return (delete(customPersonalities)..where((t) => t.id.equals(id))).go();
  }
}
