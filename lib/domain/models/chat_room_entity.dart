import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_entity.freezed.dart';

part 'chat_room_entity.g.dart';

@freezed
class ChatRoomEntity with _$ChatRoomEntity {
  const factory ChatRoomEntity({
    @Default(null) int? id,
    required String name,
    required String prompt,
    required String chatMode,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChatRoomEntity;

  factory ChatRoomEntity.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomEntityFromJson(json);
}
