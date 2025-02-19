import 'package:flutter/material.dart';

enum ScreenSize {
  compact(maxWidth: 600, spacing: 16),
  medium(maxWidth: 840, spacing: 24),
  expanded(maxWidth: double.infinity, spacing: 24);

  const ScreenSize({
    required this.maxWidth,
    required this.spacing,
  });

  final double maxWidth;
  final double spacing;

  static ScreenSize fromWidth(double width) {
    if (width < compact.maxWidth) return compact;
    if (width < medium.maxWidth) return medium;
    return expanded;
  }
}

extension SizeExt on Size {
  ScreenSize get screenSize => ScreenSize.fromWidth(width);

  double get spacing => screenSize.spacing;
}

extension BuildContextExt on BuildContext {
  Size get mediaSize => MediaQuery.sizeOf(this);

  ScreenSize get screenSize => mediaSize.screenSize;

  double get spacing => screenSize.spacing;

  bool get isCompact => screenSize == ScreenSize.compact;

  bool get isMedium => screenSize == ScreenSize.medium;

  bool get isExpanded => screenSize == ScreenSize.expanded;
}
