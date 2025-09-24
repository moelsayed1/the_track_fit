import 'question.dart';

class QuestionsResponse {
  final List<Question> data;
  final int status;
  final String message;

  QuestionsResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory QuestionsResponse.fromJson(Map<String, dynamic> json) {
    return QuestionsResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((question) => Question.fromJson(question))
          .toList() ?? [],
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((question) => question.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }

  // Helper methods to get specific questions
  Question? getQuestionByEnText(String enText) {
    try {
      return data.firstWhere((q) => q.enText.toLowerCase() == enText.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  Question? getQuestionById(int id) {
    try {
      return data.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get specific question types
  Question? get ageQuestion => getQuestionByEnText('Age');
  Question? get heightQuestion => getQuestionByEnText('Height');
  Question? get currentWeightQuestion => getQuestionByEnText('Current Weight');
  Question? get targetWeightQuestion => getQuestionByEnText('Target Weight');
  Question? get mainGoalQuestion => getQuestionByEnText('Main Goal');
  Question? get currentActivityLevelQuestion => getQuestionByEnText('Current Activity Level');
  Question? get preferredTrainingTypesQuestion => getQuestionByEnText('Preferred Training Types');
  Question? get availableEquipmentQuestion => getQuestionByEnText('Available Equipment');
  Question? get currentDietSystemQuestion => getQuestionByEnText('Current Diet System');
  Question? get healthStatusQuestion => getQuestionByEnText('Health Status');
  Question? get specialDietQuestion => getQuestionByEnText('Special Diet? (Describe)');
  Question? get currentOrPreviousInjuryQuestion => getQuestionByEnText('Current or Previous Injury? (Describe)');
  Question? get additionalGoalsQuestion => getQuestionByEnText('Additional Goals (Optional)');
}

