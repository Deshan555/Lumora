# 🚀 Offline Grammar AI — Project Implementation Plan

**Project:** grammer_llm (Offline Grammar AI)  
**Target:** Android 10+ (API 29+)  
**Framework:** Flutter 3.24+ / Dart 3.5+  
**Architecture:** Clean Architecture + Riverpod + Feature-first  

---

## 📋 PHASE 1: Project Setup & Configuration (Day 1)

### 1.1 Dependencies & Configuration
- [ ] Update `pubspec.yaml` with all required dependencies:
  - **State Management:** `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`
  - **Navigation:** `go_router`
  - **Networking:** `dio`, `dio_cache_interceptor`
  - **Database:** `drift`, `sqlite3_flutter_libs`, `path_provider`
  - **LLM Integration:** `llamadart` (or `llama_cpp` Dart bindings)
  - **Permissions:** `permission_handler`
  - **Device Info:** `android_info` or `device_info_plus`
  - **Utils:** `path`, `crypto` (SHA-256), `share_plus`, `flutter_markdown`
  - **Build Runners:** `build_runner`, `riverpod_generator`, `drift_dev`
- [ ] Configure Android `build.gradle` (minSdk 29, targetSdk 35, largeHeap, NDK)
- [ ] Configure `AndroidManifest.xml` (permissions, largeHeap)
- [ ] Setup NDK configuration for llama.cpp native compilation

### 1.2 Project Structure Setup
Create the feature-first clean architecture folder structure:
```
lib/
├── core/
│   ├── constants/          # App constants, system prompt
│   ├── di/                 # Dependency injection (Riverpod providers)
│   ├── theme/              # Material 3 theme, typography (Poppins, DM Sans)
│   ├── utils/              # Helper utilities, formatters
│   └── extensions/         # Dart extensions
├── data/
│   ├── datasources/        # Local data sources (LLM, DB, file)
│   ├── models/             # Data models (DTOs)
│   ├── repositories/       # Repository implementations
│   └── local/              # Drift database definitions
├── domain/
│   ├── entities/           # Core business entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/           # Business logic use cases
├── features/
│   ├── editor/             # Text input & correction screen
│   ├── models/             # Model management screen
│   ├── history/            # Correction history screen
│   └── settings/           # App settings screen
├── presentation/
│   ├── widgets/            # Shared UI components
│   └── routing/            # GoRouter configuration
└── main.dart               # App entry point
```

### 1.3 Asset & Resource Setup
- [ ] Add Google Fonts (Poppins, DM Sans) to pubspec or download to assets
- [ ] Create `assets/models/` directory structure
- [ ] Configure asset paths in pubspec.yaml

---

## 📋 PHASE 2: Core Infrastructure (Day 2-3)

### 2.1 Theme & Styling
- [ ] Create Material 3 light/dark theme configuration
- [ ] Setup typography with Poppins (headings) and DM Sans (body)
- [ ] Define color palette (primary, secondary, error, success)
- [ ] Create reusable widget themes (buttons, cards, inputs)

### 2.2 Dependency Injection (Riverpod)
- [ ] Setup Riverpod provider structure
- [ ] Create providers for:
  - `llmServiceProvider`
  - `modelRepositoryProvider`
  - `historyRepositoryProvider`
  - `settingsRepositoryProvider`
  - `downloadManagerProvider`

### 2.3 Database Layer (Drift)
- [ ] Define database schema for correction history:
  ```dart
  class CorrectionHistory extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get originalText => text()();
    TextColumn get correctedText => text()();
    TextColumn get explanation => text()();
    TextColumn get style => text()();
    TextColumn get modelName => text()();
    DateTimeColumn get timestamp => dateTime()();
  }
  ```
- [ ] Create DAOs for CRUD operations
- [ ] Setup database singleton with proper initialization

### 2.4 Utility Classes
- [ ] Create `SystemPrompt` class with the exact prompt template
- [ ] Create `ModelConfig` class for model metadata (name, size, URL, checksum)
- [ ] Create SHA-256 checksum verification utility
- [ ] Create device RAM detection utility

---

## 📋 PHASE 3: Domain Layer (Day 3-4)

### 3.1 Entities
- [ ] `CorrectionResult` entity (original, corrected, explanation, style)
- [ ] `ModelInfo` entity (id, name, size, downloadUrl, checksum, isDownloaded, isActive)
- [ ] `CorrectionHistoryEntry` entity
- [ ] `AppSettings` entity (selectedStyle, activeModel, theme, autoRecommend)

### 3.2 Repository Interfaces
- [ ] `ModelRepository` interface:
  ```dart
  abstract class ModelRepository {
    Future<List<ModelInfo>> getAvailableModels();
    Future<ModelInfo?> getActiveModel();
    Future<void> downloadModel(String modelId, {Function(double) onProgress});
    Future<void> pauseDownload(String modelId);
    Future<void> resumeDownload(String modelId);
    Future<void> deleteModel(String modelId);
    Future<bool> verifyModel(String modelId);
  }
  ```
- [ ] `CorrectionRepository` interface:
  ```dart
  abstract class CorrectionRepository {
    Stream<CorrectionResult> correctText(String text, String style);
    Future<void> initializeModel(ModelInfo model);
    Future<void> unloadModel();
  }
  ```
- [ ] `HistoryRepository` interface:
  ```dart
  abstract class HistoryRepository {
    Future<List<CorrectionHistoryEntry>> getHistory({int limit});
    Future<void> saveEntry(CorrectionHistoryEntry entry);
    Future<void> clearHistory();
    Future<void> deleteEntry(int id);
  }
  ```
- [ ] `SettingsRepository` interface:
  ```dart
  abstract class SettingsRepository {
    Future<AppSettings> getSettings();
    Future<void> updateSettings(AppSettings settings);
    Future<String> getRecommendedModel();
  }
  ```

### 3.3 Use Cases
- [ ] `GetAvailableModels` — fetch list of downloadable models
- [ ] `DownloadModel` — download with progress tracking
- [ ] `DeleteModel` — remove downloaded model
- [ ] `CorrectText` — execute grammar correction with streaming
- [ ] `GetHistory` — fetch correction history
- [ ] `SaveToHistory` — save correction result
- [ ] `GetDeviceRecommendation` — recommend model based on RAM
- [ ] `UpdateSettings` — persist user preferences

---

## 📋 PHASE 4: Data Layer (Day 4-6)

### 4.1 Model Repository Implementation
- [ ] Implement `ModelRepositoryImpl` with:
  - Predefined model list (TinyLlama, Phi-3 Mini, Gemma 2B)
  - Download URLs (HuggingFace or mirror)
  - SHA-256 checksums for verification
  - Local storage path: `getApplicationSupportDirectory()/models/`
- [ ] Create `ModelData` class with metadata:
  ```dart
  final models = [
    ModelInfo(
      id: 'tinyllama-1.1b-q4_k_m',
      name: 'TinyLlama 1.1B',
      size: 600_000_000,
      url: 'https://huggingface.co/...',
      checksum: 'sha256:...',
      ramRecommendation: '<= 4GB',
    ),
    // Phi-3, Gemma 2B...
  ];
  ```

### 4.2 Download Manager (Dio)
- [ ] Create `DownloadManager` class:
  - Dio instance with timeout configuration
  - `download(modelId, onProgress)` with pause/resume
  - Track download state (idle, downloading, paused, completed, failed)
  - SHA-256 checksum verification post-download
  - Handle network interruptions gracefully
- [ ] Create download state tracking system

### 4.3 LLM Service Integration (llamadart)
- [ ] Create `LLMService` class:
  ```dart
  class LLMService {
    Future<void> initialize(String modelPath);
    Stream<String> generateStream(String prompt);
    Future<void> unload();
  }
  ```
- [ ] Implement background isolate execution:
  - Use `compute()` or `Isolate.spawn()` for model loading
  - Prevent UI thread blocking
  - Handle isolate lifecycle (init, run, dispose)
- [ ] Implement streaming response parsing
- [ ] Handle context window (2048-4096 tokens)
- [ ] Memory management (load/unload on demand)
- [ ] Error handling for OOM, model not found, etc.

### 4.4 Correction Repository Implementation
- [ ] Implement `CorrectionRepositoryImpl`:
  - Format input text with system prompt
  - Stream responses from LLM
  - Parse response into `CorrectionResult`
  - Handle malformed responses gracefully
- [ ] Implement text formatting and response parsing:
  ```dart
  // Parse LLM output:
  // "Corrected:\n[corrected text]\n\nExplanation:\n- ..."
  ```

### 4.5 History Repository Implementation
- [ ] Implement `HistoryRepositoryImpl` using Drift
- [ ] Implement pagination/limiting for history queries
- [ ] Add search/filter capability (optional)

### 4.6 Settings Repository Implementation
- [ ] Implement `SettingsRepositoryImpl` with local storage (SharedPreferences or Drift)
- [ ] Implement device RAM detection and model recommendation logic:
  ```dart
  String recommendModel(int ramGB) {
    if (ramGB <= 4) return 'tinyllama';
    if (ramGB <= 6) return 'phi-3-mini';
    return 'gemma-2b';
  }
  ```

---

## 📋 PHASE 5: Presentation Layer (Day 6-9)

### 5.1 Navigation Setup (GoRouter)
- [ ] Configure routes:
  - `/` → Editor Screen (home)
  - `/models` → Model Management Screen
  - `/history` → Correction History Screen
  - `/settings` → App Settings Screen
- [ ] Add smooth page transitions
- [ ] Handle back navigation properly

### 5.2 Editor Screen (Main Screen)
- [ ] Multi-line text input field (min 10 lines, expandable)
- [ ] Writing style dropdown (Formal, Casual, Academic, Professional, Creative)
- [ ] "Correct Grammar" button with loading state
- [ ] Display corrected text output with streaming animation
- [ ] Display explanation section (bullet points)
- [ ] Copy, Share, Save action buttons
- [ ] Loading indicators during model loading/inference
- [ ] Error snackbar for failures
- [ ] Character/word count (optional enhancement)

### 5.3 Model Management Screen
- [ ] List of 3 models with:
  - Model name, size, description
  - Download progress bar
  - Download/Pause/Resume/Delete buttons (state-dependent)
  - Active model indicator
  - "Recommended" badge based on device RAM
- [ ] Download progress tracking UI
- [ ] Confirmation dialog for delete
- [ ] SHA-256 verification status display

### 5.4 History Screen
- [ ] List of past corrections (reverse chronological)
- [ ] Tap to expand and see full original + corrected text
- [ ] Delete individual entries
- [ ] "Clear All History" option
- [ ] Empty state message when no history
- [ ] Search/filter functionality (optional)

### 5.5 Settings Screen
- [ ] Writing style default selector
- [ ] Theme toggle (Light/Dark/System)
- [ ] Active model selector
- [ ] Model auto-recommendation info
- [ ] Storage usage display
- [ ] "Clear Cache" option
- [ ] About section (app version, licenses)

### 5.6 Shared Widgets
- [ ] `LoadingOverlay` — full-screen loading spinner
- [ ] `GradientCard` — styled card for sections
- [ ] `PrimaryButton` / `SecondaryButton` — themed buttons
- [ ] `ModelTile` — model list item widget
- [ ] `HistoryTile` — history list item widget
- [ ] `ExplanationCard` — formatted explanation display
- [ ] `EmptyState` — placeholder for empty lists

---

## 📋 PHASE 6: Advanced Features (Day 9-10)

### 6.1 Model Auto-Recommendation
- [ ] Detect device RAM at startup
- [ ] Auto-select recommended model
- [ ] Show "Recommended" badge in model list
- [ ] Auto-download recommended model if none exists (with user consent)

### 6.2 Streaming UI
- [ ] Real-time text streaming during correction
- [ ] Typing animation for corrected text
- [ ] Smooth expansion of explanation section
- [ ] Cancel generation button

### 6.3 Memory Management
- [ ] Unload model when navigating away from editor
- [ ] Reload on return (with caching if possible)
- [ ] Handle Android lifecycle (pause/resume)
- [ ] Monitor memory usage and warn if low

### 6.4 Offline Verification
- [ ] SHA-256 checksum verification after download
- [ ] Graceful error if model file is corrupted
- [ ] Redownload corrupted model option
- [ ] Validate model file integrity on app startup

---

## 📋 PHASE 7: Testing & Polish (Day 10-12)

### 7.1 Unit Testing
- [ ] Test use cases (mock repositories)
- [ ] Test repository logic
- [ ] Test checksum verification
- [ ] Test response parsing
- [ ] Test model recommendation logic

### 7.2 Widget Testing
- [ ] Test UI components in isolation
- [ ] Test form inputs and validation
- [ ] Test list rendering

### 7.3 Integration Testing
- [ ] Test full correction flow (input → LLM → output)
- [ ] Test download flow (download → verify → activate)
- [ ] Test history save/retrieval
- [ ] Test settings persistence

### 7.4 UI/UX Polish
- [ ] Smooth animations (Hero, Fade, Slide)
- [ ] Proper spacing and padding across all screens
- [ ] Haptic feedback on button presses
- [ ] Toast/snackbar notifications
- [ ] Error boundaries and fallback UI
- [ ] Loading states for async operations

### 7.5 Performance Optimization
- [ ] Profile app startup time
- [ ] Profile model loading time
- [ ] Optimize image/font assets
- [ ] Test on low-end Android device (4GB RAM)
- [ ] Verify no UI jank during inference
- [ ] Memory profiling during load/unload cycles

---

## 📋 PHASE 8: Build & Deployment (Day 12-13)

### 8.1 Android Configuration
- [ ] Verify minSdk 29, targetSdk 35
- [ ] Verify NDK setup for llama.cpp
- [ ] Verify largeHeap configuration
- [ ] Test on emulator (API 29, 30, 33, 35)
- [ ] Test on physical device (Android 10+)

### 8.2 Release Build
- [ ] Configure app signing
- [ ] Build APK: `flutter build apk --release`
- [ ] Build App Bundle (if publishing to Play Store): `flutter build appbundle`
- [ ] Test release build thoroughly
- [ ] Verify all features work offline

### 8.3 Documentation
- [ ] Update README.md with:
  - App description
  - Setup instructions
  - How to add model download URLs
  - How to build and run
  - NDK setup guide
  - Troubleshooting tips

---

## 📦 DEPENDENCY LIST

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  
  # Navigation
  go_router: ^14.2.0
  
  # Networking
  dio: ^5.5.0+1
  
  # Database
  drift: ^2.18.0
  sqlite3_flutter_libs: ^0.5.24
  
  # LLM
  llamadart: ^0.0.3  # Verify latest version
  
  # Utils
  path_provider: ^2.1.3
  permission_handler: ^11.3.1
  android_info: ^2.0.0  # or device_info_plus
  crypto: ^3.0.3
  share_plus: ^9.0.0
  path: ^1.9.0
  uuid: ^4.4.0
  
  # UI
  google_fonts: ^6.2.1
  flutter_markdown: ^0.7.2+1
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  
  # Code Generation
  build_runner: ^2.4.11
  riverpod_generator: ^2.4.0
  drift_dev: ^2.18.0
```

---

## 🔧 CRITICAL CONFIGURATION FILES

### Android `build.gradle` (app-level)
- NDK configuration
- minSdk 29, targetSdk 35
- largeHeap true
- Proguard rules for llama.cpp

### Android `AndroidManifest.xml`
- `<uses-permission android:name="android.permission.INTERNET" />`
- `<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />`
- `android:largeHeap="true"` in application tag
- Storage permissions if needed

### NDK Setup
- Install NDK via Android Studio SDK Manager
- Configure in `android/app/build.gradle`:
  ```gradle
  ndk {
    abiFilters 'arm64-v8a', 'armeabi-v7a', 'x86_64'
  }
  ```

---

## 🎯 MODEL DOWNLOAD URLs & CHECKSUMS (To be filled)

You need to provide:
1. **TinyLlama 1.1B Q4_K_M** (~600MB)
   - URL: (HuggingFace GGUF link)
   - SHA-256: (checksum)

2. **Phi-3 Mini Q4_K_M** (~1.3GB)
   - URL: (HuggingFace GGUF link)
   - SHA-256: (checksum)

3. **Gemma 2B Q4_K_M** (~1.5GB)
   - URL: (HuggingFace GGUF link)
   - SHA-256: (checksum)

> **Where to find:** HuggingFace model repositories (e.g., `TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF`)

---

## 🚀 STEP-BY-STEP BUILD INSTRUCTIONS

### Prerequisites
1. Install Flutter 3.24+ and Dart 3.5+
2. Install Android Studio with NDK
3. Set up Android SDK (API 29+)
4. Configure Android emulator or physical device

### Setup Steps
```bash
# 1. Clone or navigate to project
cd /Users/user/StudioProjects/grammer_llm

# 2. Get dependencies
flutter pub get

# 3. Run code generation
dart run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run

# 5. Build release APK
flutter build apk --release
```

### Troubleshooting
- **NDK errors:** Ensure NDK is installed and `ndk.dir` is set in `local.properties`
- **Model download fails:** Check URL, verify checksum, ensure stable internet
- **OOM errors:** Use smaller model (TinyLlama), enable largeHeap
- **Build errors:** Run `flutter clean && flutter pub get`

---

## ⚠️ KNOWN CHALLENGES & MITIGATION

| Challenge | Mitigation |
|-----------|------------|
| Large model loading on low-end devices | Auto-recommend TinyLlama for <4GB RAM |
| Memory leaks from llama.cpp | Properly unload model, use isolates |
| Long download times | Pause/resume support, progress tracking |
| SHA-256 verification failures | Re-download option, clear error messages |
| Streaming response parsing | Robust regex/parsing with fallback |
| NDK compilation issues | Follow llamadart setup guide exactly |

---

## 📊 PROJECT TIMELINE ESTIMATE

| Phase | Duration | Status |
|-------|----------|--------|
| Phase 1: Setup | 1 day | ⬜ Not Started |
| Phase 2: Infrastructure | 2 days | ⬜ Not Started |
| Phase 3: Domain Layer | 1-2 days | ⬜ Not Started |
| Phase 4: Data Layer | 2-3 days | ⬜ Not Started |
| Phase 5: Presentation | 3-4 days | ⬜ Not Started |
| Phase 6: Advanced Features | 1-2 days | ⬜ Not Started |
| Phase 7: Testing & Polish | 2-3 days | ⬜ Not Started |
| Phase 8: Build & Deploy | 1-2 days | ⬜ Not Started |
| **Total** | **~13-18 days** | |

---

## ✅ NEXT STEPS

1. **Review and approve this implementation plan**
2. **Provide model download URLs and SHA-256 checksums**
3. **Begin Phase 1: Project Setup & Configuration**
4. **Implement iteratively, phase by phase**
5. **Test after each phase before moving to next**

---

*Last Updated: April 4, 2026*  
*Project: Offline Grammar AI (grammer_llm)*  
*Target: Android 10+ | Flutter 3.24+ | Clean Architecture*
