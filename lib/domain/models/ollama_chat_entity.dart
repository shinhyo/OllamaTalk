import 'package:freezed_annotation/freezed_annotation.dart';

import 'role.dart';

part 'ollama_chat_entity.freezed.dart';

part 'ollama_chat_entity.g.dart';

@freezed
class OllamaChatEntity with _$OllamaChatEntity {
  const factory OllamaChatEntity({
    required String model,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required OllamaMessageEntity message,
    required bool done,
    @JsonKey(name: 'done_reason') String? doneReason,
    List<int>? context,
    @JsonKey(name: 'total_duration') int? totalDuration,
    @JsonKey(name: 'load_duration') int? loadDuration,
    @JsonKey(name: 'prompt_eval_count') int? promptEvalCount,
    @JsonKey(name: 'prompt_eval_duration') int? promptEvalDuration,
    @JsonKey(name: 'eval_count') int? evalCount,
    @JsonKey(name: 'eval_duration') int? evalDuration,
  }) = _OllamaChatEntity;

  factory OllamaChatEntity.fromJson(Map<String, dynamic> json) =>
      _$OllamaChatEntityFromJson(json);
}

@freezed
class OllamaMessageEntity with _$OllamaMessageEntity {
  const factory OllamaMessageEntity({
    required Role role,
    @Default('') String content,
  }) = _OllamaMessageEntity;

  factory OllamaMessageEntity.fromJson(Map<String, dynamic> json) =>
      _$OllamaMessageEntityFromJson(json);
}
