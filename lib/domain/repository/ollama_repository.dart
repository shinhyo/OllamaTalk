import '../models/ollama_chat_entity.dart';
import '../models/ollama_entity.dart';
import '../models/ollama_generate_entity.dart';

abstract class OllamaRepository {
  Future<List<OllamaModelEntity>> getModels();

  void cancelCurrentChat();

  Stream<OllamaGenerateEntity> generateResponse({
    required String model,
    required String prompt,
  });

  Stream<OllamaChatEntity> chat({
    required String model,
    required List<OllamaMessageEntity> messages,
  });
}
