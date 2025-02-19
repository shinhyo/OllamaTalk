import 'package:freezed_annotation/freezed_annotation.dart';

part 'ollama_generate_entity.freezed.dart';

part 'ollama_generate_entity.g.dart';

@freezed
class OllamaGenerateEntity with _$OllamaGenerateEntity {
  const factory OllamaGenerateEntity({
    required String model,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required String response,
    required bool done,
    @JsonKey(name: 'done_reason') String? doneReason,
    List<int>? context,
    @JsonKey(name: 'total_duration') int? totalDuration,
    @JsonKey(name: 'load_duration') int? loadDuration,
    @JsonKey(name: 'prompt_eval_count') int? promptEvalCount,
    @JsonKey(name: 'prompt_eval_duration') int? promptEvalDuration,
    @JsonKey(name: 'eval_count') int? evalCount,
    @JsonKey(name: 'eval_duration') int? evalDuration,
  }) = _OllamaGenerateEntity;

  factory OllamaGenerateEntity.fromJson(Map<String, dynamic> json) =>
      _$OllamaGenerateEntityFromJson(json);
}
