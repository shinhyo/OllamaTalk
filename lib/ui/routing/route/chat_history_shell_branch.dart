part of '../router.dart';

const chatHistoryShellBranch = TypedStatefulShellBranch(
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<ChatHistoryScreenRoute>(
      path: ChatHistoryScreenRoute.path,
      routes: [
        TypedGoRoute<ChatScreenRoute>(
          path: ChatScreenRoute.path,
        ),
      ],
    ),
  ],
);

class ChatHistoryScreenRoute extends GoRouteData {
  const ChatHistoryScreenRoute();

  static const path = '/history';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatHistoryScreen();
  }
}
