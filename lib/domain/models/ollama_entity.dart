import 'package:freezed_annotation/freezed_annotation.dart';

part 'ollama_entity.freezed.dart';

part 'ollama_entity.g.dart';

@freezed
class OllamaModelEntity with _$OllamaModelEntity {
  const factory OllamaModelEntity({
    required String name,
    required String model,
    @JsonKey(name: 'modified_at') required DateTime modifiedAt,
    required int size,
    required String digest,
    required OllamaDetailsModelEntity details,
  }) = _OllamaModelEntity;

  factory OllamaModelEntity.fromJson(Map<String, dynamic> json) =>
      _$OllamaModelEntityFromJson(json);
}

@freezed
class OllamaDetailsModelEntity with _$OllamaDetailsModelEntity {
  const factory OllamaDetailsModelEntity({
    @JsonKey(name: 'parent_model') required String parentModel,
    required String format,
    required String family,
    required List<String> families,
    @JsonKey(name: 'parameter_size') required String parameterSize,
    @JsonKey(name: 'quantization_level') required String quantizationLevel,
  }) = _OllamaDetailsModelEntity;

  factory OllamaDetailsModelEntity.fromJson(Map<String, dynamic> json) =>
      _$OllamaDetailsModelEntityFromJson(json);
}
