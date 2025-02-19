import '../../core/themes/icons.dart';
import '../../routing/router.dart';
import '../../tab/history/chat_history_screen.dart';
import '../../tab/home/home_screen.dart';
import '../../tab/setting/setting_screen.dart';

enum RootTab {
  home(
    label: HomeScreen.label,
    path: HomeScreenRoute.path,
    icon: AppIcons.chat,
  ),
  history(
    label: ChatHistoryScreen.label,
    path: ChatHistoryScreenRoute.path,
    icon: AppIcons.history,
  ),
  setting(
    label: SettingScreen.label,
    path: SettingScreenRoute.path,
    icon: AppIcons.dotsHorizontal,
  );

  final String path;
  final String label;
  final AppIcons icon;

  const RootTab({
    required this.path,
    required this.label,
    required this.icon,
  });
}
