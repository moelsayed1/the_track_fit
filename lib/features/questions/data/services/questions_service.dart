import 'dart:developer';

import 'package:the_track_fit/core/services/api_service.dart';
import '../../data/repositories/questions_repository_impl.dart';
import '../../domain/models/questions_response.dart';
import '../../domain/models/question.dart';

class QuestionsService {
  static QuestionsService? _instance;
  static QuestionsRepositoryImpl? _repository;
  
  QuestionsService._();
  
  static QuestionsService get instance {
    _instance ??= QuestionsService._();
    return _instance!;
  }
  
  QuestionsRepositoryImpl get _questionsRepository {
    _repository ??= QuestionsRepositoryImpl(apiService: ApiService());
    return _repository!;
  }
  
  // Cache for questions data
  QuestionsResponse? _cachedQuestions;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 30);
  
  /// Get all questions with caching
  Future<QuestionsResponse> getAllQuestions({bool forceRefresh = false}) async {
    try {
      // Check if we have valid cached data
      if (!forceRefresh && 
          _cachedQuestions != null && 
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheExpiry) {
        log('QuestionsService: Returning cached questions');
        return _cachedQuestions!;
      }
      
      log('QuestionsService: Fetching fresh questions data');
      final questions = await _questionsRepository.getAllQuestions();
      
      // Update cache
      _cachedQuestions = questions;
      _lastFetchTime = DateTime.now();
      
      return questions;
    } catch (e) {
      log('QuestionsService: Error getting questions: $e');
      
      // Return cached data if available, even if expired
      if (_cachedQuestions != null) {
        log('QuestionsService: Returning expired cached data due to error');
        return _cachedQuestions!;
      }
      
      rethrow;
    }
  }
  
  /// Get a specific question by English text
  Future<Question?> getQuestionByEnText(String enText) async {
    try {
      final questions = await getAllQuestions();
      return questions.getQuestionByEnText(enText);
    } catch (e) {
      log('QuestionsService: Error getting question by enText: $e');
      return null;
    }
  }
  
  /// Get a specific question by ID
  Future<Question?> getQuestionById(int id) async {
    try {
      final questions = await getAllQuestions();
      return questions.getQuestionById(id);
    } catch (e) {
      log('QuestionsService: Error getting question by ID: $e');
      return null;
    }
  }
  
  /// Get age question specifically
  Future<Question?> getAgeQuestion() async {
    return await getQuestionByEnText('Age');
  }
  
  /// Get height question specifically
  Future<Question?> getHeightQuestion() async {
    return await getQuestionByEnText('Height');
  }
  
  /// Get current weight question specifically
  Future<Question?> getCurrentWeightQuestion() async {
    return await getQuestionByEnText('Current Weight');
  }
  
  /// Get target weight question specifically
  Future<Question?> getTargetWeightQuestion() async {
    return await getQuestionByEnText('Target Weight');
  }
  
  /// Get main goal question specifically
  Future<Question?> getMainGoalQuestion() async {
    return await getQuestionByEnText('Main Goal');
  }
  
  /// Get current activity level question specifically
  Future<Question?> getCurrentActivityLevelQuestion() async {
    return await getQuestionByEnText('Current Activity Level');
  }
  
  /// Get preferred training types question specifically
  Future<Question?> getPreferredTrainingTypesQuestion() async {
    return await getQuestionByEnText('Preferred Training Types');
  }
  
  /// Get available equipment question specifically
  Future<Question?> getAvailableEquipmentQuestion() async {
    return await getQuestionByEnText('Available Equipment');
  }
  
  /// Get current diet system question specifically
  Future<Question?> getCurrentDietSystemQuestion() async {
    return await getQuestionByEnText('Current Diet System');
  }
  
  /// Get health status question specifically
  Future<Question?> getHealthStatusQuestion() async {
    return await getQuestionByEnText('Health Status');
  }
  
  /// Get special diet question specifically
  Future<Question?> getSpecialDietQuestion() async {
    return await getQuestionByEnText('Special Diet? (Describe)');
  }
  
  /// Get current or previous injury question specifically
  Future<Question?> getCurrentOrPreviousInjuryQuestion() async {
    return await getQuestionByEnText('Current or Previous Injury? (Describe)');
  }
  
  /// Get additional goals question specifically
  Future<Question?> getAdditionalGoalsQuestion() async {
    return await getQuestionByEnText('Additional Goals (Optional)');
  }
  
  /// Clear cache (useful for testing or when data needs to be refreshed)
  void clearCache() {
    _cachedQuestions = null;
    _lastFetchTime = null;
    log('QuestionsService: Cache cleared');
  }
}
