import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/model_repository.dart';
import '../../domain/repositories/correction_repository.dart';
import '../../data/datasources/llm_service.dart';
import '../../data/repositories/model_repository_impl.dart';
import '../../data/repositories/correction_repository_impl.dart';

import '../../data/datasources/hugging_face_service.dart';

/// Dio HTTP client for downloads
final dioProvider = Provider<Dio>((ref) {
  return Dio(BaseOptions(
    connectTimeout: const Duration(minutes: 1),
    receiveTimeout: const Duration(hours: 2),
    sendTimeout: const Duration(minutes: 5),
  ));
});

/// HF Service instance
final hfServiceProvider = Provider<HuggingFaceService>((ref) {
  final dio = ref.watch(dioProvider);
  return HuggingFaceService(dio);
});

/// LLM Service instance
final llmServiceProvider = Provider<LLMService>((ref) {
  return LLMService();
});

/// Model repository provider
final modelRepositoryProvider = Provider<IModelRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return ModelRepositoryImpl(dio);
});

/// Correction repository provider
final correctionRepositoryProvider = Provider<ICorrectionRepository>((ref) {
  final llmService = ref.watch(llmServiceProvider);
  final hfService = ref.watch(hfServiceProvider);
  return CorrectionRepositoryImpl(llmService, hfService, ref);
});
/// HF Profile Provider
final hfProfileProvider = FutureProvider<HFProfile?>((ref) async {
  final hfService = ref.watch(hfServiceProvider);
  final token = await hfService.getToken();
  if (token == null) return null;
  try {
    return await hfService.fetchUserProfile();
  } catch (_) {
    return null;
  }
});
