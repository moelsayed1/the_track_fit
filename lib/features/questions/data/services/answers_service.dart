import 'dart:developer';

import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';

/// Service to manage questionnaire answers
/// 
/// Supports both single-value questions (radio, text) and multi-select questions (checkbox)
/// 
/// Usage examples:
/// 
/// Single value questions:
/// ```dart
/// AnswersService.instance.addAnswer(28, "Male"); // Gender
/// AnswersService.instance.addAnswer(29, "25"); // Age
/// ```
/// 
/// Multi-select questions:
/// ```dart
/// AnswersService.instance.addMultiSelectAnswer(35, ["Resistance Training", "HIIT"]); // Training Types
/// AnswersService.instance.addMultiSelectAnswer(36, ["Dumbbells", "Resistance Bands"]); // Equipment
/// ```
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
  void addAnswer(int questionId, dynamic value, {bool isMultiSelect = false}) {
    final key = 'q_$questionId';

    if (isMultiSelect) {
      // Initialize list if not exists
      if (_answers[key] == null) {
        _answers[key] = <dynamic>[];
      }
      // Add the value if not already exists
      if (!_answers[key].contains(value)) {
        _answers[key].add(value);
      }
    } else {
      // Single value question (radio / text)
      _answers[key] = value;
    }

    log('AnswersService: Added answer for $key: ${_answers[key]}');
  }
  
  /// Add multiple answers at once
  void addAnswers(Map<String, dynamic> answers) {
    _answers.addAll(answers);
    log('AnswersService: Added multiple answers: $answers');
  }

  /// Add a list of answers for multi-select questions
  void addMultiSelectAnswer(int questionId, List<dynamic> values) {
    final key = 'q_$questionId';
    _answers[key] = values;
    log('AnswersService: Added multi-select answer for $key: $values');
  }

  /// Remove a value from multi-select answer
  void removeFromMultiSelectAnswer(int questionId, dynamic value) {
    final key = 'q_$questionId';
    if (_answers[key] is List) {
      (_answers[key] as List).remove(value);
      log('AnswersService: Removed $value from $key: ${_answers[key]}');
    }
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
      
      // Log each answer type for debugging
      _answers.forEach((key, value) {
        if (value is List) {
          log('AnswersService: Multi-select answer $key: $value (${value.runtimeType})');
        } else {
          log('AnswersService: Single answer $key: $value (${value.runtimeType})');
        }
      });
      
      // Try different methods based on backend requirements
      // Method 1: JSON (preferred for arrays)
      try {
        log('AnswersService: Trying JSON method...');
        final response = await _api.post(
          AppConstants.submitAnswersEndpoint,
          data: _answers, // Send as JSON
        );
        
        log('AnswersService: JSON Response status: ${response.statusCode}');
        log('AnswersService: JSON Response data: ${response.data}');
        
        if (response.statusCode == 200 || response.statusCode == 201) {
          log('AnswersService: Answers submitted successfully via JSON');
          return response.data;
        }
      } catch (e) {
        log('AnswersService: JSON method failed: $e');
      }
      
      // Method 2: Form data with comma-separated values
      log('AnswersService: Trying form data method...');
      final Map<String, dynamic> formData = {};
      _answers.forEach((key, value) {
        if (value is List) {
          // Convert list to comma-separated string
          formData[key] = value.join(',');
          log('AnswersService: Converted $key from list to string: ${formData[key]}');
        } else {
          formData[key] = value;
        }
      });
      
      final response = await _api.postForm(
        AppConstants.submitAnswersEndpoint,
        data: formData,
      );
      
      log('AnswersService: Form Response status: ${response.statusCode}');
      log('AnswersService: Form Response data: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        log('AnswersService: Answers submitted successfully via form data');
        return response.data;
      } else {
        throw Exception('Failed to submit answers: ${response.statusCode}');
      }
    } catch (e) {
      log('AnswersService: Error submitting answers: $e');
      throw Exception('Error submitting answers: $e');
    }
  }
  
  /// Submit answers as form data (alternative method for testing)
  Future<Map<String, dynamic>> submitAnswersAsFormData() async {
    try {
      log('AnswersService: Submitting answers as form data: $_answers');
      
      // Convert arrays to comma-separated strings for form data compatibility
      final Map<String, dynamic> formData = {};
      _answers.forEach((key, value) {
        if (value is List) {
          // Convert list to comma-separated string
          formData[key] = value.join(',');
          log('AnswersService: Converted $key from list to string: ${formData[key]}');
        } else {
          formData[key] = value;
        }
      });
      
      log('AnswersService: Form data prepared: $formData');
      
      // Use form data
      final response = await _api.postForm(
        AppConstants.submitAnswersEndpoint,
        data: formData,
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

  /// Submit answers with array notation (for backend compatibility)
  Future<Map<String, dynamic>> submitAnswersWithArrayNotation() async {
    try {
      log('AnswersService: Submitting answers with array notation: $_answers');
      
      // Convert arrays to array notation for form data
      final Map<String, dynamic> formData = {};
      _answers.forEach((key, value) {
        if (value is List) {
          // Add each item as separate parameter with array notation
          for (int i = 0; i < value.length; i++) {
            formData['$key[$i]'] = value[i];
          }
          log('AnswersService: Converted $key to array notation: ${value.length} items');
        } else {
          formData[key] = value;
        }
      });
      
      log('AnswersService: Form data with array notation: $formData');
      
      // Use form data
      final response = await _api.postForm(
        AppConstants.submitAnswersEndpoint,
        data: formData,
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
