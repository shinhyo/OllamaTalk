import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'root_tab.dart';

class RootNavigationBar extends StatelessWidget {
  const RootNavigationBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      useLegacyColorScheme: false,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: RootTab.values.map((tab) {
        final isSelected =
            RootTab.values.indexOf(tab) == navigationShell.currentIndex;
        return BottomNavigationBarItem(
          label: tab.label,
          icon: isSelected ? tab.icon : tab.iconOutline,
        );
      }).toList(),
      currentIndex: navigationShell.currentIndex,
      onTap: (index) {
        context.go(RootTab.values[index].path);
      },
    );
  }
}
