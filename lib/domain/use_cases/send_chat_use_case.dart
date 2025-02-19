import 'dart:math';

import '../../utils/logger.dart';
import '../models/message_entity.dart';
import '../models/ollama_chat_entity.dart';
import '../models/role.dart';
import '../repository/database_repository.dart';
import '../repository/ollama_repository.dart';

class OllamaChatUseCase {
  final OllamaRepository _ollamaRepository;
  final DatabaseRepository _databaseRepository;

  static const int maxMessages = 15;

  OllamaChatUseCase(
    this._ollamaRepository,
    this._databaseRepository,
  );

  Stream<String> execute({
    required int roomId,
    required String model,
    required String prompt,
    required List<MessageEntity> messages,
  }) async* {
    final buffer = StringBuffer();

    try {
      final userMessage = messages[1];
      await _databaseRepository.createMessage(roomId, userMessage);

      final ollamaMessages = _prepareOllamaMessages(messages, prompt);
      await for (final OllamaChatEntity chat in _ollamaRepository.chat(
        model: model,
        messages: ollamaMessages,
      )) {
        final content = chat.message.content;
        buffer.write(content);
        yield content;

        if (chat.done) {
          await _databaseRepository.createMessage(
            roomId,
            MessageEntity(
              roomId: roomId,
              role: Role.assistant,
              content: buffer.toString().trim(),
              model: model,
              totalDuration: chat.totalDuration,
              loadDuration: chat.loadDuration,
              promptEvalCount: chat.promptEvalCount,
              promptEvalDuration: chat.promptEvalDuration,
              evalCount: chat.evalCount,
              evalDuration: chat.evalDuration,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        }
      }

      logInfo('Chat completion successful');
    } catch (e, stackTrace) {
      logError('Chat error: $e', stackTrace);
      yield* Stream.error(e);
    } finally {
      buffer.clear();
    }
  }

  List<OllamaMessageEntity> _prepareOllamaMessages(
    List<MessageEntity> messages,
    String prompt,
  ) {
    final startIdx = max(0, messages.length - (maxMessages + 1));
    final endIdx = max(0, messages.length - 1);

    final ollamaMessages = messages.reversed
        .map(
          (message) => OllamaMessageEntity(
            role: message.role,
            content: message.content,
          ),
        )
        .toList()
        .sublist(startIdx, endIdx);

    // system prompt
    ollamaMessages.insert(
      0,
      OllamaMessageEntity(role: Role.system, content: prompt),
    );
    return ollamaMessages;
  }
}
