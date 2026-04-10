/// Simple response handler for AI chat
/// Just returns the raw response as-is
class ResponseParser {
  ResponseParser._();

  /// Parse LLM response - just return the raw text
  static String parseResponse(String response) {
    // Clean up any leading/trailing whitespace
    return response.trim();
  }
}

/// Chat message data class
class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
  });
}
