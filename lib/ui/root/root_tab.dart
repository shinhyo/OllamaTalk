import 'package:flutter/material.dart';

import '../../routing/router.dart';
import '../tab_chat/tab_chat_screen.dart';
import '../tab_model/tab_model_screen.dart';
import '../tab_setting/tab_setting_screen.dart';

enum RootTab {
  note(
    label: TabModelScreen.label,
    path: TabModelScreenRoute.path,
    icon: Icons.event_note,
    iconOutline: Icons.event_note_outlined,
    isBottomTab: true,
  ),
  store(
    label: TabChatScreen.label,
    path: TabChatScreenRoute.path,
    icon: Icons.category,
    iconOutline: Icons.category_outlined,
    isBottomTab: true,
  ),
  setting(
    label: TabSettingScreen.label,
    path: TabSettingScreenRoute.path,
    icon: Icons.menu,
    iconOutline: Icons.menu_outlined,
    isBottomTab: true,
  ),
  ;

  const RootTab({
    required this.path,
    required this.label,
    required IconData icon,
    required IconData iconOutline,
    this.isBottomTab = false,
  })  : _icon = icon,
        _iconOutline = iconOutline;

  final String path;
  final String label;
  final IconData _icon;
  final IconData _iconOutline;
  final bool isBottomTab;

  Icon get icon => Icon(_icon);

  Icon get iconOutline => Icon(_iconOutline);
}
