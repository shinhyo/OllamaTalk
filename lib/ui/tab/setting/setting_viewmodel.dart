import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/models/ollama_entity.dart';
import '../../../domain/repository/device_info_repository.dart';
import '../../../domain/repository/ollama_repository.dart';
import '../../../domain/repository/preferences_repository.dart';
import '../../../domain/use_cases/update_host_use_case.dart';
import '../../../domain/use_cases/watch_selected_model_use_case.dart';
import '../../../i18n/strings.g.dart';
import '../../../utils/logger.dart';
import '../../../utils/string_ext.dart';
import '../../core/base/base_cubit.dart';

part 'setting_viewmodel.freezed.dart';

@freezed
class UiError with _$UiError {
  const UiError._();

  const factory UiError.modelsLoadFailed() = ModelsLoadFailed;
}

@freezed
class UiState with _$UiState {
  const factory UiState({
    @Default(false) bool isLoading,
    @Default(null) String? selectedModel,
    @Default(null) String? baseUrl,
    @Default([]) List<OllamaModelEntity> models,
    @Default([]) List<String> themeModeList,
    @Default('dark') String themeMode,
    @Default(null) String? appVersion,
    @Default(null) UiError? uiError,
  }) = _UiState;
}

class SettingViewmodel extends BaseCubit<UiState> {
  final OllamaRepository _ollamaRepository;
  final PreferencesRepository _preferencesRepository;
  final DeviceInfoRepository _deviceInfoRepository;
  final WatchOllamaModelsUseCase _watchOllamaModelsUseCase;
  final UpdateHostUseCase _updateHostUseCase;

  final _compositeSubscription = CompositeSubscription();

  SettingViewmodel(
    this._ollamaRepository,
    this._preferencesRepository,
    this._deviceInfoRepository,
    this._watchOllamaModelsUseCase,
    this._updateHostUseCase,
  ) : super(const UiState()) {
    init();
  }

  init() async {
    final appVersion = await _deviceInfoRepository.getAppVersion();
    emit(
      state.copyWith(
        uiError: null,
        isLoading: true,
        themeModeList:
            ThemeMode.values.map((e) => e.name.toFirstUpper()).toList(),
        appVersion: appVersion,
      ),
    );

    CombineLatestStream.list([
      _preferencesRepository.watch<String>(PreferenceKeys.apiHost),
      _preferencesRepository
          .watch(PreferenceKeys.themeMode)
          .map((event) => mapThemeMode(event)),
    ]).listen(
      (value) {
        final baseUrl = value[0];
        final themeMode = value[1] as String;
        emit(
          state.copyWith(
            isLoading: false,
            baseUrl: baseUrl,
            themeMode: themeMode,
          ),
        );
      },
    ).addTo(_compositeSubscription);

    _watchOllamaModelsUseCase.stream.listen(
      (event) {
        if (event.models.isEmpty) {
          emit(state.copyWith(uiError: const UiError.modelsLoadFailed()));
          return;
        }

        emit(state.copyWith(uiError: null));
      },
      onError: (error, stackTrace) {
        emit(state.copyWith(uiError: const UiError.modelsLoadFailed()));
      },
    ).addTo(_compositeSubscription);
  }

  String mapThemeMode(String? event) {
    if (event == null) return ThemeMode.dark.name.toFirstUpper();
    return ThemeMode.values.byName(event.toLowerCase()).name.toFirstUpper();
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isScheme('http') || uri.isScheme('https');
    } catch (e) {
      logError(e);
      showToast(t.settings.invalidUrl);
      return false;
    }
  }

  void updateBaseUrl(String url) {
    if (!_isValidUrl(url)) return;
    _updateHostUseCase.execute(url);
  }

  void updateThemeMode(String themeMode) {
    _preferencesRepository.set<String>(PreferenceKeys.themeMode, themeMode);
  }

  refresh() async {
    try {
      final list = await _ollamaRepository.getModels();
      if (list.isEmpty) {
        showToast(t.settings.noModels);
        return;
      }
    } catch (e) {
      showToast(t.settings.connectionFailed);
      emit(state.copyWith(uiError: const UiError.modelsLoadFailed()));
    }
    updateBaseUrl(state.baseUrl!);
  }

  @override
  Future<void> close() async {
    await _compositeSubscription.dispose();
    return super.close();
  }
}
