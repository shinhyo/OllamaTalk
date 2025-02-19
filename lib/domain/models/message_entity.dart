import 'package:freezed_annotation/freezed_annotation.dart';

import 'role.dart';

part 'message_entity.freezed.dart';

part 'message_entity.g.dart';

@freezed
class MessageEntity with _$MessageEntity {
  const factory MessageEntity({
    @Default(null) int? id,
    required int roomId,
    required Role role,
    required String content,
    String? model,
    int? totalDuration,
    int? loadDuration,
    int? promptEvalCount,
    int? promptEvalDuration,
    int? evalCount,
    int? evalDuration,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MessageEntity;

  factory MessageEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageEntityFromJson(json);
}
