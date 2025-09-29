import 'dart:developer';

import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import '../../domain/models/questions_response.dart';
import '../../domain/repositories/questions_repository.dart';

class QuestionsRepositoryImpl implements QuestionsRepository {
  final ApiService _apiService;

  QuestionsRepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<QuestionsResponse> getAllQuestions() async {
    try {
      log('QuestionsRepository: Getting all questions');
      
      final response = await _apiService.get(AppConstants.getQuestionsEndpoint);
      
      log('QuestionsRepository: Response status: ${response.statusCode}');
      log('QuestionsRepository: Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final questionsResponse = QuestionsResponse.fromJson(response.data);
        log('QuestionsRepository: Successfully loaded ${questionsResponse.data.length} questions');
        return questionsResponse;
      } else if (response.statusCode == 404) {
        log('QuestionsRepository: Questions endpoint not found (404)');
        throw Exception('Questions endpoint not found. Please check if the endpoint exists.');
      } else {
        log('QuestionsRepository: Failed to load questions with status: ${response.statusCode}');
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      log('QuestionsRepository: Error getting questions: $e');
      throw Exception('Error getting questions: $e');
    }
  }
}

