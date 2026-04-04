# Add project specific ProGuard rules here.

# Keep llama.cpp native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep drift database classes
-keep class * extends io.requery.android.database.sqlite.SQLiteOpenHelper
-keep class drift.** { *; }
-keep class io.requery.** { *; }

# Keep Dio networking
-keep class dio.** { *; }
-dontwarn dio.**

# Keep Flutter platform channels
-keep class io.flutter.plugin.** { *; }

# Keep model files serialization
-keep class * implements java.io.Serializable

# Suppress warnings for native methods
-dontnote **.NativeMethod
-dontwarn **.NativeMethod

# Keep encryption for SHA-256 verification
-keep class javax.crypto.** { *; }
-keep class java.security.** { *; }
