import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'colors.dart';
import 'icons.dart';

extension ThemeExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get color => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  Brightness get brightness => theme.brightness;

  bool get isDarkMode => brightness == Brightness.dark;

  SvgPicture icon(AppIcons appIcon, {double? size, Color? color}) {
    return SvgPicture.asset(
      appIcon.path,
      semanticsLabel: appIcon.name,
      width: size ?? 24,
      height: size ?? 24,
      colorFilter: ColorFilter.mode(
        color ?? AppColors.grey,
        BlendMode.srcIn,
      ),
    );
  }

  Material rippleCircle({
    required Widget child,
    final GestureTapCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          splashFactory: InkRipple.splashFactory,
          splashColor: color.primary.withValues(alpha: 0.3),
          highlightColor: color.primary.withValues(alpha: 0.15),
          radius: 20,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
