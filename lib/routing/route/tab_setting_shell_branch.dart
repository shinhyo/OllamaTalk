part of '../router.dart';

const tabSettingShellBranch = TypedStatefulShellBranch(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TabSettingScreenRoute>(
      path: TabSettingScreenRoute.path,
    )
  ],
);

class TabSettingScreenRoute extends GoRouteData {
  const TabSettingScreenRoute();

  static const path = '/tab_setting';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TabSettingScreen();
  }
}
