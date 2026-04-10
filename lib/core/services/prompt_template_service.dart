
/// Service to provide specialized prompt templates for different model architectures.
class PromptTemplateService {
  /// Build a formatted prompt based on the model ID and architecture.
  static String buildPrompt({
    required String modelId,
    required String systemPrompt,
    required String userPrompt,
    String? conversationHistory,
  }) {
    final id = modelId.toLowerCase();

    // 1. Gemma 2 / Gemma
    if (id.contains('gemma')) {
      return _buildGemmaPrompt(systemPrompt, userPrompt, conversationHistory);
    }

    // 2. Llama 3 / Llama
    if (id.contains('llama-3')) {
      return _buildLlama3Prompt(systemPrompt, userPrompt, conversationHistory);
    }

    // 3. Phi-3
    if (id.contains('phi-3')) {
      return _buildPhi3Prompt(systemPrompt, userPrompt, conversationHistory);
    }

    // 4. Qwen / Qwen2
    if (id.contains('qwen')) {
      return _buildQwenPrompt(systemPrompt, userPrompt, conversationHistory);
    }

    // 5. Mistral / Mixtral
    if (id.contains('mistral') || id.contains('mixtral')) {
      return _buildMistralPrompt(systemPrompt, userPrompt, conversationHistory);
    }

    // Default: Simple format
    return 'System: $systemPrompt\n\n'
           '${conversationHistory != null ? "$conversationHistory\n\n" : ""}'
           'User: $userPrompt\n'
           'Assistant:';
  }

  static String _buildGemmaPrompt(String system, String user, String? history) {
    // Gemma 2 Instruct template:
    // <start_of_turn>user
    // {system_prompt}\n\n{user_prompt}<end_of_turn>
    // <start_of_turn>model
    
    final sb = StringBuffer();
    if (history != null && history.isNotEmpty) {
      // If we have history, we assume it's already in a somewhat readable format or we'd need more complex parsing.
      // For simplicity, we'll wrap the current turn.
      sb.writeln('<start_of_turn>user');
      sb.writeln('Context: $system');
      sb.writeln(history);
      sb.writeln(user);
      sb.write('<end_of_turn>\n<start_of_turn>model\n');
    } else {
      sb.writeln('<start_of_turn>user');
      sb.writeln('$system\n\n$user');
      sb.write('<end_of_turn>\n<start_of_turn>model\n');
    }
    return sb.toString();
  }

  static String _buildLlama3Prompt(String system, String user, String? history) {
    // Llama 3 template:
    // <|begin_of_text|><|start_header_id|>system<|end_header_id|>
    // {system}<|eot_id|><|start_header_id|>user<|end_header_id|>
    // {user}<|eot_id|><|start_header_id|>assistant<|end_header_id|>
    
    final sb = StringBuffer('<|begin_of_text|><|start_header_id|>system<|end_header_id|>\n\n');
    sb.writeln(system);
    sb.write('<|eot_id|>');
    
    if (history != null && history.isNotEmpty) {
      // This is a naive history injection. Ideally, we'd have a List<Message> but we skip complex refactors for now.
      sb.writeln('<|start_header_id|>user<|end_header_id|>\n\nHistory of previous interactions:\n$history\n\n$user<|eot_id|>');
    } else {
      sb.writeln('<|start_header_id|>user<|end_header_id|>\n\n$user<|eot_id|>');
    }
    
    sb.write('<|start_header_id|>assistant<|end_header_id|>\n\n');
    return sb.toString();
  }

  static String _buildPhi3Prompt(String system, String user, String? history) {
    // Phi-3 template:
    // <|system|>\n{system}<|end|>\n<|user|>\n{user}<|end|>\n<|assistant|>\n
    final sb = StringBuffer('<|system|>\n$system<|end|>\n');
    if (history != null && history.isNotEmpty) {
       sb.writeln('<|user|>\nPrevious Context:\n$history\n\nCurrent Question: $user<|end|>');
    } else {
       sb.writeln('<|user|>\n$user<|end|>');
    }
    sb.write('<|assistant|>\n');
    return sb.toString();
  }

  static String _buildQwenPrompt(String system, String user, String? history) {
    // ChatML (Qwen) template:
    // <|im_start|>system\n{system}<|im_end|>\n<|im_start|>user\n{user}<|im_end|>\n<|im_start|>assistant\n
    final sb = StringBuffer('<|im_start|>system\n$system<|im_end|>\n');
    if (history != null && history.isNotEmpty) {
       sb.writeln('<|im_start|>user\n$history\n\n$user<|im_end|>\n');
    } else {
       sb.writeln('<|im_start|>user\n$user<|im_end|>\n');
    }
    sb.write('<|im_start|>assistant\n');
    return sb.toString();
  }

  static String _buildMistralPrompt(String system, String user, String? history) {
    // Mistral format: [INST] {system}\n\n{user} [/INST]
    if (history != null && history.isNotEmpty) {
      return '[INST] $system\n\n$history\n\n$user [/INST]';
    }
    return '[INST] $system\n\n$user [/INST]';
  }
}
