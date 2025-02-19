import '../models/chat_room_entity.dart';
import '../repository/database_repository.dart';

class CreateChatRoomUseCase {
  final DatabaseRepository _databaseRepository;

  CreateChatRoomUseCase(this._databaseRepository);

  Future<ChatRoomEntity> execute({
    required String? name,
    required String chatMode,
    required String prompt,
  }) async {
    final now = DateTime.now();
    final newChatRoom = ChatRoomEntity(
      name: name ?? 'New Chat',
      prompt: prompt,
      chatMode: chatMode,
      createdAt: now,
      updatedAt: now,
    );
    final id = await _databaseRepository.createChatRoom(newChatRoom);
    return newChatRoom.copyWith(id: id);
  }
}
