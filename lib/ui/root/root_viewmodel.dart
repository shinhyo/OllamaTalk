import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repository/preferences_repository.dart';
import '../core/base/base_command.dart';

part 'root_viewmodel.freezed.dart';

@freezed
class RootUiState with _$RootUiState {
  const factory RootUiState({
    UICommand? command,
    ThemeMode? themeMode,
  }) = _RootUiState;
}

class RootViewModel extends Cubit<RootUiState> {
  final PreferencesRepository _preferencesRepository;
  final UICommandController _uiCommandController;

  final _compositeSubscription = CompositeSubscription();

  RootViewModel(
    this._preferencesRepository,
    this._uiCommandController,
  ) : super(const RootUiState()) {
    _init();
  }

  void _init() {
    _subscribeToCommands();

    _preferencesRepository.watch(PreferenceKeys.themeMode).listen(
      (String? event) {
        final themeMode =
            ThemeMode.values.byName(event?.toLowerCase() ?? 'dark');
        emit(state.copyWith(themeMode: themeMode));
      },
    ).addTo(_compositeSubscription);
  }

  void _subscribeToCommands() {
    _uiCommandController.stream
        .listen(
          (command) => emit(state.copyWith(command: command)),
        )
        .addTo(_compositeSubscription);
  }

  void clearCommand() {
    emit(state.copyWith(command: null));
  }

  @override
  Future<void> close() async {
    await _compositeSubscription.dispose();
    await _uiCommandController.dispose();
    await super.close();
  }
}
