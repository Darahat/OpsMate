import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData lightTheme = ThemeData(
  primaryColor: AppColor.primary,
  scaffoldBackgroundColor: AppColor.background,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.primary,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: ColorScheme.light(
    primary: AppColor.primary,
    secondary: AppColor.accent,
    surface: AppColor.background,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColor.textPrimary,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColor.textPrimary),
    bodyMedium: TextStyle(color: AppColor.textSecondary),
  ),
  useMaterial3: true,
);
final ThemeData darkTheme = ThemeData(
  primaryColor: AppColor.primaryDark,
  scaffoldBackgroundColor: AppColor.darkBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColor.darkAppBar,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: ColorScheme.dark(
    primary: AppColor.accent,
    secondary: AppColor.accentLight,
    surface: AppColor.darkSurface,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: AppColor.darkTextPrimary,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColor.darkTextPrimary),
    bodyMedium: TextStyle(color: AppColor.darkTextSecondary),
  ),
  useMaterial3: true,
);
