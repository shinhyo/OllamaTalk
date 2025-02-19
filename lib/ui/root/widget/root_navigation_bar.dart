import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/themes/theme_ext.dart';
import 'root_tab.dart';

class RootNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  static List<BottomNavigationBarItem>? _cachedItems;

  static List<BottomNavigationBarItem> _buildTabItems(BuildContext context) {
    _cachedItems ??= RootTab.values.map((tab) {
      return BottomNavigationBarItem(
        label: tab.label,
        icon: context.icon(tab.icon, size: 28),
      );
    }).toList();

    return _cachedItems!;
  }

  const RootNavigationBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _buildTabItems(context),
      currentIndex: navigationShell.currentIndex,
      onTap: (index) {
        context.go(RootTab.values[index].path);
      },
    );
  }
}
