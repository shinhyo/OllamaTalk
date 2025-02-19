import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'theme_text.dart';

abstract final class AppTheme {
  static const _seedColor = Colors.lightBlue;

  static final _darkTextTheme = createTextTheme(isDark: true);
  static final TextTheme _lightTextTheme = createTextTheme(isDark: false);

  static final ThemeData light = _createThemeData(Brightness.light);
  static final dark = _createThemeData(Brightness.dark);

  static var lightSystemStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: light.colorScheme.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  static var darkSystemStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: dark.colorScheme.surface,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );

  static ThemeData _createThemeData(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final surfaceColor =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final textTheme = isDark ? _darkTextTheme : _lightTextTheme;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
      surface: surfaceColor,
    );

    final backgroundColor = isDark ? AppColors.backgroundDark : Colors.white;
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: GoogleFonts.notoSans().fontFamily,
      textTheme: textTheme,
      iconTheme: const IconThemeData(
        color: AppColors.grey,
      ),
      appBarTheme: AppBarTheme(color: backgroundColor),
      navigationRailTheme: NavigationRailThemeData(
        selectedIconTheme: IconThemeData(
          size: 20,
          color: isDark ? AppColors.textLight : AppColors.textDark,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 20,
          color: AppColors.grey,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        showDragHandle: true,
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
