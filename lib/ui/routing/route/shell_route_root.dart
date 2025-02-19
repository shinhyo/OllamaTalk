part of '../router.dart';

@TypedStatefulShellRoute<RootPageShellRoute>(
  branches: [
    homeShellBranch,
    chatHistoryShellBranch,
    settingShellBranch,
  ],
)
class RootPageShellRoute extends StatefulShellRouteData {
  const RootPageShellRoute();

  static DateTime? _lastBackPressTime;

  Future<bool> _handleBackPress(
    BuildContext context,
    StatefulNavigationShell navigationShell,
  ) async {
    if (defaultTargetPlatform != TargetPlatform.android) {
      return false;
    }

    if (context.canPop()) {
      context.pop();
      return true;
    }

    if (navigationShell.currentIndex != 0) {
      navigationShell.goBranch(0);
      return true;
    }

    final now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
      _lastBackPressTime = now;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.home.backExit),
        ),
      );
      return true;
    }

    return false;
  }

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return BackButtonListener(
      onBackButtonPressed: () => _handleBackPress(context, navigationShell),
      child: RootScreen(
        navigationShell: navigationShell,
      ),
    );
  }
}

@freezed
class ChatScreenParams with _$ChatScreenParams {
  const factory ChatScreenParams({
    @Default(null) int? id,
    @Default(null) String? model,
    @Default(null) String? mode,
    @Default(null) String? prompt,
    @Default(null) String? question,
  }) = _ChatScreenParams;
}

class ChatScreenRoute extends GoRouteData {
  final int? id;
  final String? model;
  final String? chatMode;
  final String? prompt;
  final String? question;

  const ChatScreenRoute({
    this.id,
    this.model,
    this.chatMode,
    this.prompt,
    this.question,
  });

  const ChatScreenRoute.loadHistory({
    this.id,
  })  : model = null,
        chatMode = null,
        prompt = null,
        question = null;

  static const path = '/chat';
  static final $parentNavigatorKey = rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatScreen(
      params: ChatScreenParams(
        id: id,
        model: model,
        mode: chatMode,
        prompt: prompt,
        question: question,
      ),
    );
  }
}
