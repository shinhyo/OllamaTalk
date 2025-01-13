import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../ui/root/root_screen.dart';
import '../ui/tab_chat/tab_chat_screen.dart';
import '../ui/tab_model/tab_model_screen.dart';
import '../ui/tab_setting/tab_setting_screen.dart';
import '../utils/logger.dart';

part 'route/root_shell_route.dart';
part 'route/tab_chat_shell_branch.dart';
part 'route/tab_model_shell_branch.dart';
part 'route/tab_setting_shell_branch.dart';
part 'router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter router = GoRouter(
  debugLogDiagnostics: kDebugMode,
  navigatorKey: rootNavigatorKey,
  initialLocation: TabModelScreenRoute.path,
  routes: [
    ...$appRoutes,
  ],
  observers: [
    TalkerRouteObserver(GetIt.I<Logger>().talker),
  ],
);
