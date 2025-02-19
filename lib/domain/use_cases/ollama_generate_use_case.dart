import '../models/ollama_generate_entity.dart';
import '../repository/ollama_repository.dart';

class OllamaGenerateUseCase {
  final OllamaRepository _ollamaRepository;

  OllamaGenerateUseCase(
    this._ollamaRepository,
  );

  Stream<String> execute({
    required String model,
    required String prompt,
  }) async* {
    try {
      await for (final OllamaGenerateEntity generated
          in _ollamaRepository.generateResponse(
        model: model,
        prompt: prompt,
      )) {
        if (generated.response.isNotEmpty) {
          yield generated.response;
        }
      }
    } catch (e) {
      yield* Stream.error(e);
    }
  }
}
