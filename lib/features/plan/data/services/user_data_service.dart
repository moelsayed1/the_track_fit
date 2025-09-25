import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/features/auth/data/cubit/auth_cubit.dart';
import 'package:the_track_fit/features/auth/data/cubit/auth_states.dart';
import 'package:the_track_fit/features/questions/data/services/answers_service.dart';

class UserDataService {
  static UserDataService? _instance;
  
  UserDataService._();
  
  static UserDataService get instance {
    _instance ??= UserDataService._();
    return _instance!;
  }
  
  final AnswersService _answersService = AnswersService.instance;
  
  /// Get complete user data including profile and answers
  Map<String, dynamic> getUserData(BuildContext context) {
    try {
      // Get user profile data from AuthCubit
      final authState = context.read<AuthCubit>().state;
      String name = '';
      String email = '';
      String phone = '';
      String gender = '';
      
      if (authState is AuthUserAlreadyLoggedIn) {
        name = authState.name;
        email = authState.email;
        phone = authState.phone ?? '';
        gender = authState.gender ?? '';
      } else if (authState is AuthUserProfileLoaded) {
        name = authState.name;
        email = authState.email;
        phone = authState.phone ?? '';
        gender = authState.gender ?? '';
      }
      
      // Get user answers data
      final answers = _answersService.answers;
      
      // Extract specific data from answers
      String age = _extractAnswer(answers, 'Age') ?? '';
      String height = _extractAnswer(answers, 'Height') ?? '';
      String currentWeight = _extractAnswer(answers, 'Current Weight') ?? '';
      String targetWeight = _extractAnswer(answers, 'Target Weight') ?? '';
      String mainGoal = _extractAnswer(answers, 'Main Goal') ?? '';
      String activityLevel = _extractAnswer(answers, 'Current Activity Level') ?? '';
      String trainingTypes = _extractAnswer(answers, 'Preferred Training Types') ?? '';
      String equipment = _extractAnswer(answers, 'Available Equipment') ?? '';
      String dietSystem = _extractAnswer(answers, 'Current Diet System') ?? '';
      String healthStatus = _extractAnswer(answers, 'Health Status') ?? '';
      String specialDiet = _extractAnswer(answers, 'Special Diet? (Describe)') ?? '';
      String injury = _extractAnswer(answers, 'Current or Previous Injury? (Describe)') ?? '';
      String additionalGoals = _extractAnswer(answers, 'Additional Goals (Optional)') ?? '';
      
      final userData = {
        // Basic profile data
        'name': name,
        'email': email,
        'phone': phone,
        'gender': gender,
        
        // Physical data
        'age': age,
        'height': height,
        'current_weight': currentWeight,
        'target_weight': targetWeight,
        
        // Goals and preferences
        'main_goal': mainGoal,
        'additional_goals': additionalGoals,
        'activity_level': activityLevel,
        'training_types': trainingTypes,
        'equipment': equipment,
        'diet_system': dietSystem,
        
        // Health data
        'health_status': healthStatus,
        'special_diet': specialDiet,
        'injury': injury,
        
        // All answers for reference
        'all_answers': answers,
      };
      
      log('UserDataService: Retrieved user data: ${userData.keys.toList()}');
      return userData;
    } catch (e) {
      log('UserDataService: Error getting user data: $e');
      return {
        'name': '',
        'email': '',
        'phone': '',
        'gender': '',
        'age': '',
        'height': '',
        'current_weight': '',
        'target_weight': '',
        'main_goal': '',
        'additional_goals': '',
        'activity_level': '',
        'training_types': '',
        'equipment': '',
        'diet_system': '',
        'health_status': '',
        'special_diet': '',
        'injury': '',
        'all_answers': {},
      };
    }
  }
  
  /// Extract answer value from answers map by question text
  String? _extractAnswer(Map<String, dynamic> answers, String questionText) {
    try {
      // Look for answers that might contain the question text
      for (final entry in answers.entries) {
        final value = entry.value;
        if (value is String && value.isNotEmpty) {
          // This is a simple string answer
          return value;
        } else if (value is List && value.isNotEmpty) {
          // This is a list answer (multi-select)
          return value.join(', ');
        }
      }
      return null;
    } catch (e) {
      log('UserDataService: Error extracting answer for $questionText: $e');
      return null;
    }
  }
  
  /// Get user data for subscription (basic info only)
  Map<String, dynamic> getSubscriptionUserData(BuildContext context) {
    final userData = getUserData(context);
    return {
      'name': userData['name'] ?? '',
      'email': userData['email'] ?? '',
      'phone': userData['phone'] ?? '',
      'gender': userData['gender'] ?? '',
    };
  }
  
  /// Get complete user data for subscription (including all profile and answers)
  Map<String, dynamic> getCompleteUserData(BuildContext context) {
    return getUserData(context);
  }
}
