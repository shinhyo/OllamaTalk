import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';

import 'config/dependencies.dart';
import 'routing/router.dart';
import 'utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDataInject();

  setupGlobalSettings();

  runApp(const MainApp());
}

void setupGlobalSettings() {
  Bloc.observer = TalkerBlocObserver(
    talker: getIt<Logger>().talker,
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
