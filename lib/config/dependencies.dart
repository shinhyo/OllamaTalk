import 'package:get_it/get_it.dart';

import '../utils/logger.dart';

final getIt = GetIt.instance;

Future<void> initDataInject() async {
  getIt.registerLazySingleton<Logger>(() => Logger());
}
