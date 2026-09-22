import 'package:flutter/material.dart';

/// Color roles, straight from the Cookie Bites Color Palette table.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF5D6D0A); // Olive Green
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF644619); // Cookie Brown
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF6EEE2); // cream background
  static const Color onSurface = Color(0xFF41403E); // dark gray body text
  static const Color error = Color(0xFFBA1A1A);
}

/// Spacing scale from the Spacing Rule section.
class AppSpacing {
  AppSpacing._();

  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
}

/// Type scale: Darumadrop One for the logo/branding, Inter for all UI text.
class AppTextStyles {
  AppTextStyles._();

  static const String logoFontFamily = 'DarumadropOne';
  static const String uiFontFamily = 'Inter';

  static TextStyle get logo => const TextStyle(fontFamily: logoFontFamily);

  static TextStyle heading() => const TextStyle(
        fontFamily: uiFontFamily,
        fontSize: 24, // headlineSmall
        fontWeight: FontWeight.bold,
        color: AppColors.onSurface,
      );

static TextStyle body() => const TextStyle(
        fontFamily: uiFontFamily,
        fontSize: 16, // bodyMedium
        fontWeight: FontWeight.normal,
        color: AppColors.onSurface,
      );

  static TextStyle caption() => TextStyle(
        fontFamily: uiFontFamily,
        fontSize: 12, // labelSmall
        fontWeight: FontWeight.normal,
        color: AppColors.onSurface.withOpacity(0.7),
      );
}


ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: AppTextStyles.uiFontFamily,
  );
}
