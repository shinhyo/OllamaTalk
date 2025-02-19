import '../config/network_config.dart';
import '../repository/preferences_repository.dart';

class UpdateHostUseCase {
  final PreferencesRepository _preferencesRepository;
  final NetworkConfig _networkConfig;

  UpdateHostUseCase(this._preferencesRepository, this._networkConfig);

  void execute(String newHost) {
    _preferencesRepository.set<String>(PreferenceKeys.apiHost, newHost);
    _networkConfig.updateBaseUrl(newHost);
  }
}
