part of '../router.dart';

const tabChatShellBranch = TypedStatefulShellBranch(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<TabChatScreenRoute>(
      path: TabChatScreenRoute.path,
    )
  ],
);

class TabChatScreenRoute extends GoRouteData {
  const TabChatScreenRoute();

  static const path = '/tab_chat';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TabChatScreen();
  }
}
