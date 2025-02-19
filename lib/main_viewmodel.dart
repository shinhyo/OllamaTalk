import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/repository/preferences_repository.dart';

part 'main_viewmodel.freezed.dart';

@freezed
class UiState with _$UiState {
  const factory UiState({
    ThemeMode? themeMode,
  }) = _UiState;
}

class AppViewModel extends Cubit<UiState> {
  final PreferencesRepository _preferencesRepository;
  final _compositeSubscription = CompositeSubscription();

  AppViewModel(
    this._preferencesRepository,
  ) : super(const UiState()) {
    _init();
  }

  _init() {
    final savedTheme = _preferencesRepository.get(PreferenceKeys.themeMode);
    emit(state.copyWith(themeMode: getThemeMode(savedTheme)));

    _preferencesRepository.watch(PreferenceKeys.themeMode).listen(
      (String? event) {
        emit(state.copyWith(themeMode: getThemeMode(event)));
      },
    ).addTo(_compositeSubscription);
  }

  ThemeMode getThemeMode(String? savedTheme) =>
      ThemeMode.values.byName(savedTheme?.toLowerCase() ?? 'system');

  @override
  Future<void> close() async {
    await _compositeSubscription.dispose();
    await super.close();
  }
}
