import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/core/bloc/language/language_bloc.dart';

/// Helper class for managing fonts based on current language
class FontHelper {
  /// Get the appropriate font family based on current language
  static String getFontFamily(BuildContext context) {
    final languageState = context.read<LanguageBloc>().state;
    if (languageState is LanguageLoaded) {
      return languageState.currentLanguage == 'ar' ? 'Cairo' : 'Poppins';
    }
    return 'Poppins'; // Default to Poppins
  }

  /// Get the appropriate font family based on current language (watch version)
  static String getFontFamilyWatch(BuildContext context) {
    final languageState = context.watch<LanguageBloc>().state;
    if (languageState is LanguageLoaded) {
      return languageState.currentLanguage == 'ar' ? 'Cairo' : 'Poppins';
    }
    return 'Poppins'; // Default to Poppins
  }

  /// Create a TextStyle with appropriate font family
  static TextStyle createTextStyle(BuildContext context, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextDecoration? decoration,
    double? height,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: getFontFamilyWatch(context),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
      height: height,
      fontStyle: fontStyle,
    );
  }
}

/// Extension to easily get font family from context
extension FontFamilyExtension on BuildContext {
  String get fontFamily => FontHelper.getFontFamilyWatch(this);
  
  TextStyle get localizedTextStyle => FontHelper.createTextStyle(this);
}
