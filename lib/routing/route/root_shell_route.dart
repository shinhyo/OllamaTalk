part of '../router.dart';

@TypedStatefulShellRoute<RootPageShellRoute>(
  branches: [
    tabModelShellBranch,
    tabChatShellBranch,
    tabSettingShellBranch,
  ],
)
class RootPageShellRoute extends StatefulShellRouteData {
  const RootPageShellRoute();

  static DateTime? _lastBackPressTime;

  Future<bool> _handleBackPress(
      BuildContext context, StatefulNavigationShell navigationShell) async {
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
        const SnackBar(
          content: Text('Press back again to exit the app.'),
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
