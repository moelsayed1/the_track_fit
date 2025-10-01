import 'package:the_track_fit/core/helpers/api_localization_helper.dart';
import 'package:the_track_fit/core/services/language_service.dart';

class QuestionOption {
  final String ar;
  final String en;

  QuestionOption({
    required this.ar,
    required this.en,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      ar: json['ar'] ?? '',
      en: json['en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ar': ar,
      'en': en,
    };
  }

  // Getter for localized text
  String get localizedText {
    final currentLang = LanguageService.instance.currentLanguage;
    return ApiLocalizationHelper.getLocalizedValueSync(ar, en, currentLang);
  }

  // Async getter for localized text with translation
  Future<String> get localizedTextAsync async {
    final currentLang = LanguageService.instance.currentLanguage;
    return await ApiLocalizationHelper.getLocalizedValue(ar, en, currentLang);
  }
}

