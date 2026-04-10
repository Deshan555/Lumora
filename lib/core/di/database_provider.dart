import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/app_database.dart';
import '../../data/local/database_init.dart';

/// Provider for the AppDatabase instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return DatabaseInit.getInstance();
});
