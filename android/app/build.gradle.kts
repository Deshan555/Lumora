plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.deskdemon.copilot.grammer_llm"
    compileSdk = 35
    ndkVersion = "27.0.12077973" // LTS version compatible with llama.cpp

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.deskdemon.copilot.grammer_llm"
        // Android 10+ (API 29)
        minSdk = 29
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Enable large heap for LLM model loading
        multiDexEnabled = true
        
        // NDK configuration for llama.cpp
        ndk {
            abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            
            // Enable code shrinking and resource shrinking for release
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            // Keep debug builds unminified for debugging
            isMinifyEnabled = false
        }
    }
    
    // Configure for large heap support
    aaptOptions {
        noCompress += listOf("gguf", "bin") // Don't compress model files
    }
}

flutter {
    source = "../.."
}
