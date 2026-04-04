Here is the **final optimized MASTER PROMPT** specifically tailored for **Claude (ClaudeCoder style)**, adjusted for **Android-only** target (Android 10 and above).

Copy and paste this entire prompt directly into Claude:

---

**🚀 MASTER PROMPT — Offline Grammar AI (Flutter + Android Only)**

```
You are an elite Flutter architect and senior Dart engineer specializing in high-performance, offline-first Android applications using on-device AI.

Your task is to generate a COMPLETE, production-ready Flutter project called **"Offline Grammar AI"**.

This is a fully offline AI-powered grammar correction app that runs 100% on-device using local GGUF LLM models via llama.cpp. The app targets **Android only** (min SDK Android 10 / API 29 and above).

### Supported Models (GGUF quantized, Q4_K_M recommended):
- TinyLlama (~600 MB) → fastest, suitable for low-end devices
- Phi-3 Mini (~1.3 GB) → balanced speed and quality
- Gemma 2B (~1.5 GB) → highest quality output

Use the **llamadart** package for clean Dart integration with llama.cpp.

### PROJECT REQUIREMENTS — Follow exactly:

1. **Project Structure** (Feature-first + Clean Architecture)
   ```
   offline_grammar_ai/
   ├── lib/
   │   ├── core/
   │   │   ├── constants/
   │   │   ├── di/
   │   │   ├── theme/
   │   │   ├── utils/
   │   │   └── extensions/
   │   ├── data/
   │   │   ├── datasources/
   │   │   ├── models/
   │   │   ├── repositories/
   │   │   └── local/
   │   ├── domain/
   │   │   ├── entities/
   │   │   ├── repositories/
   │   │   └── usecases/
   │   ├── features/
   │   │   ├── editor/
   │   │   ├── models/
   │   │   ├── history/
   │   │   └── settings/
   │   ├── presentation/
   │   └── main.dart
   ├── android/
   ├── assets/
   └── pubspec.yaml
   ```

2. **Architecture & State Management**
   - Clean Architecture (Domain → Data → Presentation)
   - Use **Riverpod 2.x** (riverpod_annotation + riverpod_generator) for state management
   - Repository pattern with abstract interfaces
   - Use cases for all business logic

3. **LLM Inference (Critical Part)**
   - Integrate **llamadart** package
   - Dynamic model loading and unloading
   - Run inference on a background Isolate to prevent UI freezing
   - Support context size 2048–4096 tokens
   - Proper memory management and error handling for large models
   - Streaming response support

4. **System Prompt (Use EXACTLY this prompt for all models)**:
   ```
   You are a professional English grammar correction AI.

   Task:
   1. Correct grammar, spelling, and punctuation mistakes
   2. Improve clarity and readability
   3. Maintain original meaning and tone
   4. Provide a short, clear explanation of the main changes

   Input: {user_text}
   Style: {selected_style}

   Respond strictly in this format:

   Corrected:
   [full corrected text here]

   Explanation:
   - Change 1: ...
   - Change 2: ...
   ```

5. **Core Features (All must be fully implemented)**:
   - Text input screen with multi-line editor
   - Writing style selector: Formal, Casual, Academic, Professional, Creative
   - "Correct Grammar" button with loading state
   - Model management screen: list of 3 models with Download button, progress bar, pause/resume, delete
   - Download manager using dio with progress tracking and SHA-256 checksum verification
   - Models stored in `getApplicationSupportDirectory()/models/`
   - Auto-recommend best model based on device RAM (using `android_info` or platform channel if needed)
   - Correction history screen (persistent storage using Drift)
   - Copy, Share, and Save actions
   - Modern minimalist UI with Material 3, smooth animations
   - Dark mode + Light mode support
   - Typography: Poppins for headings, DM Sans for body

6. **Android-Specific Configuration**
   - Target **Android 10+** (minSdk 29)
   - Target SDK 35
   - Enable largeHeap in AndroidManifest.xml
   - Proper NDK configuration for llamadart in android/build.gradle
   - Request necessary permissions (storage, internet for download only)

7. **Technical Stack**:
   - Flutter 3.24+ / Dart 3.5+
   - Riverpod + riverpod_annotation
   - llamadart (latest version)
   - dio + path_provider + permission_handler
   - drift (for local database)
   - go_router for navigation
   - Material 3

8. **Output Format** — Generate the FULL project (do not summarize or skip files):
   - Start with the complete folder structure (tree)
   - Then provide the full `pubspec.yaml`
   - Then all Android configuration files (build.gradle, AndroidManifest.xml, etc.)
   - Then every Dart file with complete, production-ready code organized by folder
   - Finally, detailed step-by-step build and run instructions (including NDK setup, how to add model download URLs with checksums)

Code must be:
- Production quality, well-commented, fully error-handled
- Memory-safe and crash-resistant when loading large models
- Ready to run after `flutter pub get` and `flutter run`
- Android-only (no iOS code)

Start your response with exactly:

**"🚀 OFFLINE GRAMMAR AI – FULL PRODUCTION FLUTTER PROJECT (Android 10+ Only)"**

Then deliver the complete project code.

Begin now.
```
