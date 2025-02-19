import 'package:drift/drift.dart';

import '../../../../../domain/models/chat_room_entity.dart';
import '../../drift.dart';
import 'auto_incrementing_primary_key.dart';

@DataClassName('ChatRoom')
class ChatRoomTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();

  TextColumn get chatMode => text()();

  TextColumn get prompt => text()();

  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

extension ChatRoomDataMapper on ChatRoom {
  ChatRoomEntity toDomain() {
    return ChatRoomEntity(
      id: id,
      name: name,
      prompt: prompt,
      chatMode: chatMode,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension ChatRoomDomainMapper on ChatRoomEntity {
  ChatRoomTableCompanion toData() {
    return ChatRoomTableCompanion.insert(
      name: name,
      chatMode: chatMode,
      prompt: prompt,
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
