import '../models/chat_room_entity.dart';
import '../models/message_entity.dart';

abstract class DatabaseRepository {
  // chatRoom
  Future<int> createChatRoom(ChatRoomEntity room);

  Future<ChatRoomEntity?> getChatRoom(int roomId);

  Stream<ChatRoomEntity?> watchChatRoom(int roomId);

  Future<List<ChatRoomEntity>> getAllChatRooms();

  Stream<List<ChatRoomEntity>> watchAllChatRooms();

  Stream<List<({ChatRoomEntity chatRoom, MessageEntity? lastMessage})>>
      watchAllRoomsWithLastMessage();

  Future<int> updateChatRoom(ChatRoomEntity room);

  Future<int> updateChatRoomName(int roomId, String name);

  Future<bool> deleteChatRoom(int roomId);

  // message
  Future<int> createMessage(int roomId, MessageEntity message);

  Future<List<MessageEntity>> getRecentMessages(int roomId, {int limit = 10});

  Future<List<MessageEntity>> getMessagesInRoom(int roomId);

  Stream<List<MessageEntity>> watchMessagesInRoom(int roomId);

  Future<bool> deleteMessage(int messageId);
}
