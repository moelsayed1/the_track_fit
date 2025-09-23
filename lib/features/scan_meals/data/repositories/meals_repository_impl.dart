import 'dart:developer';

import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import '../../domain/models/meals_response.dart';
import '../../domain/repositories/meals_repository.dart';

class MealsRepositoryImpl implements MealsRepository {
  final ApiService _apiService;

  MealsRepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<MealsResponse> getMealsByDay(int dayId) async {
    try {
      log('Fetching meals for day ID: $dayId');
      
      final response = await _apiService.postForm(
        AppConstants.getMealsByDayEndpoint,
        data: {'day_id': dayId},
      );

      log('Meals API response status: ${response.statusCode}');
      log('Meals API response data: ${response.data}');

      if (response.statusCode == 200) {
        final mealsResponse = MealsResponse.fromJson(response.data);
        log('Successfully loaded ${mealsResponse.data.length} meal categories');
        return mealsResponse;
      } else {
        throw Exception('Failed to load meals: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching meals: $e');
      throw Exception('Error fetching meals: $e');
    }
  }
}
