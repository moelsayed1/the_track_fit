import 'dart:developer';
import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/features/questions/main_goal/domain/models/main_goal_response.dart';

class MainGoalRepository {
  final ApiService _apiService = ApiService();

  Future<MainGoalResponse> getMainGoalOptions() async {
    try {
      log('MainGoalRepository: Getting main goal options');
      
      final response = await _apiService.get(AppConstants.mainGoalOptionEndpoint);
      
      log('MainGoalRepository: Response status: ${response.statusCode}');
      log('MainGoalRepository: Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        return MainGoalResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load main goal options: ${response.statusCode}');
      }
    } catch (e) {
      log('MainGoalRepository: Error getting main goal options: $e');
      rethrow;
    }
  }
}
