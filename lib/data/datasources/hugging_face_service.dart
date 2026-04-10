import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/model_catalog.dart';
import '../../domain/entities/model_info.dart';

/// Hugging Face User Profile Data Model
class HFProfile {
  final String username;
  final String? fullname;
  final String? email;
  final String? avatarUrl;
  final String plan; // free, pro, enterprise
  final bool emailVerified;

  HFProfile({
    required this.username,
    this.fullname,
    this.email,
    this.avatarUrl,
    required this.plan,
    this.emailVerified = false,
  });

  factory HFProfile.fromJson(Map<String, dynamic> json) {
    String? avatar = json['avatarUrl'];
    if (avatar != null && avatar.startsWith('/')) {
      avatar = 'https://huggingface.co$avatar';
    }

    return HFProfile(
      username: json['name'] ?? 'Unknown',
      fullname: json['fullname'],
      email: json['email'],
      avatarUrl: avatar,
      plan: json['plan'] ?? 'free',
      emailVerified: json['emailVerified'] ?? false,
    );
  }

  bool get isPro => plan.toLowerCase() == 'pro' || plan.toLowerCase() == 'enterprise';
}

/// Service for Hugging Face Hub and Inference API
class HuggingFaceService {
  final Dio _dio;
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'hf_access_token';

  HuggingFaceService(this._dio);

  /// Save access token securely
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Get saved access token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Delete saved access token
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Check if a string looks like a valid Hugging Face token
  bool isValidToken(String token) {
    final trimmed = token.trim();
    // HF tokens typically start with hf_ and are about 37+ chars
    return trimmed.startsWith('hf_') && trimmed.length >= 30;
  }

  /// Fetch user profile from Hugging Face
  Future<HFProfile> fetchUserProfile() async {
    final token = await getToken();
    if (token == null) throw Exception('No access token found.');

    try {
      final response = await _dio.get(
        'https://huggingface.co/api/whoami',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        return HFProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          throw Exception('Token Permission Error: Please ensure your Access Token has "Read" Hub permissions enabled on Hugging Face.');
        }
      }
      throw await _extractError(e);
    }
  }

  /// Search models on Hugging Face Hub
  Future<List<ModelInfo>> searchModels({
    required String query,
    String? task,
    int limit = 20,
  }) async {
    final filters = <String>[];
    if (task != null) filters.add('task:$task');
    // We prefer GGUF for text if possible, but for Inference API any model works.
    // However, the user request says "use it for all Hugging Face features", 
    // implying Inference API.
    
    final token = await getToken();
    
    try {
      final response = await _dio.get(
        'https://huggingface.co/api/models',
        queryParameters: {
          'search': query,
          'filter': task,
          'sort': 'downloads',
          'direction': -1,
          'limit': limit,
          'full': true,
        },
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) {
          final modelId = json['modelId'] ?? json['id'];
          final author = json['author'];
          final likes = json['likes'] ?? 0;
          final pipelineTag = json['pipeline_tag'];
          
          return ModelInfo(
            id: modelId,
            name: modelId.split('/').last,
            description: 'HF Model by $author',
            filename: '', // Not used for remote
            sizeBytes: 0, // Often not available directly in this list
            category: _mapPipelineToCategory(pipelineTag),
            recommendedRamGB: 0,
            isRemote: true,
            author: author,
            likes: likes,
            hfTaskId: pipelineTag,
            tags: json['tags']?.join(',') ?? '',
          );
        }).toList();
      }
      return [];
    } catch (e) {
      print('HF Search Error: $e');
      return [];
    }
  }

  /// Generate Image using Hugging Face Inference API
  Future<Uint8List> generateImage(String modelId, String prompt) async {
    final token = await getToken();
    if (token == null) throw Exception('Hugging Face token not found. Please add it in settings.');

    try {
      final response = await _dio.post(
        'https://router.huggingface.co/hf-inference/models/$modelId',
        data: {'inputs': prompt},
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.data == null) throw Exception('No image data received from Hugging Face.');
      return Uint8List.fromList(response.data);
    } catch (e) {
      throw await _extractError(
        e, 
        modelId: modelId, 
        url: 'https://router.huggingface.co/hf-inference/models/$modelId'
      );
    }
  }

  /// Run text inference
  Stream<String> textInferenceStream(String modelId, String prompt, {List<String>? imagePaths, bool isVision = false}) async* {
    final token = await getToken();
    if (token == null) throw Exception('Hugging Face token not found. Please add it in settings.');

    try {
      final bool hasImages = imagePaths != null && imagePaths.isNotEmpty;
      
      // If images are provided but model is not vision-capable, warn/error or ignore
      if (hasImages && !isVision) {
        // We throw a descriptive error so the UI can handle it
        throw Exception('IncompatibleModelException: The selected model "$modelId" is a Text-only model and cannot process image attachments. Please use a Multimodal/Vision model like PaliGemma for images.');
      }

      final String url = (hasImages && isVision)
          ? 'https://router.huggingface.co/hf-inference/models/$modelId/v1/chat/completions'
          : 'https://router.huggingface.co/hf-inference/models/$modelId';

      final Object dataPayload = (hasImages && isVision)
          ? {
              'model': modelId,
              'messages': [
                {
                  'role': 'user',
                  'content': [
                    {'type': 'text', 'text': prompt},
                    for (final p in imagePaths)
                      if (['jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp'].contains(p.split('.').last.toLowerCase()))
                        {
                          'type': 'image_url',
                          'image_url': {
                            'url': 'data:image/jpeg;base64,${base64Encode(File(p).readAsBytesSync())}'
                          }
                        }
                  ]
                }
              ],
              'stream': true,
              'max_tokens': 512,
            }
          : {
              'inputs': prompt,
              'stream': true,
              'parameters': {
                'max_new_tokens': 512,
                'return_full_text': false,
                'stop': ["User:", "<|im_end|>", "<|endoftext|>", "<start_of_turn>", "<|eot_id|>"],
              }
            };

      final response = await _dio.post(
        url,
        data: dataPayload,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          responseType: ResponseType.stream,
        ),
      );

      // Use Utf8Decoder and LineSplitter for robust SSE parsing
      final stream = response.data.stream
          .cast<List<int>>()
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in stream) {
        if (line.startsWith('data:')) {
          final jsonStr = line.substring(5).trim();
          if (jsonStr == '[DONE]') break;
          
          try {
            final json = jsonDecode(jsonStr);
            if (json['error'] != null) {
              throw Exception(json['error']);
            }

            // Extract token based on different formats (standard HF or OpenAI-compatible)
            String? tokenText;
            
            // Format A: {"token": {"text": "..."}}
            if (json['token'] != null && json['token']['text'] != null) {
              tokenText = json['token']['text'];
            } 
            // Format B: {"choices": [{"delta": {"content": "..."}}]} (Chat Completions)
            else if (json['choices'] != null && 
                     json['choices'] is List && 
                     json['choices'].isNotEmpty) {
              final choice = json['choices'][0];
              tokenText = choice['delta']?['content'] ?? choice['text'];
            }
            // Format C: {"generated_text": "..."} (Single result)
            else if (json['generated_text'] != null) {
              tokenText = json['generated_text'];
            }

            if (tokenText != null && tokenText.isNotEmpty) {
              // Standard HF text-generation often appends " Assistant:" to prompt, 
              // we don't want to yield the stopping tokens.
              if (!tokenText.contains('User:') && !tokenText.contains('<|im_end|>')) {
                yield tokenText;
              }
            }
          } catch (e) {
            if (e is Exception) rethrow;
          }
        }
      }
    } catch (e) {
      throw await _extractError(
        e, 
        modelId: modelId, 
        url: 'https://router.huggingface.co/hf-inference/models/$modelId',
      );
    }
  }

  Future<Exception> _extractError(dynamic e, {String? modelId, String? url}) async {
    if (e is DioException) {
      final response = e.response;
      final diagnosticInfo = (modelId != null && url != null) 
          ? '\n\nModel ID: $modelId\nEndpoint: $url'
          : '';

      if (response != null) {
        try {
          Map<String, dynamic>? data;
          if (response.data is Map) {
            data = response.data;
          } else if (response.data is ResponseBody) {
            final stream = (response.data as ResponseBody).stream;
            final bytes = await stream.toList();
            final flatBytes = bytes.expand((x) => x).toList();
            final body = utf8.decode(flatBytes);
            data = jsonDecode(body);
          } else if (response.data is List<int>) {
             data = jsonDecode(utf8.decode(response.data));
          }

          if (data != null && data['error'] != null) {
            final errorMsg = data['error'].toString();
            
            // Handle specifically for non-inference models
            if (response.statusCode == 404 || errorMsg.contains('not found')) {
              return Exception(
                'Hugging Face Error: Model not found or Inference API is disabled for this model.$diagnosticInfo\n\n'
                'Tip: Please check the model page on Hugging Face to see if "Inference API (Serverless)" is enabled.'
              );
            }

            if (response.statusCode == 503 && data['estimated_time'] != null) {
              return Exception('Model is currently loading on Hugging Face servers.\n'
                  'Estimated completion in ${data['estimated_time']} seconds.\n'
                  'Please wait and try again.$diagnosticInfo');
            }
            return Exception('Hugging Face API: $errorMsg$diagnosticInfo');
          }
        } catch (_) {}
        
        if (response.statusCode == 404) {
           return Exception(
                'Hugging Face Error (404): Model not found or Inference API is disabled.$diagnosticInfo\n\n'
                'Tip: Verify the model ID and ensure it supports serverless inference.'
              );
        }
        if (response.statusCode == 401) return Exception('Invalid or missing Hugging Face Access Token.$diagnosticInfo');
        if (response.statusCode == 429) return Exception('Hugging Face rate limit reached. Please wait.$diagnosticInfo');
        return Exception('Hugging Face API Error (${response.statusCode}): ${e.message}$diagnosticInfo');
      }
      if (e.type == DioExceptionType.connectionTimeout) return Exception('Connection timeout. Please check your internet.$diagnosticInfo');
      return Exception('Network Error: ${e.message}$diagnosticInfo');
    }
    return Exception(e.toString());
  }

  String _mapPipelineToCategory(String? pipeline) {
    if (pipeline == null) return ModelCategories.text;
    if (pipeline.contains('text-generation')) return ModelCategories.text;
    if (pipeline.contains('text-to-image')) return ModelCategories.creative;
    if (pipeline.contains('translation')) return ModelCategories.translation;
    if (pipeline.contains('question-answering')) return ModelCategories.reasoning;
    return ModelCategories.text;
  }
}
