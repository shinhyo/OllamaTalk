import 'dart:async';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talker_bloc_logger/talker_bloc_logger_observer.dart';
import 'package:window_manager/window_manager.dart';

import 'config/build_config.dart';
import 'config/dependencies.dart';
import 'i18n/strings.g.dart';
import 'main_viewmodel.dart';
import 'ui/core/themes/theme.dart';
import 'ui/routing/router.dart';
import 'utils/logger.dart';
import 'utils/platform_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDataInject();
  await setupGlobalSettings();

  runApp(
    DevicePreview(
      enabled: BuildConfig.isPreview,
      builder: (context) => const MainApp(),
    ),
  );
}

Future<void> setupGlobalSettings() async {
  await LocaleSettings.useDeviceLocale();

  Bloc.observer = TalkerBlocObserver(
    talker: getIt<Logger>().talker,
  );

  await _initWindowOption();
}

Future<void> _initWindowOption() async {
  if (!PlatformUtils.isDesktop) return;

  await windowManager.ensureInitialized();
  unawaited(
    windowManager.waitUntilReadyToShow(
      WindowOptions(
        size: const Size(1024, 768),
        minimumSize: const Size(420, 400),
        titleBarStyle:
            Platform.isWindows ? TitleBarStyle.normal : TitleBarStyle.hidden,
        backgroundColor: Colors.transparent,
        windowButtonVisibility: true,
        title: t.common.appName,
      ),
      () async {
        await windowManager.show();
        await windowManager.focus();
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AppViewModel>(),
      child: BlocBuilder<AppViewModel, UiState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            builder: BotToastInit(),
            themeMode: context.read<AppViewModel>().state.themeMode,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
