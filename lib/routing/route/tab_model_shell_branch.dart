part of '../router.dart';

const tabModelShellBranch = TypedStatefulShellBranch(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TabModelScreenRoute>(
      path: TabModelScreenRoute.path,
    )
  ],
);

class TabModelScreenRoute extends GoRouteData {
  const TabModelScreenRoute();

  static const path = '/tab_model';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TabModelScreen();
  }
}
