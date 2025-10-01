import 'package:translator/translator.dart';
import 'language_service.dart';

class TranslationService {
  static final TranslationService _instance = TranslationService._internal();
  factory TranslationService() => _instance;
  TranslationService._internal();

  final GoogleTranslator _translator = GoogleTranslator();

  /// Get localized value based on current app language
  /// Returns Arabic text if current language is Arabic, English text if current language is English
  Future<String> getLocalizedValue(String? arValue, String? enValue, String currentLang) async {
    try {
      // If current language is Arabic
      if (currentLang == 'ar') {
        // Always translate English to Arabic for better translation quality
        if (enValue != null && enValue.trim().isNotEmpty) {
          final translation = await _translator.translate(enValue.trim(), from: 'en', to: 'ar');
          return translation.text;
        }

        // If English value is not available, use Arabic value as fallback
        if (arValue != null && arValue.trim().isNotEmpty) {
          return arValue.trim();
        }

        // If both are null or empty, return empty string
        return '';
      } 
      // If current language is English
      else {
        // Always use English value directly
        return enValue?.trim() ?? '';
      }
    } catch (e) {
      // If translation fails, return Arabic value as fallback for Arabic, English for English
      if (currentLang == 'ar') {
        return arValue?.trim() ?? enValue?.trim() ?? '';
      } else {
        return enValue?.trim() ?? '';
      }
    }
  }

  /// Get localized value using current app language from LanguageService
  Future<String> getLocalizedValueAuto(String? arValue, String? enValue) async {
    final currentLang = LanguageService.instance.currentLanguage;
    return await getLocalizedValue(arValue, enValue, currentLang);
  }

  /// Get translated value - returns Arabic text (direct from backend if exists, otherwise translated)
  /// This method is kept for backward compatibility
  Future<String> getTranslatedValue(String? arValue, String? enValue) async {
    return await getLocalizedValueAuto(arValue, enValue);
  }

  /// Translate a single text from English to Arabic
  Future<String> translateToArabic(String englishText) async {
    try {
      if (englishText.trim().isEmpty) return '';
      
      final translation = await _translator.translate(englishText.trim(), from: 'en', to: 'ar');
      return translation.text;
    } catch (e) {
      // If translation fails, return original text
      return englishText.trim();
    }
  }

  /// Translate a single text from Arabic to English
  Future<String> translateToEnglish(String arabicText) async {
    try {
      if (arabicText.trim().isEmpty) return '';
      
      final translation = await _translator.translate(arabicText.trim(), from: 'ar', to: 'en');
      return translation.text;
    } catch (e) {
      // If translation fails, return original text
      return arabicText.trim();
    }
  }

  /// Batch translate multiple texts
  Future<List<String>> translateBatch(List<String> texts, {String from = 'en', String to = 'ar'}) async {
    try {
      final List<String> results = [];
      
      for (String text in texts) {
        if (text.trim().isEmpty) {
          results.add('');
          continue;
        }
        
        try {
          final translation = await _translator.translate(text.trim(), from: from, to: to);
          results.add(translation.text);
        } catch (e) {
          // If individual translation fails, use original text
          results.add(text.trim());
        }
      }
      
      return results;
    } catch (e) {
      // If batch translation fails, return original texts
      return texts.map((text) => text.trim()).toList();
    }
  }
}
