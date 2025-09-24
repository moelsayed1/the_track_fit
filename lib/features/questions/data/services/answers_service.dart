import 'dart:developer';

import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';

class AnswersService {
  static AnswersService? _instance;
  static ApiService? _apiService;
  
  AnswersService._();
  
  static AnswersService get instance {
    _instance ??= AnswersService._();
    return _instance!;
  }
  
  ApiService get _api {
    _apiService ??= ApiService();
    return _apiService!;
  }
  
  // Store answers as they are collected
  final Map<String, dynamic> _answers = {};
  
  /// Add an answer for a specific question
  void addAnswer(int questionId, dynamic value) {
    _answers['q_$questionId'] = value;
    log('AnswersService: Added answer for q_$questionId: $value');
  }
  
  /// Add multiple answers at once
  void addAnswers(Map<String, dynamic> answers) {
    _answers.addAll(answers);
    log('AnswersService: Added multiple answers: $answers');
  }
  
  /// Get all current answers
  Map<String, dynamic> get answers => Map.from(_answers);
  
  /// Get answer for a specific question
  dynamic getAnswer(int questionId) {
    return _answers['q_$questionId'];
  }
  
  /// Submit all answers to the API
  Future<Map<String, dynamic>> submitAnswers() async {
    try {
      log('AnswersService: Submitting answers: $_answers');
      
      final response = await _api.postForm(
        AppConstants.submitAnswersEndpoint,
        data: _answers,
      );
      
      log('AnswersService: Response status: ${response.statusCode}');
      log('AnswersService: Response data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('AnswersService: Answers submitted successfully');
        return response.data;
      } else {
        throw Exception('Failed to submit answers: ${response.statusCode}');
      }
    } catch (e) {
      log('AnswersService: Error submitting answers: $e');
      throw Exception('Error submitting answers: $e');
    }
  }
  
  /// Clear all answers (useful for testing or starting over)
  void clearAnswers() {
    _answers.clear();
    log('AnswersService: All answers cleared');
  }
  
  /// Check if all required questions are answered
  bool get isComplete {
    // Define required question IDs (you can customize this based on your requirements)
    const requiredQuestions = [27, 28, 29, 31, 32, 33, 34, 35, 36];
    
    for (final questionId in requiredQuestions) {
      if (!_answers.containsKey('q_$questionId')) {
        return false;
      }
    }
    return true;
  }
  
  /// Get completion percentage
  double get completionPercentage {
    const totalRequired = 9; // Number of required questions
    final answeredRequired = _answers.keys.where((key) => 
      key.startsWith('q_') && 
      int.tryParse(key.substring(2)) != null &&
      [27, 28, 29, 31, 32, 33, 34, 35, 36].contains(int.parse(key.substring(2)))
    ).length;
    
    return (answeredRequired / totalRequired) * 100;
  }
}
