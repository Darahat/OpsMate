import 'package:flutter/material.dart';

class AppColor {
  static const Color primary = Color(0xFF243363); // Your base color
  static const Color accent = Color(0xFF5164FC); // Button background
  static const Color background = Color(0xFFF8F9FD); // Light background
  static const Color textPrimary = Color(
    0xFF1C1C1C,
  ); // Kept same for readability
  static const Color textSecondary = Color(
    0xFF5A5A5A,
  ); // Slightly darker for better contrast
  static const Color buttonText = Colors.white; // Button text color
  static const Color surface = Color(0xFFF1F3F9); // For cards/surfaces
  // If you need darker/lighter variants of your base color:
  static const Color primaryDark = Color(0xFF1A254D);
  static const Color primaryLight = Color(0xFF3D4B82);
  static const Color accentLight = Color(0xFF7D89FD);
  static const Color accentDark = Color(0xFF3A4EF2);
  // If you need accent color variants:
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkAppBar = Color(0xFF1A1A1A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(
    0xFFB0B0B0,
  ); // For dark mode buttons
}
