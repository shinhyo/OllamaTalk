part of '../router.dart';

const settingShellBranch = TypedStatefulShellBranch(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<SettingScreenRoute>(
      path: SettingScreenRoute.path,
    ),
  ],
);

class SettingScreenRoute extends GoRouteData {
  const SettingScreenRoute();

  static const path = '/setting';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingScreen();
  }
}
