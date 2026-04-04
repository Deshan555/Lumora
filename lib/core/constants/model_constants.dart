/// Model metadata constants
/// 
/// TODO: Replace placeholder URLs and checksums with actual HuggingFace links
class ModelConstants {
  ModelConstants._();

  // Model IDs
  static const String tinyLlamaId = 'tinyllama-1.1b-q4_k_m';
  static const String phi3MiniId = 'phi-3-mini-q4_k_m';
  static const String gemma2BId = 'gemma-2b-q4_k_m';

  // Model Display Names
  static const String tinyLlamaName = 'TinyLlama 1.1B';
  static const String phi3MiniName = 'Phi-3 Mini';
  static const String gemma2BName = 'Gemma 2B';

  // Model Descriptions
  static const String tinyLlamaDesc = 'Fastest, suitable for low-end devices';
  static const String phi3MiniDesc = 'Balanced speed and quality';
  static const String gemma2BDesc = 'Highest quality output';

  // Model Sizes (in bytes)
  static const int tinyLlamaSize = 600_000_000; // ~600 MB
  static const int phi3MiniSize = 1_300_000_000; // ~1.3 GB
  static const int gemma2BSize = 1_500_000_000; // ~1.5 GB

  // RAM Recommendations (in GB)
  static const int tinyLlamaRam = 4;
  static const int phi3MiniRam = 6;
  static const int gemma2BRam = 8;

  // Download URLs (GGUF format, Q4_K_M quantization)
  // TODO: Replace with actual HuggingFace URLs
  static const String tinyLlamaUrl = 'https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf';
  static const String phi3MiniUrl = 'https://huggingface.co/QuantFactory/Phi-3-mini-4k-instruct-GGUF/resolve/main/Phi-3-mini-4k-instruct.Q4_K_M.gguf';
  static const String gemma2BUrl = 'https://huggingface.co/bartowski/gemma-2-2b-it-GGUF/resolve/main/gemma-2-2b-it-Q4_K_M.gguf';

  // SHA-256 Checksums (for verification)
  // TODO: Replace with actual checksums after testing downloads
  static const String tinyLlamaChecksum = '';
  static const String phi3MiniChecksum = '';
  static const String gemma2BChecksum = '';

  // Model File Names
  static const String tinyLlamaFile = 'tinyllama-1.1b-chat-q4_k_m.gguf';
  static const String phi3MiniFile = 'phi-3-mini-q4_k_m.gguf';
  static const String gemma2BFile = 'gemma-2b-q4_k_m.gguf';
}
