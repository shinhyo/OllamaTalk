import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/models/chat_mode.dart';
import '../../../domain/models/ollama_entity.dart';
import '../../../domain/repository/preferences_repository.dart';
import '../../../domain/use_cases/watch_selected_model_use_case.dart';
import '../../../utils/logger.dart';
import '../../core/base/base_cubit.dart';

part 'home_viewmodel.freezed.dart';

@freezed
class UiError with _$UiError {
  const UiError._();

  const factory UiError.initDataLoadFailed() = OllamaConnectionFailed;
}

@freezed
class Toolbar with _$Toolbar {
  const factory Toolbar({
    @Default(false) bool isLoading,
    @Default([]) List<String> models,
    @Default(0) int modelIdx,
    @Default([]) List<String> chatModes,
    @Default(0) int chatModeIdx,
    @Default(null) String? prompt,
  }) = _Toolbar;
}

@freezed
class UiState with _$UiState {
  const factory UiState({
    @Default(Toolbar()) Toolbar toolbar,
    @Default('') String currentInput,
    @Default(null) String? navigateChatScreen,
    @Default(null) UiError? uiError,
  }) = _UiState;
}

class HomeViewModel extends BaseCubit<UiState> {
  final PreferencesRepository _preferencesRepository;
  final WatchOllamaModelsUseCase _watchOllamaModelsUseCase;

  final TextEditingController messageController = TextEditingController();
  final CompositeSubscription _compositeSubscription = CompositeSubscription();

  HomeViewModel(
    this._preferencesRepository,
    this._watchOllamaModelsUseCase,
  ) : super(const UiState()) {
    init();
  }

  init() async {
    messageController.addListener(
      () => emit(state.copyWith(currentInput: messageController.text)),
    );
    await _loadData();
  }

  Future<void> _loadData() async {
    await initToolbar();
  }

  Future<void> initToolbar() async {
    final chatModes = ChatMode.values.map((e) => e.label).toList();
    emit(
      state.copyWith(
        uiError: null,
        toolbar: state.toolbar.copyWith(
          isLoading: true,
          chatModes: chatModes,
          prompt: _preferencesRepository.get<String>(PreferenceKeys.prompt),
        ),
      ),
    );

    // watch
    CombineLatestStream.list([
      _watchOllamaModelsUseCase.stream.map((event) => _calModeIdx(event)),
      _preferencesRepository
          .watch<String>(PreferenceKeys.chatMode)
          .map((event) => _calChatModeIdx(event, chatModes)),
      _preferencesRepository.watch<String>(PreferenceKeys.prompt),
    ]).listen(
      (List<dynamic> values) {
        final watchModel = values[0] as ({int modelIdx, List<String> models});
        if (watchModel.models.isEmpty) {
          emit(state.copyWith(uiError: const UiError.initDataLoadFailed()));
          return;
        }
        final chatModeIdx = values[1] as int;
        final prompt = values[2] as String?;
        emit(
          state.copyWith(
            uiError: null,
            toolbar: state.toolbar.copyWith(
              models: watchModel.models,
              modelIdx: watchModel.modelIdx,
              chatModeIdx: chatModeIdx,
              prompt: prompt,
              isLoading: false,
            ),
          ),
        );
      },
      onError: (error, stackTrace) {
        emit(
          state.copyWith(
            uiError: const UiError.initDataLoadFailed(),
            toolbar: state.toolbar.copyWith(isLoading: false),
          ),
        );
      },
    ).addTo(_compositeSubscription);
  }

  int _calChatModeIdx(String? event, List<String> chatModes) {
    int chatModeIdx = event != null ? chatModes.indexOf(event) : 0;
    if (chatModeIdx < 0) {
      chatModeIdx = 0;
    }
    return chatModeIdx;
  }

  ({int modelIdx, List<String> models}) _calModeIdx(
    ({List<OllamaModelEntity> models, String? selectedModel}) event,
  ) {
    final List<String> models = event.models.map((e) => e.name).toList();
    final String selectedModel = event.selectedModel ?? '';
    int modelIdx = models.indexOf(selectedModel);
    if (modelIdx < 0) {
      modelIdx = 0;
    }
    return (models: models, modelIdx: modelIdx);
  }

  refreshData() async {
    emit(state.copyWith(uiError: null));
    logInfo('refreshData init');
    await _loadData();
  }

  void updateSelectedModel(String? model) {
    if (model == null) return;
    _preferencesRepository.set<String>(
      PreferenceKeys.ollamaModel,
      model,
    );
  }

  void updateChatMode(String? mode) {
    if (mode == null) return;
    _preferencesRepository.set<String>(PreferenceKeys.chatMode, mode);
  }

  void updatePrompt(String prompt) {
    var updatePrompt = prompt;
    if (prompt.isEmpty) {
      updatePrompt = PreferenceKeys.prompt.getDefaultValue()!;
    }
    _preferencesRepository.set<String>(
      PreferenceKeys.prompt,
      updatePrompt,
    );
  }

  void handleSubmitted() {
    if (state.uiError != null) {
      showToast('Ollama connection failed');
      return;
    }

    emit(state.copyWith(navigateChatScreen: messageController.text));
    messageController.clear();
  }

  void clearNavigate() {
    emit(state.copyWith(navigateChatScreen: null));
  }

  @override
  Future<void> close() async {
    await _compositeSubscription.dispose();
    messageController.dispose();
    return super.close();
  }
}
