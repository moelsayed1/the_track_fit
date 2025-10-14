import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_colors.dart';
import '../bloc/language/language_bloc.dart';

class AppTextStyles {
  // Helper method to get localized font family
  static String _getFontFamily(BuildContext context) {
    final languageState = context.read<LanguageBloc>().state;
    if (languageState is LanguageLoaded) {
      return languageState.currentLanguage == 'ar' ? 'Cairo' : 'Poppins';
    }
    return 'Poppins'; // Default to Poppins
  }

  // Heading styles
  static TextStyle heading1(BuildContext context) => TextStyle(
    color: AppColors.white,
    fontSize: 24,
    fontFamily: _getFontFamily(context),
    fontWeight: FontWeight.w700,
    letterSpacing: 0.50,
  );

  static TextStyle heading2(BuildContext context) => TextStyle(
    color: AppColors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: _getFontFamily(context),
    letterSpacing: 0.50,
  );

  // Body text styles
  static TextStyle bodyLarge(BuildContext context) => TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: _getFontFamily(context),
    height: 1.50,
  );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    color: AppColors.white,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: _getFontFamily(context),
    height: 1.50,
  );

  static TextStyle bodySmall(BuildContext context) => TextStyle(
    color: AppColors.white,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontFamily: _getFontFamily(context),
    height: 1.80,
  );

  // Button text styles
  static TextStyle buttonPrimary(BuildContext context) => TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: _getFontFamily(context),
    height: 1.50,
    letterSpacing: 0.50,
  );

  static TextStyle buttonSecondary(BuildContext context) => TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: _getFontFamily(context),
    height: 1.50,
    letterSpacing: 0.50,
  );

  // Special text styles
  static TextStyle skipButton(BuildContext context) => TextStyle(
    color: AppColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontFamily: _getFontFamily(context),
    height: 1.50,
    letterSpacing: 0.50,
  );

  // Onboarding specific styles
  static TextStyle onboardingTitle(BuildContext context) => TextStyle(
    color: AppColors.black,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontFamily: _getFontFamily(context),
    letterSpacing: 0.50,
  );

  static TextStyle onboardingDescription(BuildContext context) => TextStyle(
    color: AppColors.white,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    fontFamily: _getFontFamily(context),
    height: 1.80,
  );
}
