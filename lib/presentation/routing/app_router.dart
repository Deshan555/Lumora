import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_drawer.dart';
import '../../features/editor/presentation/editor_screen.dart';
import '../../features/models/presentation/model_hub_screen.dart';
import '../../features/my_models/presentation/my_models_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/settings/presentation/settings_hub.dart';
import '../../features/settings/presentation/performance_settings.dart';
import '../../features/settings/presentation/appearance_settings.dart';
import '../../features/settings/presentation/security_settings.dart';
import '../../features/settings/presentation/model_tuning_settings.dart';
import '../../features/settings/presentation/ai_behavior_settings.dart';
import '../../features/settings/presentation/about_settings.dart';
import '../../features/benchmarks/presentation/benchmarks_screen.dart';
import '../../features/system/presentation/system_screen.dart';
import '../../features/personality/presentation/personality_screen.dart';
import '../../features/system/presentation/splash_screen.dart';
import '../../features/system/presentation/onboarding_screen.dart';
import '../../core/di/state_providers.dart';
import '../../core/services/system_monitor_service.dart';

/// Application routes
class AppRoutes {
  static const String chat = '/';
  static const String modelHub = '/model-hub';
  static const String myModels = '/my-models';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String settingsPerformance = '/settings/performance';
  static const String settingsAppearance = '/settings/appearance';
  static const String settingsSecurity = '/settings/security';
  static const String settingsModelTuning = '/settings/model-tuning';
  static const String settingsAIBehavior = '/settings/ai-behavior';
  static const String settingsAbout = '/settings/about';
  static const String benchmarks = '/benchmarks';
  static const String system = '/system';
  static const String personality = '/personality';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
}

/// GoRouter configuration with RIGHT side drawer
final router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    // Shell route with drawer on RIGHT side
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child, currentRoute: state.uri.path);
      },
      routes: [
        GoRoute(
          path: AppRoutes.chat,
          builder: (context, state) => const EditorScreen(),
        ),
        GoRoute(
          path: AppRoutes.modelHub,
          builder: (context, state) => const ModelHubScreen(),
        ),
        GoRoute(
          path: AppRoutes.myModels,
          builder: (context, state) => const MyModelsScreen(),
        ),
        GoRoute(
          path: AppRoutes.history,
          builder: (context, state) => const HistoryScreen(),
        ),
        GoRoute(
          path: AppRoutes.settings,
          builder: (context, state) => const SettingsHub(),
        ),
        GoRoute(
          path: AppRoutes.settingsPerformance,
          builder: (context, state) => const PerformanceSettings(),
        ),
        GoRoute(
          path: AppRoutes.settingsAppearance,
          builder: (context, state) => const AppearanceSettings(),
        ),
        GoRoute(
          path: AppRoutes.settingsSecurity,
          builder: (context, state) => const SecuritySettings(),
        ),
        GoRoute(
          path: AppRoutes.settingsModelTuning,
          builder: (context, state) => const ModelTuningSettings(),
        ),
        GoRoute(
          path: AppRoutes.settingsAIBehavior,
          builder: (context, state) => const AIBehaviorSettings(),
        ),
        GoRoute(
          path: AppRoutes.settingsAbout,
          builder: (context, state) => const AboutSettings(),
        ),
        GoRoute(
          path: AppRoutes.benchmarks,
          builder: (context, state) => const BenchmarksScreen(),
        ),
        GoRoute(
          path: AppRoutes.system,
          builder: (context, state) => const SystemScreen(),
        ),
        GoRoute(
          path: AppRoutes.personality,
          builder: (context, state) => const PersonalityScreen(),
        ),
      ],
    ),
  ],
);

/// Main scaffold with RIGHT-side drawer and system monitoring
class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  final String currentRoute;

  const MainScaffold({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  final SystemMonitorService _monitorService = SystemMonitorService();

  @override
  void initState() {
    super.initState();
    // Start system monitoring when scaffold is initialized
    _monitorService.start(
      onUpdate: (state) {
        ref.read(systemMonitorProvider.notifier).state = state;
      },
    );
  }

  @override
  void dispose() {
    // Stop monitoring when scaffold is disposed
    _monitorService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Drawer on RIGHT side (endDrawer)
      endDrawer: AppDrawer(currentRoute: widget.currentRoute),
      body: widget.child,
    );
  }
}
