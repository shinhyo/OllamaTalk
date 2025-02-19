import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../utils/logger.dart';
import '../models/ollama_entity.dart';
import '../repository/ollama_repository.dart';
import '../repository/preferences_repository.dart';

class WatchOllamaModelsUseCase {
  final OllamaRepository _ollamaRepository;
  final PreferencesRepository _preferencesRepository;
  final _key = PreferenceKeys.ollamaModel;

  WatchOllamaModelsUseCase(
    this._ollamaRepository,
    this._preferencesRepository,
  );

  Stream<({List<OllamaModelEntity> models, String? selectedModel})> get stream {
    return _preferencesRepository
        .watch<String>(PreferenceKeys.apiHost)
        .switchMap(
      (_) {
        logDebug('switchMap');
        return Rx.combineLatest2(
          Stream.fromFuture(_ollamaRepository.getModels()),
          _preferencesRepository.watch(_key),
          (List<OllamaModelEntity> models, String? selectedModel) {
            if (selectedModel == null && models.isNotEmpty) {
              selectedModel = models.first.name;
              _preferencesRepository.set<String>(_key, selectedModel);
            }
            return (models: models, selectedModel: selectedModel);
          },
        );
      },
    );
  }
}
