import 'package:drift/drift.dart';

import '../../../../../domain/models/message_entity.dart';
import '../../../../../domain/models/role.dart';
import '../../drift.dart';
import 'auto_incrementing_primary_key.dart';
import 'chat_room_table.dart';

@DataClassName('Message')
class MessageTable extends Table with AutoIncrementingPrimaryKey {
  IntColumn get roomId => integer().named('room_id').references(
        ChatRoomTable,
        #id,
        onDelete: KeyAction.cascade,
        onUpdate: KeyAction.cascade,
      )();

  TextColumn get role => textEnum<Role>()();

  TextColumn get content => text().nullable()();

  TextColumn get model => text().nullable()();

  IntColumn get totalDuration => integer().nullable()();

  IntColumn get loadDuration => integer().nullable()();

  IntColumn get promptEvalCount => integer().nullable()();

  IntColumn get promptEvalDuration => integer().nullable()();

  IntColumn get evalCount => integer().nullable()();

  IntColumn get evalDuration => integer().nullable()();

  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();
}

extension MessageDataMapper on Message {
  MessageEntity toDomain() {
    return MessageEntity(
      id: id,
      roomId: roomId,
      role: role,
      content: content ?? '',
      model: model,
      totalDuration: totalDuration,
      loadDuration: loadDuration,
      promptEvalCount: promptEvalCount,
      promptEvalDuration: promptEvalDuration,
      evalCount: evalCount,
      evalDuration: evalDuration,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension MessageDomainMapper on MessageEntity {
  MessageTableCompanion toData() {
    return MessageTableCompanion.insert(
      roomId: roomId,
      role: role,
      content: Value(content),
      model: Value(model),
      totalDuration: Value(totalDuration),
      loadDuration: Value(loadDuration),
      promptEvalCount: Value(promptEvalCount),
      promptEvalDuration: Value(promptEvalDuration),
      evalCount: Value(evalCount),
      evalDuration: Value(evalDuration),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
