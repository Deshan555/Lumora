import '../../domain/entities/model_info.dart';

/// All available models organized by category
class AvailableModels {
  static List<ModelInfo> getAll() {
    return [
      // === VISION & MULTIMODAL MODELS ===
      const ModelInfo(
        id: 'google/paligemma-3b-pt-224',
        name: 'PaliGemma 3B',
        description: 'Google\'s lightweight vision-language model. Excellent for image captioning and visual QA.',
        filename: '',
        sizeBytes: 0,
        category: ModelCategories.reasoning,
        recommendedRamGB: 8,
        isRemote: true,
        isVision: true,
        author: 'Google',
        tags: 'vision,multimodal,google',
      ),

      // === TEXT & WRITING MODELS ===
      ModelInfo(
        id: 'phi-3-mini-4k-instruct',
        name: 'Phi-3 Mini 4K Instruct',
        description: 'Best overall text model. Great for general questions, writing, and analysis.',
        filename: 'phi-3-mini-4k-instruct-q4_k_m.gguf',
        sizeBytes: 2400000000, // 2.4 GB
        downloadUrl: 'https://huggingface.co/bartowski/Phi-3-mini-4k-instruct-GGUF/resolve/main/Phi-3-mini-4k-instruct-Q4_K_M.gguf',
        category: ModelCategories.text,
        recommendedRamGB: 4,
        tags: 'general,writing,questions,analysis',
        contextWindow: 4096,
      ),
      ModelInfo(
        id: 'qwen2-5-1-5b-instruct',
        name: 'Qwen2.5 1.5B Instruct',
        description: 'Fast and efficient. Good for everyday tasks on low-end devices.',
        filename: 'qwen2-5-1-5b-instruct-q4_k_m.gguf',
        sizeBytes: 1000000000, // 1.0 GB
        downloadUrl: 'https://huggingface.co/Qwen/Qwen2.5-1.5B-Instruct-GGUF/resolve/main/qwen2.5-1.5b-instruct-q4_k_m.gguf',
        category: ModelCategories.text,
        recommendedRamGB: 3,
        tags: 'fast,lightweight,general',
        contextWindow: 32768,
      ),
      ModelInfo(
        id: 'gemma-2-2b-it',
        name: 'Gemma 2 2B IT',
        description: 'Google\'s model. Excellent for creative writing and explanations.',
        filename: 'gemma-2-2b-it-q4_k_m.gguf',
        sizeBytes: 1600000000, // 1.6 GB
        downloadUrl: 'https://huggingface.co/bartowski/gemma-2-2b-it-GGUF/resolve/main/gemma-2-2b-it-Q4_K_M.gguf',
        category: ModelCategories.text,
        recommendedRamGB: 4,
        tags: 'creative,writing,google',
        contextWindow: 8192,
      ),
      ModelInfo(
        id: 'tinyllama-1-1b-chat',
        name: 'TinyLlama 1.1B Chat',
        description: 'Ultra-fast. Best for low-end devices. Good for simple tasks.',
        filename: 'tinyllama-1-1b-chat-q4_k_m.gguf',
        sizeBytes: 650000000, // 650 MB
        downloadUrl: 'https://huggingface.co/TheBloke/TinyLlama-1.1B-Chat-v1.0-GGUF/resolve/main/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf',
        category: ModelCategories.text,
        recommendedRamGB: 2,
        tags: 'fast,lightweight,simple',
        contextWindow: 2048,
      ),
      
      // === CODE & PROGRAMMING MODELS ===
      ModelInfo(
        id: 'qwen2-5-coder-1-5b',
        name: 'Qwen2.5 Coder 1.5B',
        description: 'Specialized for code. Supports Python, JavaScript, Java, C++, and more.',
        filename: 'qwen2-5-coder-1-5b-q4_k_m.gguf',
        sizeBytes: 1100000000, // 1.1 GB
        downloadUrl: 'https://huggingface.co/Qwen/Qwen2.5-Coder-1.5B-Instruct-GGUF/resolve/main/qwen2.5-coder-1.5b-instruct-q4_k_m.gguf',
        category: ModelCategories.code,
        recommendedRamGB: 3,
        tags: 'code,programming,python,javascript',
        contextWindow: 32768,
      ),
      ModelInfo(
        id: 'starcoder2-3b',
        name: 'StarCoder2 3B',
        description: 'Excellent code completion and generation. 80+ programming languages.',
        filename: 'starcoder2-3b-q4_k_m.gguf',
        sizeBytes: 1900000000, // 1.9 GB
        downloadUrl: 'https://huggingface.co/bigcode/starcoder2-3b-GGUF/resolve/main/starcoder2-3b-q4_k_m.gguf',
        category: ModelCategories.code,
        recommendedRamGB: 4,
        tags: 'code,completion,multilanguage',
        contextWindow: 4096,
      ),
      ModelInfo(
        id: 'codeqwen-1-5-7b-chat',
        name: 'CodeQwen 1.5 7B Chat',
        description: 'Advanced code understanding and generation. Best for complex coding tasks.',
        filename: 'codeqwen-1-5-7b-chat-q4_k_m.gguf',
        sizeBytes: 4400000000, // 4.4 GB
        downloadUrl: 'https://huggingface.co/Qwen/CodeQwen1.5-7B-Chat-GGUF/resolve/main/codeqwen1.5-7b-chat-q4_k_m.gguf',
        category: ModelCategories.code,
        recommendedRamGB: 6,
        tags: 'code,advanced,understanding',
        contextWindow: 8192,
      ),
      
      // === MATH & SCIENCE MODELS ===
      ModelInfo(
        id: 'qwen2-5-math-1-5b',
        name: 'Qwen2.5 Math 1.5B',
        description: 'Specialized for mathematics. Solves equations, proofs, and calculations.',
        filename: 'qwen2-5-math-1-5b-q4_k_m.gguf',
        sizeBytes: 1100000000, // 1.1 GB
        downloadUrl: 'https://huggingface.co/Qwen/Qwen2.5-Math-1.5B-Instruct-GGUF/resolve/main/qwen2.5-math-1.5b-instruct-q4_k_m.gguf',
        category: ModelCategories.math,
        recommendedRamGB: 3,
        tags: 'math,science,calculations',
        contextWindow: 32768,
      ),
      ModelInfo(
        id: 'wizardmath-7b',
        name: 'WizardMath 7B',
        description: 'Advanced mathematical reasoning. Great for complex problems.',
        filename: 'wizardmath-7b-q4_k_m.gguf',
        sizeBytes: 4400000000, // 4.4 GB
        downloadUrl: 'https://huggingface.co/TheBloke/WizardMath-7B-V1.1-GGUF/resolve/main/wizardmath-7b-v1.1.Q4_K_M.gguf',
        category: ModelCategories.math,
        recommendedRamGB: 6,
        tags: 'math,advanced,reasoning',
        contextWindow: 4096,
      ),
      
      // === CREATIVE & ART MODELS ===
      ModelInfo(
        id: 'mistral-7b-instruct',
        name: 'Mistral 7B Instruct',
        description: 'Creative writing powerhouse. Great for stories, poems, and creative content.',
        filename: 'mistral-7b-instruct-q4_k_m.gguf',
        sizeBytes: 4400000000, // 4.4 GB
        downloadUrl: 'https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF/resolve/main/mistral-7b-instruct-v0.2.Q4_K_M.gguf',
        category: ModelCategories.creative,
        recommendedRamGB: 6,
        tags: 'creative,stories,poetry,writing',
        contextWindow: 8192,
      ),
      ModelInfo(
        id: 'openchat-3-5-7b',
        name: 'OpenChat 3.5 7B',
        description: 'Conversational AI. Natural dialogue and roleplay.',
        filename: 'openchat-3-5-7b-q4_k_m.gguf',
        sizeBytes: 4400000000, // 4.4 GB
        downloadUrl: 'https://huggingface.co/TheBloke/OpenChat-3.5-0106-GGUF/resolve/main/openchat-3.5-0106.Q4_K_M.gguf',
        category: ModelCategories.creative,
        recommendedRamGB: 6,
        tags: 'chat,roleplay,conversational',
        contextWindow: 8192,
      ),
      
      // === TRANSLATION MODELS ===
      ModelInfo(
        id: 'madlad400-3b',
        name: 'MADLAD400 3B',
        description: 'Multilingual translation. Supports 400+ languages.',
        filename: 'madlad400-3b-q4_k_m.gguf',
        sizeBytes: 2000000000, // 2.0 GB
        downloadUrl: 'https://huggingface.co/google/madlad400-3b-GGUF/resolve/main/madlad400-3b-q4_k_m.gguf',
        category: ModelCategories.translation,
        recommendedRamGB: 4,
        tags: 'translation,multilingual,languages',
        contextWindow: 4096,
      ),
      ModelInfo(
        id: 'nllb-200-1-3b',
        name: 'NLLB-200 1.3B',
        description: 'Facebook\'s translation model. 200 languages supported.',
        filename: 'nllb-200-1-3b-q4_k_m.gguf',
        sizeBytes: 900000000, // 900 MB
        downloadUrl: 'https://huggingface.co/facebook/nllb-200-1.3B-GGUF/resolve/main/nllb-200-1.3b-q4_k_m.gguf',
        category: ModelCategories.translation,
        recommendedRamGB: 3,
        tags: 'translation,multilingual,facebook',
        contextWindow: 2048,
      ),
      
      // === REASONING & LOGIC MODELS ===
      ModelInfo(
        id: 'phi-3-mini-4k-instruct-logic',
        name: 'Phi-3 Mini 4K Instruct',
        description: 'Strong reasoning capabilities. Logic puzzles and analysis.',
        filename: 'phi-3-mini-4k-instruct-q4_k_m.gguf',
        sizeBytes: 2400000000, // 2.4 GB
        downloadUrl: 'https://huggingface.co/bartowski/Phi-3-mini-4k-instruct-GGUF/resolve/main/Phi-3-mini-4k-instruct-Q4_K_M.gguf',
        category: ModelCategories.reasoning,
        recommendedRamGB: 4,
        tags: 'reasoning,logic,analysis',
        contextWindow: 4096,
      ),
      ModelInfo(
        id: 'llama-3-8b-instruct',
        name: 'Llama 3 8B Instruct',
        description: 'Meta\'s latest. Excellent reasoning and general knowledge.',
        filename: 'llama-3-8b-instruct-q4_k_m.gguf',
        sizeBytes: 4900000000, // 4.9 GB
        downloadUrl: 'https://huggingface.co/meta-llama/Meta-Llama-3-8B-Instruct-GGUF/resolve/main/Meta-Llama-3-8B-Instruct-Q4_K_M.gguf',
        category: ModelCategories.reasoning,
        recommendedRamGB: 8,
        tags: 'reasoning,knowledge,meta',
        contextWindow: 8192,
      ),
    ];
  }

  /// Get models by category
  static List<ModelInfo> getByCategory(String category) {
    return getAll().where((m) => m.category == category).toList();
  }

  /// Get all unique categories
  static List<String> getCategories() {
    return [
      ModelCategories.text,
      ModelCategories.code,
      ModelCategories.math,
      ModelCategories.creative,
      ModelCategories.translation,
      ModelCategories.reasoning,
    ];
  }
}
