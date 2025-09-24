import 'question_option.dart';

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

  // Helper methods for different question types
  bool get isCheckbox => type == 'checkbox';
  bool get isRadio => type == 'radio';
  bool get isText => type == 'text';
  bool get isTextarea => type == 'textarea';
  bool get hasOptions => options != null && options!.isNotEmpty;
}

