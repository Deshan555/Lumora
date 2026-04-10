/// External storage paths for persistent model storage
/// 
/// Models are stored in:
/// - Android: /storage/emulated/0/Android/media/com.deskdemon.copilot.grammer_llm/GrammarAI/models/
///   This location persists after app uninstall on Android 10+
/// - Alternative: Public Documents folder for easier user access
class StoragePaths {
  StoragePaths._();

  // Primary storage: External app-specific directory
  // On Android 10+, this is in /storage/emulated/0/Android/media/<package>/
  // Models here MAY persist after uninstall (depends on Android version)
  static const String externalModelsDir = 'GrammarAI/models';
  
  // Alternative: Public Documents folder (guaranteed to persist)
  // User can access this from any file manager
  static const String publicDocumentsDir = 'Documents/GrammarAI/models';
  
  // Model file extension
  static const String modelExtension = '.gguf';
  
  // Supported model extensions
  static const List<String> supportedExtensions = ['.gguf', '.bin', '.litertlm', '.task'];
  
  // Database path (internal storage - deleted on uninstall)
  static const String databaseName = 'grammar_ai.db';
}
