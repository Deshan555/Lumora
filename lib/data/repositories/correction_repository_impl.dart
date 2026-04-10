import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/state_providers.dart';
import '../../domain/repositories/correction_repository.dart';
import '../datasources/llm_service.dart';
import '../datasources/hugging_face_service.dart';
import '../../core/services/prompt_template_service.dart';
import '../../domain/entities/model_info.dart';

/// Implementation of AI chat repository
class CorrectionRepositoryImpl implements ICorrectionRepository {
  final LLMService _llmService;
  final HuggingFaceService _hfService;
  final Ref _ref;
  bool _isInitialized = false;

  CorrectionRepositoryImpl(this._llmService, this._hfService, this._ref);

  @override
  Future<void> initializeModel(String modelPath) async {
    final activeModel = _ref.read(activeModelProvider);
    final runtime = activeModel?.runtime ?? LlmRuntime.llamaCpp;
    await _llmService.initializeModel(modelPath, runtime: runtime);
    _isInitialized = true;
  }

  @override
  Future<void> unloadModel() async {
    await _llmService.unloadModel();
    _isInitialized = false;
  }

  @override
  bool isModelLoaded() {
    final activeModel = _ref.read(activeModelProvider);
    if (activeModel != null && activeModel.isRemote) return true;
    return _isInitialized && _llmService.isModelLoaded;
  }

  @override
  Stream<String> correctTextStream(
    String message,
    String context,
    {List<String>? imagePaths}
  ) async* {
    final activeModel = _ref.read(activeModelProvider);
    final settings = _ref.read(settingsProvider);
    
    if (activeModel != null && activeModel.isRemote) {
      final prompt = PromptTemplateService.buildPrompt(
        modelId: activeModel.id,
        systemPrompt: settings.personality.buildSystemPrompt(),
        userPrompt: message,
        conversationHistory: context,
      );
      await for (final token in _hfService.textInferenceStream(activeModel.id, prompt, imagePaths: imagePaths, isVision: activeModel.isVision)) {
        yield token;
      }
      return;
    }

    if (!isModelLoaded()) {
      throw Exception('Model not loaded. Please download and load a model first.');
    }

    final prompt = PromptTemplateService.buildPrompt(
      modelId: activeModel?.id ?? 'local',
      systemPrompt: settings.personality.buildSystemPrompt(),
      userPrompt: message,
      conversationHistory: context,
    );
    
    await for (final token in _llmService.generateStream(
      prompt: prompt,
      maxTokens: settings.modelMaxTokens,
      temperature: settings.modelTemperature,
      topP: settings.modelTopP,
      topK: settings.modelTopK,
    )) {
      yield token;
    }
  }

  @override
  Future<String> correctText(
    String message,
    String context,
    {List<String>? imagePaths}
  ) async {
    final activeModel = _ref.read(activeModelProvider);
    final settings = _ref.read(settingsProvider);

    if (activeModel != null && activeModel.isRemote) {
      final prompt = PromptTemplateService.buildPrompt(
        modelId: activeModel.id,
        systemPrompt: settings.personality.buildSystemPrompt(),
        userPrompt: message,
        conversationHistory: context,
      );
      String fullText = '';
      await for (final token in _hfService.textInferenceStream(activeModel.id, prompt, imagePaths: imagePaths, isVision: activeModel.isVision)) {
        fullText += token;
      }
      return fullText.trim();
    }

    if (!isModelLoaded()) {
      throw Exception('Model not loaded. Please download and load a model first.');
    }

    final prompt = PromptTemplateService.buildPrompt(
      modelId: activeModel?.id ?? 'local',
      systemPrompt: settings.personality.buildSystemPrompt(),
      userPrompt: message,
      conversationHistory: context,
    );
    
    final response = await _llmService.generate(
      prompt: prompt,
      maxTokens: settings.modelMaxTokens,
      temperature: settings.modelTemperature,
      topP: settings.modelTopP,
      topK: settings.modelTopK,
    );

    return response.trim();
  }

  @override
  Future<List<int>> generateImage(String modelId, String prompt) async {
    return await _hfService.generateImage(modelId, prompt);
  }

  @override
  Future<void> cancelGeneration() async {
    final activeModel = _ref.read(activeModelProvider);
    if (activeModel != null && activeModel.isRemote) {
      // HF Inference API cancel is typically handled by closing the connection/aborting the request
      // dio handle this if we pass a cancel token.
      return; 
    }
    await _llmService.cancelGeneration();
  }

  // _buildPrompt removed in favor of PromptTemplateService
}
