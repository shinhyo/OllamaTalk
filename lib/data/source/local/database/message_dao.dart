import 'package:drift/drift.dart';

import '../drift.dart';
import 'table/chat_room_table.dart';
import 'table/message_table.dart';

part 'message_dao.g.dart';

@DriftAccessor(tables: [MessageTable, ChatRoomTable])
class MessageDao extends DatabaseAccessor<AppDatabase> with _$MessageDaoMixin {
  MessageDao(super.db);

  Future<List<Message>> getRecentMessages(int roomId, {int limit = 10}) {
    return (select(messageTable)
          ..where((tbl) => tbl.roomId.equals(roomId))
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.id,
                  mode: OrderingMode.desc,
                ),
          ])
          ..limit(limit))
        .get();
  }

  Future<int> insertMessage(MessageTableCompanion message) {
    return into(messageTable).insert(message);
  }

  Stream<List<Message>> watchMessagesInRoom(int roomId) {
    return (select(messageTable)
          ..where((tbl) => tbl.roomId.equals(roomId))
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.createdAt,
                ),
          ]))
        .watch();
  }
}
