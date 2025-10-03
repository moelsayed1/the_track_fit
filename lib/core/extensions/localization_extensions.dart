import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/language/language_bloc.dart';
import '../../generated/l10n/app_localizations.dart';

/// Extension to get font family based on current language
extension FontFamilyExtension on BuildContext {
  String get fontFamily {
    final languageState = watch<LanguageBloc>().state;
    final currentLanguage = languageState is LanguageLoaded 
        ? languageState.currentLanguage 
        : 'ar';
    return currentLanguage == 'ar' ? 'Cairo' : 'Poppins';
  }
}

/// Extension to get text direction based on current language
extension TextDirectionExtension on BuildContext {
  TextDirection get textDirection {
    final languageState = watch<LanguageBloc>().state;
    final currentLanguage = languageState is LanguageLoaded 
        ? languageState.currentLanguage 
        : 'ar';
    return currentLanguage == 'ar' ? TextDirection.rtl : TextDirection.ltr;
  }
}

/// Extension to get localized strings easily
extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

/// Extension to check if current language is Arabic
extension LanguageCheckExtension on BuildContext {
  bool get isArabic {
    final languageState = watch<LanguageBloc>().state;
    final currentLanguage = languageState is LanguageLoaded 
        ? languageState.currentLanguage 
        : 'ar';
    return currentLanguage == 'ar';
  }
}

/// Widget wrapper for automatic directionality
class DirectionalityWrapper extends StatelessWidget {
  final Widget child;
  
  const DirectionalityWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final currentLanguage = languageState is LanguageLoaded 
            ? languageState.currentLanguage 
            : 'ar';
        final textDirection = currentLanguage == 'ar' 
            ? TextDirection.rtl 
            : TextDirection.ltr;
        
        return Directionality(
          textDirection: textDirection,
          child: child,
        );
      },
    );
  }
}

/// Localized TextField widget
class LocalizedTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final bool enabled;
  
  const LocalizedTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final currentLanguage = languageState is LanguageLoaded 
            ? languageState.currentLanguage 
            : 'ar';
        final fontFamily = currentLanguage == 'ar' ? 'Cairo' : 'Poppins';
        final textDirection = currentLanguage == 'ar' 
            ? TextDirection.rtl 
            : TextDirection.ltr;
        
        return TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          maxLines: maxLines,
          enabled: enabled,
          textDirection: textDirection,
          style: TextStyle(fontFamily: fontFamily),
          decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            hintStyle: TextStyle(fontFamily: fontFamily),
            labelStyle: TextStyle(fontFamily: fontFamily),
          ),
        );
      },
    );
  }
}
