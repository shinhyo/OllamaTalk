import 'dart:async';

import 'package:dio/dio.dart';

import '../../domain/models/ollama_chat_entity.dart';
import '../../domain/models/ollama_entity.dart';
import '../../domain/models/ollama_generate_entity.dart';
import '../../domain/repository/ollama_repository.dart';
import '../utils/stream_parser.dart';

class OllamaRepositoryImpl extends OllamaRepository {
  final Dio _dio;
  CancelToken? _cancelToken;

  OllamaRepositoryImpl(this._dio);

  @override
  Future<List<OllamaModelEntity>> getModels() async {
    try {
      final response = await _dio.get(
        '/api/tags',
      );
      final List<dynamic> data = response.data['models'] as List<dynamic>;
      return data
          .map(
            (json) => OllamaModelEntity.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch models: $e');
    }
  }

  @override
  void cancelCurrentChat() {
    if (_cancelToken == null) return;
    _cancelToken?.cancel('User cancelled the chat');
    _cancelToken = null;
  }

  @override
  Stream<OllamaGenerateEntity> generateResponse({
    required String model,
    required String prompt,
  }) async* {
    try {
      _cancelToken = CancelToken();
      final response = await _dio.post<ResponseBody>(
        '/api/generate',
        data: {
          'model': model,
          'prompt': prompt,
          'stream': true,
        },
        options: Options(responseType: ResponseType.stream),
        cancelToken: _cancelToken,
      );

      yield* parseJsonStream(
        response.data!.stream.cast<List<int>>(),
        OllamaGenerateEntity.fromJson,
      );
    } catch (e) {
      yield* Stream.error(e);
    } finally {
      _cancelToken = null;
    }
  }

  @override
  Stream<OllamaChatEntity> chat({
    required String model,
    required List<OllamaMessageEntity> messages,
  }) async* {
    try {
      _cancelToken = CancelToken();
      final response = await _dio.post<ResponseBody>(
        '/api/chat',
        data: {
          'model': model,
          'messages': messages.map((msg) => msg.toJson()).toList(),
          'stream': true,
        },
        options: Options(responseType: ResponseType.stream),
        cancelToken: _cancelToken,
      );

      yield* parseJsonStream(
        response.data!.stream.cast<List<int>>(),
        OllamaChatEntity.fromJson,
      );
    } catch (e) {
      yield* Stream.error(e);
    } finally {
      _cancelToken = null;
    }
  }
}
