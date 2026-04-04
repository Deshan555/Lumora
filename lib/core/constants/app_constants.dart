/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'Grammar AI';
  static const String appVersion = '1.0.0';
  
  // System Prompt (EXACTLY as specified)
  static const String systemPrompt = '''You are a professional English grammar correction AI.

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
- Change 2: ...''';

  // Model Storage
  static const String modelsDirectoryName = 'models';
  
  // LLM Configuration
  static const int maxContextSize = 4096;
  static const int defaultContextSize = 2048;
  static const double defaultTemperature = 0.3;
  static const int maxTokens = 1024;
  
  // Writing Styles
  static const List<String> writingStyles = [
    'Formal',
    'Casual',
    'Academic',
    'Professional',
    'Creative',
  ];
  
  // Download Configuration
  static const int downloadTimeoutSeconds = 3600; // 1 hour for large models
  static const int maxRetries = 3;
  
  // History
  static const int defaultHistoryLimit = 100;
  
  // Asset Paths
  static const String poppinsFont = 'Poppins';
  static const String dmSansFont = 'DMSans';
}
