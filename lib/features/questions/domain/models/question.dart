import 'question_option.dart';
import 'package:the_track_fit/core/helpers/api_localization_helper.dart';
import 'package:the_track_fit/core/services/language_service.dart';

class Question {
  final int id;
  final String text;
  final String enText;
  final String type;
  final List<QuestionOption>? options;

  Question({
    required this.id,
    required this.text,
    required this.enText,
    required this.type,
    this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      enText: json['en_text'] ?? '',
      type: json['type'] ?? '',
      options: json['options'] != null
          ? (json['options'] as List<dynamic>)
              .map((option) => QuestionOption.fromJson(option))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'en_text': enText,
      'type': type,
      'options': options?.map((option) => option.toJson()).toList(),
    };
  }

  // Getter for localized text
  String get localizedText {
    final currentLang = LanguageService.instance.currentLanguage;
    return ApiLocalizationHelper.getLocalizedValueSync(text, enText, currentLang);
  }

  // Async getter for localized text with translation
  Future<String> get localizedTextAsync async {
    final currentLang = LanguageService.instance.currentLanguage;
    return await ApiLocalizationHelper.getLocalizedValue(text, enText, currentLang);
  }

  // Helper methods for different question types
  bool get isCheckbox => type == 'checkbox';
  bool get isRadio => type == 'radio';
  bool get isText => type == 'text';
  bool get isTextarea => type == 'textarea';
  bool get hasOptions => options != null && options!.isNotEmpty;
}

