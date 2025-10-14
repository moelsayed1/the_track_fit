import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryGreen = Color(0xFFFF4A2A);
  static const Color primaryGreenLight = Color(0xFFF27660);

  // Gradient colors from splash screen
  static const Color splashLightGreen = Color(0xFFF27660);
  static const Color splashMediumGreen = Color(0xFFFF4A2A);
  static const Color splashDarkGreen = Color(0xFF912E1C);

  // Shadow colors
  static const Color shadowGreen = Color(0x1928A228);

  // Dark mode text colors (primary)
  static const Color white = Colors.white;
  static const Color black = Color(0xFF1E1E1E);
  static const Color gray = Color(0xFFB0B0B0); // Lighter gray for dark mode
  static const Color grayMedium = Color(0xFF9E9E9E);
  static const Color grayLight = Color(
    0x7FB0B0B0,
  ); // Lighter gray for dark mode
  static const Color darkGray = Color(
    0xFF6B7280,
  ); // Lighter dark gray for dark mode

  // Dark mode background colors (primary)
  static const Color background = Color(0xFF121212); // Dark background
  static const Color surface = Color(0xFF1E1E1E); // Dark surface
  static const Color surfaceVariant = Color(
    0xFF2C2C2C,
  ); // Slightly lighter surface

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment(0.00, 0.50),
    end: Alignment(1.00, 0.50),
    colors: [primaryGreen, primaryGreenLight],
  );

  static const LinearGradient onboardingOverlay = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x00121212), // Transparent dark background
      Color(0xFA121212), // Semi-transparent dark background
      Color(0xFF121212), // Solid dark background
    ],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [splashLightGreen, splashMediumGreen, splashDarkGreen],
    stops: [0.0, 0.5, 1.0],
  );

  // ignore: use_full_hex_values_for_flutter_colors
  static Color lightGreen = const Color(0xffd85cd65c);
}
