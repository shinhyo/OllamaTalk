import 'package:drift/drift.dart';

import '../../domain/models/chat_room_entity.dart';
import '../../domain/models/message_entity.dart';
import '../../domain/repository/database_repository.dart';
import '../../utils/logger.dart';
import '../source/local/database/table/chat_room_table.dart';
import '../source/local/database/table/message_table.dart';
import '../source/local/drift.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  final AppDatabase _db;

  DatabaseRepositoryImpl(this._db);

  // ChatRoom
  @override
  Future<int> createChatRoom(ChatRoomEntity room) {
    logInfo('createChatRoom: $room');
    return _db.chatRoomDao.createRoom(room.toData());
  }

  @override
  Stream<ChatRoomEntity?> watchChatRoom(int roomId) {
    return _db.chatRoomDao.watchRoom(roomId).map((room) => room?.toDomain());
  }

  @override
  Future<ChatRoomEntity?> getChatRoom(int roomId) async {
    return await watchChatRoom(roomId).first;
  }

  @override
  Future<List<ChatRoomEntity>> getAllChatRooms() async {
    final rooms = await (_db.select(_db.chatRoomTable)
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.updatedAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
    return [for (final room in rooms) room.toDomain()];
  }

  @override
  Stream<List<ChatRoomEntity>> watchAllChatRooms() => _db.chatRoomDao
      .watchAllRooms()
      .map((rooms) => [for (final room in rooms) room.toDomain()]);

  @override
  Stream<List<({ChatRoomEntity chatRoom, MessageEntity? lastMessage})>>
      watchAllRoomsWithLastMessage() {
    return _db.chatRoomDao.watchChatRoomsWithLastMessage().map(
          (rooms) => rooms
              .map(
                (room) => (
                  chatRoom: room.$1.toDomain(),
                  lastMessage: room.$2?.toDomain(),
                ),
              )
              .toList(),
        );
  }

  @override
  Future<int> updateChatRoom(ChatRoomEntity room) {
    return (_db.update(_db.chatRoomTable)
          ..where((tbl) => tbl.id.equals(room.id!)))
        .write(room.toData());
  }

  @override
  Future<int> updateChatRoomName(int roomId, String name) {
    return (_db.update(_db.chatRoomTable)
          ..where((tbl) => tbl.id.equals(roomId)))
        .write(ChatRoomTableCompanion(name: Value(name)));
  }

  @override
  Future<bool> deleteChatRoom(int roomId) =>
      (_db.delete(_db.chatRoomTable)..where((tbl) => tbl.id.equals(roomId)))
          .go()
          .then((count) => count > 0);

  // Message
  @override
  Future<int> createMessage(int roomId, MessageEntity message) =>
      _db.messageDao.insertMessage(message.toData());

  @override
  Future<List<MessageEntity>> getRecentMessages(
    int roomId, {
    int limit = 10,
  }) async {
    final messages =
        await _db.messageDao.getRecentMessages(roomId, limit: limit);
    return [for (final msg in messages) msg.toDomain()];
  }

  @override
  Future<List<MessageEntity>> getMessagesInRoom(int roomId) async {
    final messages = await (_db.select(_db.messageTable)
          ..where((tbl) => tbl.roomId.equals(roomId))
          ..orderBy([
            (t) => OrderingTerm(
                  expression: t.createdAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();
    return [for (final message in messages) message.toDomain()];
  }

  @override
  Stream<List<MessageEntity>> watchMessagesInRoom(int roomId) => _db.messageDao
      .watchMessagesInRoom(roomId)
      .map((messages) => [for (final msg in messages) msg.toDomain()]);

  @override
  Future<bool> deleteMessage(int messageId) =>
      (_db.delete(_db.messageTable)..where((tbl) => tbl.id.equals(messageId)))
          .go()
          .then((count) => count > 0);
}
