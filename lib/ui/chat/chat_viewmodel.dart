import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/chat_mode.dart';
import '../../domain/models/chat_room_entity.dart';
import '../../domain/models/message_entity.dart';
import '../../domain/models/role.dart';
import '../../domain/repository/database_repository.dart';
import '../../domain/repository/ollama_repository.dart';
import '../../domain/repository/preferences_repository.dart';
import '../../domain/use_cases/create_chat_room_use_cases.dart';
import '../../domain/use_cases/send_chat_use_case.dart';
import '../../i18n/strings.g.dart';
import '../../utils/logger.dart';
import '../core/base/base_cubit.dart';
import '../routing/router.dart';

part 'chat_viewmodel.freezed.dart';

extension MessageMapper on MessageEntity {
  Message toMessage() {
    if (role == Role.user) {
      return Message.user(
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    } else {
      return Message.ai(
        model: model ?? '',
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }
  }
}

extension MessageEntityMapper on Message {
  MessageEntity toMessageEntity(int roomId, String model) {
    final isUser = this is UserMessage;
    return MessageEntity(
      roomId: roomId,
      role: isUser ? Role.user : Role.assistant,
      content: content,
      model: isUser ? null : model,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension ChatRoomMapper on ChatRoomEntity {
  ChatRoom toChatRoom() => ChatRoom(
        id: id,
        name: name,
        prompt: prompt,
        chatMode: chatMode,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension ChatRoomEntityMapper on ChatRoom {
  ChatRoomEntity toChatRoomEntity() => ChatRoomEntity(
        id: id,
        name: name,
        prompt: prompt,
        chatMode: chatMode,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

@freezed
class UiError with _$UiError {
  const UiError._();

  const factory UiError.initDataLoadFailed() = OllamaConnectionFailed;
}

@freezed
class ChatRoom with _$ChatRoom {
  const factory ChatRoom({
    int? id,
    required String name,
    required String prompt,
    required String chatMode,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChatRoom;
}

@freezed
class Message with _$Message {
  const Message._();

  const factory Message.user({
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = UserMessage;

  const factory Message.ai({
    required String model,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = AiMessage;
}

@freezed
class Option with _$Option {
  const factory Option({
    @Default([]) List<String> modelList,
    @Default(0) int indexSelectModel,
    @Default('') String model,
    @Default([]) List<String> chatModeList,
    @Default(0) int indexSelectChatMode,
    @Default('') String chatMode,
    @Default('') String prompt,
  }) = _Option;
}

@freezed
class ChatUiState with _$ChatUiState {
  const factory ChatUiState({
    @Default(null) ChatRoom? chatRoom,
    @Default('') String currentInput,
    @Default([]) List<Message> messages,
    @Default(true) bool isInitLoading,
    @Default(false) bool isGeneratingChat,
    @Default(Option()) Option option,
    @Default(null) UiError? uiError,
    @Default(false) bool navigateBack,
  }) = _ChatUiState;
}

class ChatViewModel extends BaseCubit<ChatUiState> {
  final OllamaRepository _ollamaRepository;
  final DatabaseRepository _databaseRepository;

  final CreateChatRoomUseCase _createChatRoomUseCase;
  final OllamaChatUseCase _chatUseCase;

  final TextEditingController messageController = TextEditingController();
  final FocusNode messageFocusNode = FocusNode();

  StreamSubscription? _chatUseCaseSub;

  ChatViewModel(
    this._ollamaRepository,
    this._databaseRepository,
    this._createChatRoomUseCase,
    this._chatUseCase,
  ) : super(const ChatUiState()) {
    messageController.addListener(
      () => emit(
        state.copyWith(
          currentInput: messageController.text,
        ),
      ),
    );
  }

  Future<void> init(ChatScreenParams params) async {
    try {
      emit(state.copyWith(isInitLoading: true));

      final chatRoomId = params.id;
      if (chatRoomId != null) {
        await _loadChatRoom(chatRoomId);
      } else {
        await _newChatRoom(params);
        await sendMessage();
      }
      emit(state.copyWith(isInitLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          isInitLoading: false,
          uiError: const UiError.initDataLoadFailed(),
        ),
      );
    }
  }

  Future<void> _newChatRoom(
    ChatScreenParams params,
  ) async {
    await _initOption(
      params.model!,
      params.mode!,
      params.prompt!,
    );
    messageController.text = params.question!;
  }

  Future<void> _loadChatRoom(
    int chatRoomId,
  ) async {
    final messages = await _databaseRepository.getMessagesInRoom(chatRoomId);
    emit(
      state.copyWith(
        messages: messages.map((msg) => msg.toMessage()).toList(),
        isGeneratingChat: false,
      ),
    );

    final chatRoom = await _databaseRepository.getChatRoom(chatRoomId);
    emit(state.copyWith(chatRoom: chatRoom!.toChatRoom()));

    final MessageEntity userMessage = messages.firstWhere(
      (element) => element.role == Role.assistant,
    );

    final model = userMessage.model ?? '';
    final chatMode = chatRoom.chatMode;
    final prompt = chatRoom.prompt;

    await _initOption(model, chatMode, prompt);
  }

  Future<void> _initOption(
    String model,
    String chatMode,
    String prompt,
  ) async {
    final modelList =
        (await _ollamaRepository.getModels()).map((e) => e.name).toList();

    if (modelList.isEmpty) {
      emit(state.copyWith(uiError: const UiError.initDataLoadFailed()));
    }

    var indexSelectModel = modelList.indexOf(model);
    if (indexSelectModel < 0) {
      indexSelectModel = 0;
    }

    final chatModeList = ChatMode.values.map((e) => e.label).toList();

    int indexSelectMode = chatModeList.indexOf(chatMode);
    if (indexSelectMode < 0) {
      indexSelectMode = 0;
    }

    var updatePrompt = prompt;
    if (prompt.isEmpty) {
      updatePrompt = PreferenceKeys.prompt.getDefaultValue()!;
    }
    emit(
      state.copyWith(
        option: state.option.copyWith(
          modelList: modelList,
          model: model,
          indexSelectModel: indexSelectModel,
          chatModeList: chatModeList,
          chatMode: chatMode,
          indexSelectChatMode: indexSelectMode,
          prompt: updatePrompt,
        ),
      ),
    );
  }

  Future<void> sendMessage() async {
    if (state.isGeneratingChat) {
      return;
    }

    if (state.uiError != null) {
      showToast(t.settings.connectionFailed);
      return;
    }

    final newMessage = messageController.text.trim();
    _clearMessage();

    if (newMessage.trim().isEmpty) return;

    final now = DateTime.now();
    emit(
      state.copyWith(
        messages: [
          Message.ai(
            model: state.option.model,
            content: '',
            createdAt: now,
            updatedAt: now,
          ),
          Message.user(
            content: newMessage,
            createdAt: now,
            updatedAt: now,
          ),
          ...state.messages,
        ],
        isGeneratingChat: true,
        uiError: null,
      ),
    );

    if (state.chatRoom?.id == null) {
      final newRoom = await _createChatRoomUseCase.execute(
        name: newMessage,
        chatMode: state.option.chatMode,
        prompt: state.option.prompt,
      );
      if (newRoom.id == null) return;
      emit(state.copyWith(chatRoom: newRoom.toChatRoom()));
    }

    final localRoomId = state.chatRoom?.id;
    if (localRoomId == null) return;

    await _chatUseCaseSub?.cancel();
    _chatUseCaseSub = _chatUseCase
        .execute(
      roomId: localRoomId,
      model: state.option.model,
      prompt: state.option.prompt,
      messages: state.messages.map((Message msg) {
        return msg.toMessageEntity(localRoomId, state.option.model);
      }).toList(),
    )
        .listen(
      (response) {
        final updatedMessages = [...state.messages];
        if (updatedMessages.isNotEmpty) {
          final aiMessage = updatedMessages[0];
          updatedMessages[0] = aiMessage.copyWith(
            content: aiMessage.content + response,
          );

          emit(state.copyWith(messages: updatedMessages));
        }
      },
      onError: (error, stackTrace) {
        logError('Failed to generate chat response $error', stackTrace);
        emit(
          state.copyWith(
            uiError: null,
            isGeneratingChat: false,
          ),
        );
      },
      onDone: () {
        emit(
          state.copyWith(
            isGeneratingChat: false,
            messages: state.messages,
          ),
        );
      },
    );

    _clearMessage();
  }

  void _clearMessage() {
    messageController.clear();
    messageFocusNode.requestFocus();
  }

  void cancelChat() {
    _ollamaRepository.cancelCurrentChat();
    emit(state.copyWith(isGeneratingChat: false));
  }

  @override
  Future<void> close() async {
    cancelChat();
    await _chatUseCaseSub?.cancel();
    messageController.dispose();
    messageFocusNode.dispose();
    return super.close();
  }

  Future<void> deleteChatRoom() async {
    final int? id = state.chatRoom?.id;
    if (id == null) return;
    final success = await _databaseRepository.deleteChatRoom(id);
    if (!success) return;
    emit(state.copyWith(navigateBack: true));
  }

  void updateSelectedModel(String? model) {
    if (model == null) return;

    final selectedModel = model;
    var indexSelectModel = state.option.modelList.indexOf(selectedModel);
    if (indexSelectModel < 0) {
      indexSelectModel = 0;
    }
    emit(
      state.copyWith(
        option: state.option.copyWith(
          model: model,
          indexSelectModel: indexSelectModel,
        ),
      ),
    );
  }

  Future<void> updateChatMode(String? mode) async {
    if (mode == null) return;
    int indexSelectMode = state.option.chatModeList.indexOf(mode);
    if (indexSelectMode < 0) {
      indexSelectMode = 0;
    }
    emit(
      state.copyWith(
        chatRoom: state.chatRoom!.copyWith(chatMode: mode),
        option: state.option.copyWith(
          chatMode: mode,
          indexSelectChatMode: indexSelectMode,
        ),
      ),
    );
    await _databaseRepository.updateChatRoom(
      state.chatRoom!.toChatRoomEntity(),
    );
  }

  Future<void> updatePrompt(String prompt) async {
    var updatePrompt = prompt;
    if (prompt.isEmpty) {
      updatePrompt = PreferenceKeys.prompt.getDefaultValue()!;
    }
    emit(
      state.copyWith(
        chatRoom: state.chatRoom!.copyWith(prompt: updatePrompt),
        option: state.option.copyWith(prompt: updatePrompt),
      ),
    );

    final chatRoomEntity = state.chatRoom!.toChatRoomEntity();
    await _databaseRepository.updateChatRoom(
      chatRoomEntity,
    );
  }
}
