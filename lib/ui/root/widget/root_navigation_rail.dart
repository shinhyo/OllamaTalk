import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/themes/icons.dart';
import '../../core/themes/theme_ext.dart';
import '../../core/widget/dragging_widget.dart';
import 'root_tab.dart';

class RootNavigationRail extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final bool isExpanded;

  static List<NavigationRailDestination>? _cachedList;

  static List<NavigationRailDestination> _buildList(BuildContext context) {
    _cachedList ??= RootTab.values.map(
      (tab) {
        return NavigationRailDestination(
          padding: const EdgeInsets.symmetric(vertical: 6),
          label: Text(tab.label),
          icon: context.icon(tab.icon),
        );
      },
    ).toList();
    return _cachedList!;
  }

  const RootNavigationRail({
    super.key,
    required this.navigationShell,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return DraggingWidget(
      child: NavigationRail(
        destinations: _buildList(context),
        selectedIndex: navigationShell.currentIndex,
        extended: isExpanded,
        minExtendedWidth: 180,
        minWidth: 70,
        onDestinationSelected: (index) {
          context.go(RootTab.values[index].path);
        },
        leading: GestureDetector(
          onTap: () => context.go(RootTab.home.path),
          child: Padding(
            padding: const EdgeInsets.only(top: 24 + 16, bottom: 24),
            child: context.icon(AppIcons.robot, size: 36),
          ),
        ),
        trailing: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildTrailing(context),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  _buildTrailing(BuildContext context) {
    return Row(
      children: [
        context.rippleCircle(
          child: context.icon(
            AppIcons.github,
          ),
          onTap: () async {
            await launchUrl(
              Uri.parse('https://github.com/shinhyo/OllamaTalk'),
              mode: LaunchMode.externalApplication,
            );
          },
        ),
      ],
    );
  }
}
