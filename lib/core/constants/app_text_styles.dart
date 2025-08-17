import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Heading styles
  static const TextStyle heading1 = TextStyle(
    color: AppColors.black,
    fontSize: 24,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    letterSpacing: 0.50,
  );
  
  static const TextStyle heading2 = TextStyle(
    color: AppColors.black,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: 'Poppins',
    letterSpacing: 0.50,
  );
  
  // Body text styles
  static const TextStyle bodyLarge = TextStyle(
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    height: 1.50,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    color: AppColors.gray,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    height: 1.50,
  );
  
  static const TextStyle bodySmall = TextStyle(
    color: AppColors.gray,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    height: 1.80,
  );
  
  // Button text styles
  static const TextStyle buttonPrimary = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    height: 1.50,
    letterSpacing: 0.50,
  );
  
  static const TextStyle buttonSecondary = TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: 'Poppins',
    height: 1.50,
    letterSpacing: 0.50,
  );
  
  // Special text styles
  static const TextStyle skipButton = TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    height: 1.50,
    letterSpacing: 0.50,
  );
  
  // Onboarding specific styles
  static const TextStyle onboardingTitle = TextStyle(
    color: AppColors.black,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: 'Poppins',
    letterSpacing: 0.50,
  );
  
  static const TextStyle onboardingDescription = TextStyle(
    color: AppColors.gray,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
    height: 1.80,
  );
}
