import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../i18n/strings.g.dart';
import '../../utils/logger.dart';
import '../chat/chat_screen.dart';
import '../root/root_screen.dart';
import '../tab/history/chat_history_screen.dart';
import '../tab/home/home_screen.dart';
import '../tab/setting/setting_screen.dart';

part 'route/chat_history_shell_branch.dart';

part 'route/shell_branch_home.dart';

part 'route/shell_branch_setting.dart';

part 'route/shell_route_root.dart';

part 'router.freezed.dart';

part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: rootNavigatorKey,
  initialLocation: HomeScreenRoute.path,
  routes: [
    ...$appRoutes,
  ],
  observers: [
    TalkerRouteObserver(GetIt.I<Logger>().talker),
    BotToastNavigatorObserver(),
  ],
);
