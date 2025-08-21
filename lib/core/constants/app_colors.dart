import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primaryGreen = Color(0xFF28A228);
  static const Color primaryGreenLight = Color(0xD85CD65C);
  
  // Gradient colors from splash screen
  static const Color splashLightGreen = Color(0xFF9CFF9C);
  static const Color splashMediumGreen = Color(0xFF48C848);
  static const Color splashDarkGreen = Color(0xFF0E540E);
  
  // Shadow colors
  static const Color shadowGreen = Color(0x1928A228);
  
  // Text colors
  static const Color white = Colors.white;
  static const Color black = Color(0xFF1E1E1E);
  static const Color gray = Color(0xFF848484);
  static const Color grayMedium = Color(0xFF848484);
  static const Color grayLight = Color(0x7F848484);
  static const Color darkGray = Color(0xFF374151);
  
  // Background colors
  static const Color background = Colors.white;
  
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
      Color(0x00FFFFFF),  // #FFFFFF00
      Color(0xFAFFFFFF),  // #FFFFFFFA
      Color(0xFFFFFFFF),  // #FFFFFF
    ],
  );
  
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      splashLightGreen,
      splashMediumGreen,
      splashDarkGreen,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  
} 