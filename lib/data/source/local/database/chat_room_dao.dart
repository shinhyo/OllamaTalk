import 'package:drift/drift.dart';

import '../../../../utils/logger.dart';
import '../drift.dart';
import 'table/chat_room_table.dart';
import 'table/message_table.dart';

part 'chat_room_dao.g.dart';

@DriftAccessor(tables: [ChatRoomTable, MessageTable])
class ChatRoomDao extends DatabaseAccessor<AppDatabase>
    with _$ChatRoomDaoMixin {
  ChatRoomDao(super.db);

  Future<int> createRoom(ChatRoomTableCompanion room) {
    logInfo('createRoom: $room');
    return into(chatRoomTable).insert(room);
  }

  Stream<ChatRoom?> watchRoom(int roomId) {
    return (select(chatRoomTable)..where((tbl) => tbl.id.equals(roomId)))
        .watchSingleOrNull();
  }

  Stream<List<ChatRoom>> watchAllRooms() {
    return (select(chatRoomTable)
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.updatedAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .watch();
  }

  Stream<List<(ChatRoom, Message?)>> watchChatRoomsWithLastMessage() {
    final chatRooms = alias(chatRoomTable, 'cr');
    final messages = alias(messageTable, 'm');

    final query = select(chatRooms).join([
      leftOuterJoin(
        messages,
        messages.roomId.equalsExp(chatRooms.id),
      ),
    ])
      ..addColumns([messages.id, messages.content, messages.createdAt])
      ..where(messages.id.isNotNull())
      ..orderBy([
        OrderingTerm(expression: messages.createdAt, mode: OrderingMode.desc),
      ]);

    return query.watch().map((rows) {
      final grouped = <int, (ChatRoom, Message?)>{};

      for (final row in rows) {
        final chatRoom = row.readTable(chatRooms);
        final message = row.readTableOrNull(messages);

        if (!grouped.containsKey(chatRoom.id)) {
          grouped[chatRoom.id] = (chatRoom, message);
        }
      }

      return grouped.values.toList();
    });
  }
}
