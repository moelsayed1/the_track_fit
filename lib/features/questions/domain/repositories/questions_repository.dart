import '../models/questions_response.dart';

abstract class QuestionsRepository {
  Future<QuestionsResponse> getAllQuestions();
}

