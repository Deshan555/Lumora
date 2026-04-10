import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/edge_theme.dart';
import 'presentation/routing/app_router.dart';
import 'data/datasources/external_model_storage.dart';
import 'data/local/database_init.dart';
import 'core/services/tts_service.dart';
import 'core/di/state_providers.dart';
import 'data/repositories/settings_repository.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: EdgeTheme.primaryBackground,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  // Initialize external storage for models
  await ExternalModelStorageService.initialize();
  
  // Initialize database
  DatabaseInit.getInstance();
  
  // Initialize TTS
  TTSService.initialize();
  
  // Initialize Notifications
  await NotificationService.initialize();
  
  // Pre-load settings
  final container = ProviderContainer();
  final settings = await container.read(settingsRepositoryProvider).getSettings();
  container.read(settingsProvider.notifier).loadSettings(settings);
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const BrainyApp(),
    ),
  );
}

class BrainyApp extends ConsumerWidget {
  const BrainyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Always use dark premium theme for Brainy.Ai
    return MaterialApp.router(
      title: 'BRAINY.AI',
      debugShowCheckedModeBanner: false,
      theme: EdgeTheme.darkTheme.copyWith(
        canvasColor: Colors.transparent,
      ),
      darkTheme: EdgeTheme.darkTheme.copyWith(
        canvasColor: Colors.transparent,
      ),
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
