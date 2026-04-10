# BRAINY.AI

**Premium Offline AI Chat App — On-Device LLM Intelligence**

<div align="center">

![Version](https://img.shields.io/badge/version-1.1.0-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.5+-0175C2?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%2010%2B-3DDC84?logo=android)
![License](https://img.shields.io/badge/License-MIT-green)

**Secure · Offline · Private**

</div>

---

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Dual-Engine LLM Architecture](#dual-engine-llm-architecture)
- [Screens & Navigation](#screens--navigation)
- [Supported AI Models](#supported-ai-models)
- [Settings & Configuration](#settings--configuration)
- [Services & Core Modules](#services--core-modules)
- [Architecture & Tech Stack](#architecture--tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Building & Running](#building--running)
- [Permissions](#permissions)
- [Performance & Benchmarks](#performance--benchmarks)
- [Troubleshooting](#troubleshooting)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

BRAINY.AI is a premium, fully offline AI chat application that runs Large Language Models (LLMs) directly on your Android device — no internet connection required. Powered by a dual-engine architecture (llama.cpp + LiteRT-LM), it supports GGUF and LiteRT model formats with GPU/NPU hardware acceleration.

Your conversations, files, and AI interactions never leave your device. No cloud, no tracking, no data collection. Just pure edge computing intelligence.

### Core Philosophy

| Principle | Description |
|-----------|-------------|
| **100% Offline** | All inference runs locally on-device. No API calls, no cloud dependency |
| **Zero Tracking** | No analytics, no crash reporting, no usage telemetry |
| **Privacy First** | Messages, files, and history stored only in local encrypted storage |
| **Hardware Accelerated** | Vulkan, Metal, OpenCL, and NPU backends for maximum performance |
| **Premium UX** | Dark glassmorphism theme, particle effects, animated visualizers |

---

## Key Features

### AI Chat
- **Streaming Responses** — Token-by-token real-time generation with typing indicators
- **Markdown Rendering** — Full markdown support with code blocks, headers, lists, bold, italic
- **Syntax Highlighting** — Code preview with language detection and copy-to-clipboard
- **Multi-Format Attachments** — Images (JPEG, PNG), PDFs, TXT, MD, CSV, DOCX files
- **Image Processing** — Filters (Grayscale, Sepia, Invert, Vivid), wallpaper setting, gallery save
- **Text-to-Speech** — AI responses spoken aloud with configurable pitch and speed
- **Voice Input** — Tap-to-talk speech recognition with partial result streaming

### Live Mode
- **Immersive Voice Chat** — Gemini Live-style hands-free conversation
- **Continuous Listening** — Auto-detect silence (2.5s threshold) and auto-send
- **Real-Time Transcript** — Live transcription of your speech and AI responses
- **State-Aware Visualizer** — Animated aura that changes color per state (listening/thinking/speaking)
- **AI Interrupt** — Tap to stop the AI mid-response
- **Frosted Glass UI** — Blur backdrop with gradient animations

### Model Management
- **Local Catalog** — 19+ pre-configured models across 6 categories (Text, Code, Math, Creative, Translation, Reasoning)
- **Hugging Face Hub** — Cloud mode with HF model search, download, and remote inference
- **Download Manager** — Progress bar, pause/resume, multi-file downloads
- **Model Import** — Import custom GGUF/LiteRT files from device storage
- **Active Model Switching** — Load/unload models with one tap
- **Remote Inference** — Cloud-based text generation and image generation via HF API

### System Monitoring
- **Persistent Status Bar** — RAM and CPU usage shown in Android notification bar
- **Real-Time Stats** — Total/used/available RAM, CPU percentage, usage history
- **Benchmark Suite** — Tokens/sec measurement, prefill latency, performance grading
- **Hardware Detection** — Device info, Android version, RAM capacity, NPU/GPU availability

### Security & Privacy
- **Biometric Lock** — Face ID / Fingerprint authentication on app launch
- **Local Storage** — All data stored in on-device SQLite database (Drift)
- **Secure Token Storage** — Hugging Face tokens encrypted with flutter_secure_storage
- **No Network Calls** — Except when explicitly using Hugging Face cloud inference

### Customization
- **AI Personalities** — 4 preset + custom personalities with trait intensity sliders
- **Theme System** — Dark premium theme with glassmorphism and particle effects
- **Generation Parameters** — Temperature, Top-P, Top-K, Max Tokens, Context Size
- **Behavior Settings** — Deep reasoning toggle, response summaries, voice visualizer

---

## Dual-Engine LLM Architecture

BRAINY.AI uses a master orchestration layer (`LLMService`) that automatically selects the best engine based on model file format:

### Engine 1: llama.cpp (`llamadart`)
| Feature | Details |
|---------|---------|
| **Format** | GGUF (`.gguf`, `.gguf.bin`) |
| **GPU Backends** | Vulkan (Android), Metal (iOS/macOS), CUDA (NVIDIA), OpenCL |
| **Models** | TinyLlama, Phi-3, Qwen, Llama 3, Mistral, Mixtral, StarCoder2, CodeQwen, WizardMath |
| **Streaming** | Token-by-token via callback |
| **Compilation** | Auto-compiles native `.so` binaries during Gradle build |

### Engine 2: LiteRT-LM (`flutter_gemma`)
| Feature | Details |
|---------|---------|
| **Format** | LiteRT (`.litertlm`, `.task`) |
| **GPU Backends** | OpenCL (Android), Metal (iOS) |
| **NPU Support** | MediaTek, Qualcomm, Google Tensor accelerators |
| **Models** | Gemma 2B/7B (optimized), Gemma-derived quantized variants |
| **API** | Message-based session with async streaming |

### Automatic Engine Selection
```
Model File → LLMService.detectRuntime() → Route to Engine
.gguf      → llamaCpp / llamaCppVulkan / llamaCppMetal
.litertlm  → LiteRT / LiteRTGpu / LiteRTNpu
Remote     → HuggingFaceService (cloud inference)
```

### Hugging Face Cloud Inference
For models too large for on-device execution:
- **Text Generation** — Serverless inference via HF Inference API (SSE streaming)
- **Image Generation** — Text-to-image models (Stable Diffusion, FLUX)
- **Vision Models** — Multimodal chat completions (image + text input)
- **Profile Integration** — Token validation, plan status, avatar display

---

## Screens & Navigation

The app uses `go_router` with a `ShellRoute` pattern and a right-side drawer (`endDrawer`) for navigation.

### Route Map

| Route | Screen | Description |
|-------|--------|-------------|
| `/splash` | `SplashScreen` | Biometric auth + loading + onboarding check |
| `/onboarding` | `OnboardingScreen` | 4-page intro carousel + permission requests |
| `/` | `EditorScreen` | Main AI chat interface |
| `/model-hub` | `ModelHubScreen` | Browse, search, and download models |
| `/my-models` | `MyModelsScreen` | Manage and activate downloaded models |
| `/history` | `HistoryScreen` | Chat history logs with save/purge |
| `/settings` | `SettingsHub` | Settings category navigation |
| `/settings/performance` | `PerformanceSettings` | GPU acceleration, memory optimization |
| `/settings/appearance` | `AppearanceSettings` | Theme mode, notifications |
| `/settings/security` | `SecuritySettings` | Biometric lock, privacy info |
| `/settings/model-tuning` | `ModelTuningSettings` | Temperature, Top-P, Top-K, tokens, context |
| `/settings/ai-behavior` | `AIBehaviorSettings` | Deep reasoning, summaries, voice config |
| `/settings/about` | `AboutSettings` | Version, build info, tech stack |
| `/settings/saved-data` | `SavedDataScreen` | Creations grid + code artifacts |
| `/settings/hf-account` | `HFAccountScreen` | Hugging Face profile management |
| `/benchmarks` | `BenchmarksScreen` | Performance diagnostics and grading |
| `/personality` | `PersonalityScreen` | AI personality calibration |
| `/system` | `SystemScreen` | RAM/CPU monitoring and engine control |

### Navigation Flow
```
App Launch → SplashScreen → (biometric check) → OnboardingScreen (first launch)
                                               → EditorScreen (returning user)

EditorScreen → Drawer (endDrawer) → Navigate to any screen
            → "LIVE" button → LiveChatScreen (immersive voice mode)
```

---

## Supported AI Models

### On-Device Models (GGUF Format via llama.cpp)

#### Text Models
| Model | Size | RAM Required | Context | Description |
|-------|------|-------------|---------|-------------|
| TinyLlama 1.1B | ~600MB | 2GB+ | 2048 | Ultra-lightweight, fast responses |
| Phi-3 Mini | ~2GB | 4GB+ | 4096 | Microsoft's compact reasoning model |
| Qwen2.5 1.5B | ~1GB | 3GB+ | 4096 | Alibaba's multilingual model |
| Llama 3 8B (Q4) | ~4.5GB | 8GB+ | 8192 | Meta's flagship model, quantized |
| Mistral 7B (Q4) | ~4GB | 8GB+ | 8192 | High-quality open-weight model |

#### Code Models
| Model | Size | RAM Required | Description |
|-------|------|-------------|-------------|
| StarCoder2 3B | ~2GB | 4GB+ | Multi-language code generation |
| CodeQwen 1.5B | ~1GB | 3GB+ | Code completion and explanation |
| DeepSeek Coder 1.3B | ~800MB | 2GB+ | Lightweight code model |

#### Math & Reasoning
| Model | Size | RAM Required | Description |
|-------|------|-------------|-------------|
| WizardMath 7B (Q4) | ~4GB | 8GB+ | Math problem solving |
| OpenChat 3.5 7B (Q4) | ~4GB | 8GB+ | General reasoning |

#### Translation
| Model | Size | RAM Required | Description |
|-------|------|-------------|-------------|
| MADLAD-400 3B | ~2GB | 4GB+ | 100+ language translation |
| NLLB-200 3B | ~2GB | 4GB+ | Meta's multilingual translator |

#### Creative
| Model | Size | RAM Required | Description |
|-------|------|-------------|-------------|
| Phi-3 Mini (Creative) | ~2GB | 4GB+ | Story generation, creative writing |
| Mistral 7B (Creative) | ~4GB | 8GB+ | Long-form creative text |

### Cloud Models (Hugging Face Inference API)

| Task | Models | Description |
|------|--------|-------------|
| Text Generation | HuggingFaceH4/zephyr-7b-beta, meta-llama/Meta-Llama-3-8B-Instruct | Remote inference for heavy models |
| Image Generation | stabilityai/stable-diffusion-3-medium, black-forest-labs/FLUX.1-schnell | Text-to-image generation |
| Vision | OpenAI-compatible multimodal endpoints | Image + text understanding |

---

## Settings & Configuration

### Performance Settings
| Setting | Default | Description |
|---------|---------|-------------|
| **GPU Acceleration** | Auto | Select runtime: CPU, Vulkan, Metal, OpenCL, NPU |
| **Low RAM Mode** | Off | Reduce context window and batch size for low-memory devices |
| **Terminate on Background** | Off | Unload model when app goes to background (saves RAM) |
| **Aggressive Memory Saving** | Off | Force garbage collection between generations |
| **Clear Cache on Exit** | Off | Delete temporary model files on app close |

### Model Tuning
| Parameter | Range | Default | Description |
|-----------|-------|---------|-------------|
| **Temperature** | 0.0 – 2.0 | 0.8 | Randomness of responses (low = focused, high = creative) |
| **Top-P** | 0.0 – 1.0 | 0.95 | Nucleus sampling threshold |
| **Top-K** | 1 – 100 | 40 | Number of top tokens to consider |
| **Max Tokens** | 64 – 4096 | 512 | Maximum response length |
| **Context Size** | 512 – 32768 | 2048 | Conversation memory window |

### AI Behavior
| Setting | Description |
|---------|-------------|
| **Disable Deep Reasoning** | Skip complex reasoning steps for faster responses |
| **Response Summary** | Show notification when AI finishes responding |
| **Voice Visualizer** | Show audio waveform animation during TTS playback |
| **AI Voice** | Enable text-to-speech for all AI responses |
| **Voice Pitch** | TTS pitch adjustment (-1.0 to 1.0) |
| **Voice Speed** | TTS speaking rate (0.5x to 2.0x) |

### AI Personalities
| Personality | Traits | Use Case |
|-------------|--------|----------|
| **Friendly Assistant** | Casual, empathetic, concise | General conversation |
| **Code Expert** | Formal, detailed, technical | Programming help |
| **Comedy Bot** | High humor, casual | Entertainment |
| **Counselor** | High empathetic, formal | Supportive conversation |
| **Custom** | User-defined | Any use case |

### Security
| Setting | Description |
|---------|-------------|
| **Biometric Lock** | Require face/fingerprint to open app |
| **Hugging Face Token** | Encrypted storage of HF API token |
| **Local Storage Only** | No data sent to external servers |
| **End-to-End Private** | No analytics, no crash reporting, no telemetry |

---

## Services & Core Modules

### Core Services

| Service | Package | Purpose |
|---------|---------|---------|
| `LLMService` | Internal | Master engine orchestrator — routes requests to llama.cpp or LiteRT |
| `HuggingFaceService` | Dio | HF Hub API integration — model search, downloads, cloud inference |
| `TTSService` | flutter_tts | Text-to-speech with pitch/speed control |
| `VoiceInputService` | speech_to_text | Speech-to-text with continuous listening and silence detection |
| `NotificationService` | flutter_local_notifications | AI response notifications + persistent system monitor |
| `SystemMonitorService` | Internal | Periodic RAM/CPU stats collection (every 10 seconds) |
| `ImageService` | image, gal | Image filtering, gallery save, wallpaper setting |
| `PromptTemplateService` | Internal | Model-specific prompt formatting (Gemma, Llama 3, Phi-3, ChatML) |
| `WallpaperService` | async_wallpaper | Set AI-generated images as device wallpaper |

### Data Layer

| Module | Package | Purpose |
|--------|---------|---------|
| `AppDatabase` | Drift (SQLite) | Local persistence for settings, history, corrections |
| `SettingsRepository` | Internal | CRUD operations for AppSettings |
| `HistoryRepository` | Internal | Chat history storage and retrieval |
| `ModelRepository` | Internal | Model metadata and download state tracking |
| `CorrectionRepository` | Internal | Grammar/style correction history |
| `ExternalModelStorage` | path_provider | Manage downloaded model files on device |
| `DownloadManager` | Dio | Parallel model downloads with progress tracking |

### Utilities

| Utility | Purpose |
|---------|---------|
| `SystemInfoService` | Read `/proc/meminfo` and `/proc/stat` for RAM/CPU stats |
| `RamHistoryTracker` | Persist RAM usage snapshots to SharedPreferences |
| `BenchmarkService` | Measure tokens/sec, prefill latency, peak RAM |
| `DeviceUtils` | Device RAM detection and model recommendation |
| `ModelMetadataExtractor` | Parse GGUF/LiteRT headers for model info |
| `ResponseParser` | Parse streaming LLM output into structured messages |
| `ChecksumUtils` | SHA-256 verification for downloaded model files |

---

## Architecture & Tech Stack

### Technology Stack

| Layer | Technology |
|-------|-----------|
| **Framework** | Flutter 3.24+ (Material Design 3) |
| **Language** | Dart 3.5+ |
| **State Management** | Riverpod 2.6+ (Code-generated providers) |
| **Navigation** | go_router 14.8+ (ShellRoute with endDrawer) |
| **Local Database** | Drift 2.19+ (SQLite with code generation) |
| **Networking** | Dio 5.5+ (HTTP client with interceptors) |
| **LLM Engine 1** | llamadart 0.6.9 (llama.cpp bindings) |
| **LLM Engine 2** | flutter_gemma 0.10.2 (LiteRT-LM bindings) |
| **Voice** | flutter_tts 4.2+ / speech_to_text 7.0+ |
| **Notifications** | flutter_local_notifications 21.0+ |
| **Security** | flutter_secure_storage 10.0+ / local_auth 2.3+ |
| **UI** | flutter_markdown, font_awesome_flutter, google_fonts |
| **Image Processing** | image 4.3+ / photo_view / gal |
| **File Handling** | file_picker 8.3+ / path_provider 2.1+ |

### Architecture Pattern

```
┌─────────────────────────────────────────────────────┐
│                   PRESENTATION                       │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌───────────┐  │
│  │ Screens │ │ Widgets │ │ Routing │ │ Providers │  │
│  └────┬────┘ └────┬────┘ └────┬────┘ └─────┬─────┘  │
└───────┼───────────┼───────────┼────────────┼────────┘
        │           │           │            │
┌───────┼───────────┼───────────┼────────────┼────────┐
│       ▼           ▼           ▼            ▼        │
│                    DOMAIN                             │
│  ┌─────────────────────────────────────────────┐    │
│  │  Entities: ModelInfo, AppSettings,           │    │
│  │  CorrectionHistoryEntry, AIPersonality       │    │
│  └─────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────┐    │
│  │  Repositories: Settings, History, Model,     │    │
│  │  Correction (interfaces)                     │    │
│  └─────────────────────────────────────────────┘    │
└───────┬──────────────────────────────────────┬──────
        │                                      │
───────┼──────────────────────────────────────┼──────┐
│       ▼                                      ▼      │
│                     DATA                          │
│  ┌─────────────────────────────────────────────┐    │
│  │  DataSources: LLMService, HuggingFace,       │    │
│  │  LiteRTEngine, LlamaCppEngine, DownloadMgr   │    │
│  └─────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────┐    │
│  │  Repositories Impl: SQLite (Drift),          │    │
│  │  SharedPreferences, Secure Storage           │    │
│  └─────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────┘
```

### State Management Flow

```
User Action → Event Handler → Provider Notifier → State Update → Widget Rebuild
     │              │                │                 │              │
     ▼              ▼                ▼                 ▼              ▼
  Tap Send    _sendMessage()   modelsListProvider   activeModel   MessageList
  Button                      .notifier.state        Provider      rebuilds
```

---

## Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants, model catalog, storage paths
│   ├── di/                 # Dependency injection (Riverpod providers)
│   ├── models/             # AI personality model
│   ├── services/           # Core services (TTS, voice, notifications, monitor)
│   ├── theme/              # App theme, EdgeTheme (dark glassmorphism)
│   └── utils/              # Utilities (system info, benchmarks, device utils)
├── data/
│   ├── datasources/        # LLM engines, HF service, download manager, storage
│   ├── local/              # Drift database, database initialization
│   └── repositories/       # Repository implementations (SQLite, SharedPreferences)
├── domain/
│   ├── entities/           # Data models (ModelInfo, AppSettings, etc.)
│   └── repositories/       # Repository interfaces
├── features/
│   ├── benchmarks/         # Performance benchmark screen
│   ├── editor/             # Main chat editor + live chat mode
│   ├── history/            # Chat history screen
│   ├── models/             # Model hub (browse/download)
│   ├── models_manager/     # My models management
│   ├── my_models/          # Downloaded models list
│   ├── personality/        # AI personality calibration
│   ├── settings/           # All settings screens (6 categories)
│   └── system/             # Splash, onboarding, system monitor
└── presentation/
    ├── routing/            # go_router configuration
    └── widgets/            # Shared widgets (particles, edge lighting)

android/                    # Android native configuration
├── app/src/main/
│   ├── AndroidManifest.xml # Permissions, activities, native library refs
│   └── kotlin/             # MainActivity with native library loading
assets/
├── models/                 # Bundled model files (if any)
└── logo/                   # App icon and branding
```

---

## Getting Started

### Prerequisites

| Requirement | Version |
|-------------|---------|
| Flutter SDK | 3.24.0 or higher |
| Dart SDK | 3.5.0 or higher |
| Android SDK | API 29+ (Android 10) |
| Java / JDK | 17+ |
| CMake | 3.22+ (for native library compilation) |
| NDK | 26+ (for llama.cpp native build) |

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/Deshan555/grammer_llm.git
cd grammer_llm

# 2. Install Flutter dependencies
flutter pub get

# 3. Run code generation (Riverpod, Drift)
dart run build_runner build --delete-conflicting-outputs

# 4. Verify setup
flutter doctor -v
```

### Configuration

No API keys or external configuration required for local mode. For Hugging Face cloud features:

1. Open app → Settings → Hugging Face
2. Paste your HF token (format: `hf_xxxxxxxxxxxx`)
3. Token is stored encrypted in flutter_secure_storage

---

## Building & Running

### Development

```bash
# Run in debug mode
flutter run

# Run with hot reload
flutter run --hot

# Run on specific device
flutter devices
flutter run -d <device-id>
```

### Production Build

```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build release App Bundle (for Play Store)
flutter build appbundle --release

# Build with split APKs per ABI (smaller downloads)
flutter build apk --split-per-abi --release
```

### Native Library Compilation

The llama.cpp engine auto-compiles native `.so` binaries during the Gradle build:

```
android/app/CMakeLists.txt → libllama.so, libllamadart.so
```

Supported ABIs: `armeabi-v7a`, `arm64-v8a`, `x86`, `x86_64`

### GPU Backend Configuration

GPU acceleration is auto-detected at runtime:

| Platform | Backend | Auto-Detected |
|----------|---------|---------------|
| Android (Qualcomm) | OpenCL / Vulkan | Yes |
| Android (MediaTek) | OpenCL / NPU | Yes |
| Android (Samsung Exynos) | Vulkan | Yes |
| iOS / macOS | Metal | Yes |
| Linux (NVIDIA) | CUDA / Vulkan | Yes |

---

## Permissions

| Permission | Purpose | Android Version |
|------------|---------|-----------------|
| `INTERNET` | Hugging Face cloud inference, model downloads | All |
| `ACCESS_NETWORK_STATE` | Check connectivity before downloads | All |
| `READ_EXTERNAL_STORAGE` | Import model files from device (Android 12-) | ≤ Android 12 |
| `WRITE_EXTERNAL_STORAGE` | Save generated images to gallery (Android 10-) | ≤ Android 10 |
| `READ_MEDIA_IMAGES` | Access photo library for image input | Android 13+ |
| `MANAGE_EXTERNAL_STORAGE` | Access model files in public directories | Android 11+ |
| `RECORD_AUDIO` | Voice input (speech-to-text) | All |
| `BLUETOOTH_CONNECT` | Bluetooth headset for voice input | Android 12+ |
| `USE_BIOMETRIC` | Face/fingerprint app lock | All |
| `POST_NOTIFICATIONS` | AI response notifications + system monitor | Android 13+ |
| `FOREGROUND_SERVICE` | Persistent system monitor notification | All |

All permissions are requested at runtime during the onboarding flow.

---

## Performance & Benchmarks

### Performance Tiers

The built-in benchmark suite grades your device into one of five tiers:

| Tier | Tokens/sec | Description |
|------|-----------|-------------|
| **Excellent** | 50+ t/s | Flagship devices with NPU (Snapdragon 8 Gen 3, Tensor G4) |
| **Very Good** | 30-50 t/s | High-end devices with Vulkan GPU (Snapdragon 8 Gen 2, Dimensity 9200) |
| **Good** | 20-30 t/s | Mid-range devices with OpenCL GPU (Snapdragon 7 series) |
| **Fair** | 10-20 t/s | Budget devices with software rendering |
| **Slow** | <10 t/s | Older devices, recommend smaller models |

### RAM Requirements

| Model | Min RAM | Recommended RAM |
|-------|---------|-----------------|
| TinyLlama 1.1B | 2GB | 4GB |
| Phi-3 Mini | 3GB | 6GB |
| Qwen2.5 1.5B | 3GB | 4GB |
| Llama 3 8B (Q4) | 6GB | 8GB+ |
| Mistral 7B (Q4) | 6GB | 8GB+ |

### Optimization Tips

1. **Enable GPU Acceleration** — Go to Settings → Performance → GPU Acceleration → Select Vulkan/OpenCL
2. **Use Low RAM Mode** — For devices with <4GB RAM, enable Low RAM Mode to reduce context window
3. **Terminate on Background** — Unload model when switching apps to free RAM
4. **Use Smaller Models** — TinyLlama and Phi-3 run on virtually any device
5. **Check Benchmarks** — Run the benchmark suite to find your device's performance tier

---

## Troubleshooting

### Common Issues

#### Model Won't Load
- **Check RAM**: Go to System screen to verify available memory
- **Try Low RAM Mode**: Settings → Performance → Low RAM Mode
- **Use Smaller Model**: Switch to TinyLlama or Phi-3
- **Clear Cache**: Settings → Performance → Clear Cache on Exit

#### GPU Acceleration Not Working
- **Verify Backend**: Settings → Performance → Check available GPU backends
- **Install GPU Drivers**: Ensure device has OpenCL/Vulkan support
- **Fallback to CPU**: Select "CPU" runtime in acceleration config

#### Voice Input Not Working
- **Check Permission**: Settings → Apps → BRAINY.AI → Permissions → Microphone
- **Test Microphone**: Try recording audio in another app
- **Reduce Noise**: Voice input works best in quiet environments

#### Hugging Face Token Invalid
- **Verify Token Format**: Must start with `hf_`
- **Check Token Expiry**: Regenerate token on huggingface.co/settings/tokens
- **Verify Permissions**: Token needs `Inference` permission enabled

#### App Crashes on Launch
- **Clear App Data**: Settings → Apps → BRAINY.AI → Storage → Clear Data
- **Reinstall**: Uninstall and reinstall the app
- **Check Logs**: `adb logcat | grep brainy`

### Debug Mode

```bash
# Enable verbose logging
adb shell setprop debug.llamadart.verbose true

# View LLM engine logs
adb logcat | grep -E "(llama|litert|llamadart)"

# Monitor memory usage
adb shell dumpsys meminfo com.deskdemon.copilot.grammer_llm

# Check native library loading
adb logcat | grep "Loading library"
```

---

## Roadmap

### Planned Features

- [ ] **Multi-Modal Support** — Image understanding with vision-language models
- [ ] **RAG (Retrieval Augmented Generation)** — Search personal documents for context
- [ ] **Fine-Tuning** — On-device LoRA fine-tuning for custom models
- [ ] **Model Quantization** — On-device GGUF quantization (Q8 → Q4 → Q2)
- [ ] **Plugin System** — Community plugins for tools and integrations
- [ ] **iOS Support** — Metal backend for iPhone/iPad
- [ ] **Desktop Support** — Windows, macOS, Linux with CUDA/Vulkan
- [ ] **Model Marketplace** — In-app model store with ratings and reviews
- [ ] **Collaborative Mode** — Share model configurations and personalities
- [ ] **Advanced Benchmarks** — MMLU, GSM8K, HumanEval scoring

---

## Contributing

Contributions are welcome! Here's how to get started:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Development Guidelines

- Follow the existing code style (run `flutter analyze` before submitting)
- Add comments for complex logic
- Update documentation for new features
- Test on multiple device tiers (low-end, mid-range, flagship)
- Ensure no performance regressions (run benchmarks)

---

## License

This project is licensed under the **MIT License**.

```
Copyright (c) 2024-2026 Deshan555

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

<div align="center">

**BRAINY.AI** — Your Intelligence. Strictly On-Device.

Made with ❤️ by [Deshan555](https://github.com/Deshan555)

</div>
