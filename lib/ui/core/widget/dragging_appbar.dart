import 'package:flutter/material.dart';

import '../../../utils/platform_util.dart';
import '../themes/theme_ext.dart';
import 'dragging_widget.dart';

class DraggingAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double _kDesktopExtraHeight = 24.0;

  final String _label;
  final Widget? _title;
  final List<Widget>? _actions;

  const DraggingAppBar({
    super.key,
    String label = '',
    Widget? title,
    Widget? leading,
    List<Widget>? actions,
    double? toolbarHeight,
    EdgeInsets? padding,
  })  : _actions = actions,
        _title = title,
        _label = label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (PlatformUtils.isDesktop) Container(height: _kDesktopExtraHeight),
        AppBar(
          toolbarHeight: kToolbarHeight,
          actions: _actions,
          scrolledUnderElevation: 0,
          elevation: 0,
          centerTitle: true,
          title: DraggingWidget(
            child: _title ??
                Text(
                  _label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: context.textTheme.titleMedium,
                ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        PlatformUtils.isDesktop
            ? kToolbarHeight + _kDesktopExtraHeight
            : kToolbarHeight,
      );
}
