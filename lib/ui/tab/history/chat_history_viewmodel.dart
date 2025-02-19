import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../domain/models/chat_room_entity.dart';
import '../../../domain/models/message_entity.dart';
import '../../../domain/repository/database_repository.dart';
import '../../../utils/string_ext.dart';
import '../../core/base/base_cubit.dart';

part 'chat_history_viewmodel.freezed.dart';

@freezed
class GroupChatRooms with _$GroupChatRooms {
  const GroupChatRooms._();

  const factory GroupChatRooms.header({
    required String date,
  }) = HeaderItem;

  const factory GroupChatRooms.room({
    required ChatRoomEntity room,
    MessageEntity? lastMessage,
    required String formattedTime,
    String? model,
    String? chatMode,
  }) = RoomItem;
}

@freezed
class UiState with _$UiState {
  const factory UiState({
    @Default(true) bool isLoading,
    @Default([]) List<GroupChatRooms> chatRooms,
    String? error,
  }) = _UiState;
}

class ChatHistoryViewModel extends BaseCubit<UiState> {
  final DatabaseRepository _databaseRepository;

  ChatHistoryViewModel(
    this._databaseRepository,
  ) : super(const UiState()) {
    _loadChatRooms();
  }

  StreamSubscription? _chatRoomsSub;

  void _loadChatRooms() {
    _chatRoomsSub = _databaseRepository.watchAllRoomsWithLastMessage().listen(
      (List<({ChatRoomEntity chatRoom, MessageEntity? lastMessage})> rooms) {
        final List<GroupChatRooms> items = [];
        DateTime? currentDate;

        for (var room in rooms) {
          final roomDate = DateTime(
            room.chatRoom.updatedAt.year,
            room.chatRoom.updatedAt.month,
            room.chatRoom.updatedAt.day,
          );

          if (currentDate != roomDate) {
            items.add(GroupChatRooms.header(date: _formatDate(roomDate)));
            currentDate = roomDate;
          }

          final messageEntity = room.lastMessage;
          items.add(
            GroupChatRooms.room(
              room: room.chatRoom,
              lastMessage: messageEntity?.copyWith(
                content: messageEntity.content.removeNewLines,
              ),
              formattedTime:
                  DateFormat('HH:mm').format(room.chatRoom.updatedAt),
              model: messageEntity?.model?.trim(),
              chatMode: room.chatRoom.chatMode,
            ),
          );
        }

        emit(state.copyWith(chatRooms: items, isLoading: false));
      },
      onError: (error) {
        emit(state.copyWith(error: error.toString(), isLoading: false));
      },
    );
  }

  String _formatDate(DateTime date) {
    final locale = Intl.getCurrentLocale();
    return DateFormat.yMMMd(locale).format(date);
  }

  @override
  Future<void> close() async {
    await Future.wait([
      _chatRoomsSub?.cancel() ?? Future.value(),
    ]);
    return super.close();
  }

  Future<void> deleteChatRoom(int? id) async {
    if (id == null) return;
    await _databaseRepository.deleteChatRoom(id);
  }
}
