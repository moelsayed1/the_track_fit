import 'dart:developer';

import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/features/workout/data/models/exercise_api_response.dart';
import 'package:the_track_fit/features/workout/data/models/exercise_category_api_response.dart';
import 'package:the_track_fit/features/workout/domain/models/exercise.dart';
import 'package:the_track_fit/features/workout/domain/models/workout_type.dart';

class ExerciseRepository {
  final ApiService _apiService;

  ExerciseRepository({required ApiService apiService}) : _apiService = apiService;

  /// Fetch all exercises from the API
  Future<List<Exercise>> getAllExercises() async {
    try {
      final response = await _apiService.get(
        AppConstants.getAllExercisesEndpoint,
      );

      if (response.statusCode == 200) {
        final exerciseApiResponse = ExerciseApiResponse.fromJson(response.data);
        
        // Convert API data to domain models
        final exercises = exerciseApiResponse.data.map((apiData) {
          return Exercise.fromApiData({
            'id': apiData.id,
            'ar_name': apiData.arName,
            'en_name': apiData.enName,
            'ar_description': apiData.arDescription,
            'en_description': apiData.enDescription,
            'gif': apiData.gif,
            'equipment': apiData.equipment,
            'gender': apiData.gender,
            'location': apiData.location,
            'goal': apiData.goal,
            'sets': apiData.sets,
            'reps': apiData.reps,
          });
        }).toList();

        return exercises;
      } else {
        throw Exception('Failed to load exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exercises: $e');
    }
  }

  /// Get exercises by category/type
  Future<List<Exercise>> getExercisesByType(String type) async {
    final allExercises = await getAllExercises();
    return allExercises.where((exercise) => exercise.type == type).toList();
  }

  /// Get exercises by location using API endpoint
  Future<List<Exercise>> getExercisesByLocation(String location) async {
    try {
      final response = await _apiService.get(
        AppConstants.getExercisesByLocationEndpoint,
        queryParameters: {
          'location': location,
        },
      );

      if (response.statusCode == 200) {
        final exerciseApiResponse = ExerciseApiResponse.fromJson(response.data);
        
        // Convert API data to domain models
        final exercises = exerciseApiResponse.data.map((apiData) {
          return Exercise.fromApiData({
            'id': apiData.id,
            'ar_name': apiData.arName,
            'en_name': apiData.enName,
            'ar_description': apiData.arDescription,
            'en_description': apiData.enDescription,
            'gif': apiData.gif,
            'equipment': apiData.equipment,
            'gender': apiData.gender,
            'location': apiData.location,
            'goal': apiData.goal,
            'sets': apiData.sets,
            'reps': apiData.reps,
          });
        }).toList();

        return exercises;
      } else {
        throw Exception('Failed to load exercises by location: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to local filtering if API fails
      final allExercises = await getAllExercises();
      return allExercises.where((exercise) => exercise.location == location).toList();
    }
  }

  /// Get exercises by equipment using API endpoint
  Future<List<Exercise>> getExercisesByEquipment(String equipment) async {
    try {
      final response = await _apiService.get(
        AppConstants.getExercisesByEquipmentEndpoint,
        queryParameters: {
          'equipment': equipment,
        },
      );

      if (response.statusCode == 200) {
        final exerciseApiResponse = ExerciseApiResponse.fromJson(response.data);
        
        // Convert API data to domain models
        final exercises = exerciseApiResponse.data.map((apiData) {
          return Exercise.fromApiData({
            'id': apiData.id,
            'ar_name': apiData.arName,
            'en_name': apiData.enName,
            'ar_description': apiData.arDescription,
            'en_description': apiData.enDescription,
            'gif': apiData.gif,
            'equipment': apiData.equipment,
            'gender': apiData.gender,
            'location': apiData.location,
            'goal': apiData.goal,
            'sets': apiData.sets,
            'reps': apiData.reps,
          });
        }).toList();

        return exercises;
      } else {
        throw Exception('Failed to load exercises by equipment: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to local filtering if API fails
      final allExercises = await getAllExercises();
      return allExercises.where((exercise) => exercise.equipment == equipment).toList();
    }
  }

  /// Search exercises by name or description
  Future<List<Exercise>> searchExercises(String query) async {
    final allExercises = await getAllExercises();
    final searchLower = query.toLowerCase();
    
    return allExercises.where((exercise) {
      return exercise.localizedName.toLowerCase().contains(searchLower) ||
             (exercise.localizedDescription.toLowerCase().contains(searchLower)) ||
             exercise.type.toLowerCase().contains(searchLower);
    }).toList();
  }

  /// Get exercises by day using API endpoint
  Future<List<Exercise>> getExercisesByDay(int dayId, {String? goal}) async {
    try {
      final Map<String, dynamic> requestData = {
        'day_id': dayId,
      };
      
      // Add goal parameter if provided
      if (goal != null) {
        requestData['goal'] = goal;
      }
      
      log('Making API call to: ${AppConstants.getExercisesByDayEndpoint}');
      log('Request data: $requestData');
      
      final response = await _apiService.post(
        AppConstants.getExercisesByDayEndpoint,
        data: requestData,
      );

      log('API Response Status: ${response.statusCode}');
      log('API Response Data: ${response.data}');

      if (response.statusCode == 200) {
        // Check if the response contains an error message
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          if (responseData.containsKey('message') && responseData['message'].toString().contains('No exercises found')) {
            log('API returned no exercises for this day and goal');
            return []; // Return empty list instead of throwing error
          }
        }
        
        final exerciseApiResponse = ExerciseApiResponse.fromJson(response.data);
        
        log('Parsed exercises count: ${exerciseApiResponse.data.length}');
        
        // Convert API data to domain models
        final exercises = exerciseApiResponse.data.map((apiData) {
          log('Processing exercise: ${apiData.enName}');
          return Exercise.fromApiData({
            'id': apiData.id,
            'ar_name': apiData.arName,
            'en_name': apiData.enName,
            'ar_description': apiData.arDescription,
            'en_description': apiData.enDescription,
            'gif': apiData.gif,
            'equipment': apiData.equipment,
            'gender': apiData.gender,
            'location': apiData.location,
            'goal': apiData.goal,
            'exercise_category_id': apiData.exerciseCategoryId,
            'sets': apiData.sets,
            'reps': apiData.reps,
          });
        }).toList();

        log('Converted exercises count: ${exercises.length}');
        return exercises;
      } else if (response.statusCode == 404) {
        // Handle 404 as "no exercises found" - this is a valid response
        log('API returned 404 - no exercises found for this day and goal');
        return [];
      } else {
        throw Exception('Failed to load exercises by day: ${response.statusCode}');
      }
    } catch (e) {
      log('Error in getExercisesByDay: $e');
      throw Exception('Error fetching exercises by day: $e');
    }
  }

  /// Fetch exercise categories from the API with their exercises
  Future<List<WorkoutType>> getExerciseCategories() async {
    try {
      final response = await _apiService.get(
        AppConstants.getExercisesCategoryEndpoint,
      );

      if (response.statusCode == 200) {
        final categoryApiResponse = ExerciseCategoryApiResponse.fromJson(response.data);
        
        // Convert API data to WorkoutType domain models with exercises
        final categories = categoryApiResponse.data.map((apiData) {
          return WorkoutType.fromApiData({
            'id': apiData.id,
            'en_name': apiData.enName,
            'icon': apiData.icon,
            'exercises': apiData.exercises.map((exerciseData) => {
              'id': exerciseData.id,
            'ar_name': exerciseData.arName,
            'en_name': exerciseData.enName,
            'ar_description': exerciseData.arDescription,
            'en_description': exerciseData.enDescription,
              'gif': exerciseData.gif,
              'equipment': exerciseData.equipment,
              'gender': exerciseData.gender,
              'location': exerciseData.location,
              'goal': exerciseData.goal,
              'exercise_category_id': exerciseData.exerciseCategoryId,
              'sets': exerciseData.sets,
              'reps': exerciseData.reps,
            }).toList(),
          });
        }).toList();

        return categories;
      } else {
        throw Exception('Failed to load exercise categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exercise categories: $e');
    }
  }

  /// Get favorite exercises from API
  Future<List<Exercise>> getFavoriteExercisesFromAPI() async {
    try {
      log('ExerciseRepository: Fetching favorite exercises from API...');
      
      final response = await _apiService.get(AppConstants.favoritesExercisesEndpoint);

      if (response.statusCode == 200) {
        final responseData = response.data;
        final exercises = responseData['data'] as List<dynamic>? ?? [];
        
        log('ExerciseRepository: Retrieved ${exercises.length} favorite exercises from API');
        
        // Convert API data to Exercise domain models
        final favoriteExercises = exercises.map((exerciseData) {
          return Exercise.fromApiData({
            'id': exerciseData['id'],
            'ar_name': exerciseData['ar_name'],
            'en_name': exerciseData['en_name'],
            'ar_description': exerciseData['ar_description'],
            'en_description': exerciseData['en_description'],
            'gif': exerciseData['gif'],
            'equipment': exerciseData['equipment'],
            'gender': exerciseData['gender'],
            'location': exerciseData['location'],
            'goal': exerciseData['goal'],
            'exercise_category_id': exerciseData['exercise_category_id'],
            'sets': exerciseData['sets'],
            'reps': exerciseData['reps'],
          });
        }).toList();

        return favoriteExercises;
      } else {
        throw Exception('Failed to load favorite exercises: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching favorite exercises: $e');
    }
  }
}
