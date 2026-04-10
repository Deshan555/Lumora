/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Brainy.Ai';
  static const String appVersion = '1.0.0';
  
  // System Prompt - General AI Assistant
  static const String systemPrompt = '''You are a helpful, knowledgeable, and friendly AI assistant.

Your role:
- Answer questions clearly and accurately
- Provide helpful explanations when needed
- Be concise but thorough
- Maintain a professional and friendly tone
- Admit when you don't know something
- Avoid making up information

Respond naturally in a conversational manner.''';

  // Model Storage
  static const String modelsDirectoryName = 'models';
  
  // LLM Configuration
  static const int maxContextSize = 4096;
  static const int defaultContextSize = 2048;
  static const double defaultTemperature = 0.7; // Higher for creativity
  static const int maxTokens = 2048; // More tokens for general responses
  
  // History
  static const int defaultHistoryLimit = 100;
  
  // Asset Paths
  static const String poppinsFont = 'Poppins';
  static const String dmSansFont = 'DMSans';
}
