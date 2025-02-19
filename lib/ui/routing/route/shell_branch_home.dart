part of '../router.dart';

const homeShellBranch = TypedStatefulShellBranch(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<HomeScreenRoute>(
      path: HomeScreenRoute.path,
      routes: [
        TypedGoRoute<ChatScreenRoute>(
          path: ChatScreenRoute.path,
        ),
      ],
    ),
  ],
);

class HomeScreenRoute extends GoRouteData {
  const HomeScreenRoute();

  static const path = '/';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}
