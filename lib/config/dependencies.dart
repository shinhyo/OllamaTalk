import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../data/config/network_config_impl.dart';
import '../data/repository/database_repository_impl.dart';
import '../data/repository/device_info_repository_impl.dart';
import '../data/repository/ollama_repository_impl.dart';
import '../data/repository/shared_preferences_impl.dart';
import '../data/source/local/drift.dart';
import '../data/source/network/dio.dart';
import '../domain/config/network_config.dart';
import '../domain/repository/database_repository.dart';
import '../domain/repository/device_info_repository.dart';
import '../domain/repository/ollama_repository.dart';
import '../domain/repository/preferences_repository.dart';
import '../domain/use_cases/create_chat_room_name_use_case.dart';
import '../domain/use_cases/create_chat_room_use_cases.dart';
import '../domain/use_cases/ollama_generate_use_case.dart';
import '../domain/use_cases/send_chat_use_case.dart';
import '../domain/use_cases/update_host_use_case.dart';
import '../domain/use_cases/watch_selected_model_use_case.dart';
import '../main_viewmodel.dart';
import '../ui/chat/chat_viewmodel.dart';
import '../ui/core/base/base_command.dart';
import '../ui/root/root_viewmodel.dart';
import '../ui/tab/history/chat_history_viewmodel.dart';
import '../ui/tab/home/home_viewmodel.dart';
import '../ui/tab/setting/setting_viewmodel.dart';
import '../utils/logger.dart';

final getIt = GetIt.instance;

Future<void> initDataInject() async {
  getIt.registerLazySingleton<Logger>(() => Logger());

  // data
  final preferencesRepository = await PreferencesRepositoryImpl.create();
  getIt.registerSingleton<PreferencesRepository>(preferencesRepository);
  getIt.registerLazySingleton<Dio>(
    () => ApiClient.createDio(getIt<PreferencesRepository>()),
  );
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());

  getIt.registerLazySingleton<OllamaRepository>(
    () => OllamaRepositoryImpl(
      getIt<Dio>(),
    ),
  );
  getIt.registerLazySingleton<DatabaseRepository>(
    () => DatabaseRepositoryImpl(
      getIt<AppDatabase>(),
    ),
  );
  getIt.registerLazySingleton<DeviceInfoRepository>(
    () => DeviceInfoRepositoryImpl(),
  );

  getIt.registerLazySingleton<NetworkConfig>(
    () => NetworkConfigImpl(getIt<Dio>()),
  );

  // domain
  getIt.registerLazySingleton(
    () => WatchOllamaModelsUseCase(
      getIt<OllamaRepository>(),
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => OllamaGenerateUseCase(
      getIt<OllamaRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => OllamaChatUseCase(
      getIt<OllamaRepository>(),
      getIt<DatabaseRepository>(),
    ),
  );
  getIt.registerLazySingleton(() {
    return UpdateHostUseCase(
      getIt<PreferencesRepository>(),
      getIt<NetworkConfig>(),
    );
  });
  getIt.registerLazySingleton(
    () => ChatRoomNameUseCase(
      getIt<OllamaRepository>(),
    ),
  );

  getIt.registerLazySingleton(
    () => CreateChatRoomUseCase(
      getIt<DatabaseRepository>(),
    ),
  );

  // ui
  getIt.registerLazySingleton(
    () => UICommandController(),
  );
  getIt.registerLazySingleton(
    () => AppViewModel(
      getIt<PreferencesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => RootViewModel(
      getIt<PreferencesRepository>(),
      getIt<UICommandController>(),
    ),
  );
  getIt.registerFactory(
    () => ChatViewModel(
      getIt<OllamaRepository>(),
      getIt<DatabaseRepository>(),
      getIt<CreateChatRoomUseCase>(),
      getIt<OllamaChatUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => ChatHistoryViewModel(
      getIt<DatabaseRepository>(),
    ),
  );
  getIt.registerFactory(
    () => HomeViewModel(
      getIt<PreferencesRepository>(),
      getIt<WatchOllamaModelsUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => SettingViewmodel(
      getIt<OllamaRepository>(),
      getIt<PreferencesRepository>(),
      getIt<DeviceInfoRepository>(),
      getIt<WatchOllamaModelsUseCase>(),
      getIt<UpdateHostUseCase>(),
    ),
  );
}
