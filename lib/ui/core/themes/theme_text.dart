import 'package:flutter/material.dart';

import 'colors.dart';

TextTheme createTextTheme({
  required bool isDark,
}) {
  final baseStyle = TextStyle(
    letterSpacing: 0,
    leadingDistribution: TextLeadingDistribution.even,
    color: isDark ? AppColors.textLight : AppColors.textDark,
  );

  return TextTheme(
    displayLarge: baseStyle.copyWith(
      fontSize: 36.0,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    displayMedium: baseStyle.copyWith(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    titleLarge: baseStyle.copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: baseStyle.copyWith(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: baseStyle.copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    ),
    headlineLarge: baseStyle.copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: baseStyle.copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: baseStyle.copyWith(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: baseStyle.copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: baseStyle.copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: baseStyle.copyWith(
      fontSize: 14.0,
    ),
    labelLarge: baseStyle.copyWith(
      fontSize: 15.0,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: baseStyle.copyWith(
      fontSize: 13.0,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: baseStyle.copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
    ),
  );
}
