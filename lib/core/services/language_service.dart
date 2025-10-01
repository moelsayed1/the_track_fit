import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LanguageService {
  static const String _languageKey = 'selected_language';
  static LanguageService? _instance;
  static LanguageService get instance => _instance ??= LanguageService._();
  
  LanguageService._();
  
  String _currentLanguage = AppConstants.defaultLanguage;
  String get currentLanguage => _currentLanguage;
  
  Locale get currentLocale => Locale(_currentLanguage);
  
  List<Locale> get supportedLocales => [
    const Locale('en', 'US'),
    const Locale('ar', 'SA'),
  ];
  
  /// Initialize the language service
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? AppConstants.defaultLanguage;
  }
  
  /// Change the app language
  Future<void> changeLanguage(String languageCode) async {
    if (!AppConstants.supportedLanguages.contains(languageCode)) {
      throw ArgumentError('Unsupported language: $languageCode');
    }
    
    _currentLanguage = languageCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
  
  /// Get language-specific API endpoint
  String getEndpointWithLanguage(String endpoint) {
    return AppConstants.getEndpointWithLanguage(endpoint, _currentLanguage);
  }
  
  /// Check if current language is Arabic
  bool get isArabic => _currentLanguage == AppConstants.arabicLanguage;
  
  /// Check if current language is English
  bool get isEnglish => _currentLanguage == AppConstants.englishLanguage;
  
  /// Get language name for display
  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      default:
        return languageCode;
    }
  }
  
  /// Get language code from name
  String getLanguageCode(String languageName) {
    switch (languageName.toLowerCase()) {
      case 'english':
        return 'en';
      case 'العربية':
      case 'arabic':
        return 'ar';
      default:
        return 'en';
    }
  }
  
  /// Get text direction for current language
  TextDirection get textDirection {
    return isArabic ? TextDirection.rtl : TextDirection.ltr;
  }
  
  /// Get alignment for current language
  Alignment get alignment {
    return isArabic ? Alignment.centerRight : Alignment.centerLeft;
  }
  
  /// Get cross axis alignment for current language
  CrossAxisAlignment get crossAxisAlignment {
    return isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start;
  }
  
  /// Get main axis alignment for current language
  MainAxisAlignment get mainAxisAlignment {
    return isArabic ? MainAxisAlignment.end : MainAxisAlignment.start;
  }
}
