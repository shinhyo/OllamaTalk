import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../config/dependencies.dart';
import '../../utils/size_ext.dart';
import '../core/base/base_command.dart';
import '../core/themes/theme.dart';
import '../core/widget/dragging_appbar.dart';
import 'root_viewmodel.dart';
import 'widget/root_navigation_bar.dart';
import 'widget/root_navigation_rail.dart';
import 'widget/root_tab.dart';

class RootScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const RootScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RootViewModel>(),
      child: BlocConsumer<RootViewModel, RootUiState>(
        listenWhen: (previous, current) =>
            previous.command != current.command && current.command != null,
        listener: (context, state) {
          _handleCommand(state.command!);
          context.read<RootViewModel>().clearCommand();
        },
        builder: (context, state) {
          final screenSize = context.screenSize;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: _getSystemUiOverlayStyle(state.themeMode),
            child: Scaffold(
              appBar: _buildAppbar(screenSize),
              body: _buildBody(screenSize),
              bottomNavigationBar: _buildBottomNavigationBar(screenSize),
            ),
          );
        },
      ),
    );
  }

  SystemUiOverlayStyle _getSystemUiOverlayStyle(ThemeMode? themeMode) {
    switch (themeMode) {
      case null:
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness == Brightness.light
            ? AppTheme.lightSystemStyle
            : AppTheme.darkSystemStyle;
      case ThemeMode.light:
        return AppTheme.lightSystemStyle;
      case ThemeMode.dark:
        return AppTheme.darkSystemStyle;
    }
  }

  void _handleCommand(UICommand command) {
    switch (command) {
      case ShowToastCommand(:final message, :final duration):
        BotToast.showText(
          text: message,
          duration: duration,
          enableKeyboardSafeArea: true,
        );

      case ShowSnackBarCommand(:final message, :final duration, :final action):
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              duration: duration,
              action: action,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(8),
              dismissDirection: DismissDirection.horizontal,
            ),
          );
    }
  }

  PreferredSizeWidget? _buildAppbar(ScreenSize screenSize) {
    if (screenSize != ScreenSize.compact) return null;

    final tab = RootTab.values[widget.navigationShell.currentIndex];
    return DraggingAppBar(
      label: tab == RootTab.home ? '' : tab.label,
    );
  }

  Widget _buildBody(ScreenSize screenSize) {
    return switch (screenSize) {
      ScreenSize.compact => widget.navigationShell,
      _ => Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  RootNavigationRail(
                    navigationShell: widget.navigationShell,
                    isExpanded: screenSize == ScreenSize.expanded,
                  ),
                  const VerticalDivider(width: 0.2),
                  Expanded(child: widget.navigationShell),
                ],
              ),
            ),
          ],
        ),
    };
  }

  RootNavigationBar? _buildBottomNavigationBar(ScreenSize screenSize) {
    return screenSize == ScreenSize.compact
        ? RootNavigationBar(navigationShell: widget.navigationShell)
        : null;
  }
}
