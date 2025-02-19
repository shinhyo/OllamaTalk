import '../../utils/logger.dart';
import '../models/ollama_generate_entity.dart';
import '../repository/ollama_repository.dart';

class ChatRoomNameUseCase {
  final OllamaRepository _ollamaRepository;

  ChatRoomNameUseCase(
    this._ollamaRepository,
  );

  Future<String> execute({
    required int chatRoomId,
    required String model,
    required List<String> lastMessages,
  }) async {
    logInfo('Generating chat room name for model: $model');

    final prompt = '''
You are a title generator AI. Generate a short title for this conversation.

CRITICAL RULES:
1. MUST be UNDER 20 characters (HIGHEST PRIORITY)
2. Generate title in EXACTLY SAME language as last message
3. Format rules:
   - Single line only
   - NO spaces at start/end
   - NO special chars
   - NO numbers
   - NO quotes
   - Basic letters only

CRITICAL: If title > 20 chars, shorten it
Return ONLY the final title.

Input conversation:
${lastMessages.join('\n')}
''';

    try {
      String accumulatedResponse = '';

      await for (final OllamaGenerateEntity generated
          in _ollamaRepository.generateResponse(
        model: model,
        prompt: prompt,
      )) {
        if (generated.response.isNotEmpty) {
          accumulatedResponse += generated.response;
        }
      }
      logInfo('Generated chat room name: ${accumulatedResponse.trim()}');
      return accumulatedResponse.trim();
    } catch (e, stackTrace) {
      logError('Failed to generate chat room name', stackTrace);
      throw Exception('Failed to generate chat room name: $e');
    }
  }
}
