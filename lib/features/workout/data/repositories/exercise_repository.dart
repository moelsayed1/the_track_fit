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
            'en_name': apiData.enName,
            'en_description': apiData.enDescription,
            'gif': apiData.gif,
            'equipment': apiData.equipment,
            'gender': apiData.gender,
            'location': apiData.location,
            'goal': apiData.goal,
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

  /// Get exercises by location
  Future<List<Exercise>> getExercisesByLocation(String location) async {
    final allExercises = await getAllExercises();
    return allExercises.where((exercise) => exercise.location == location).toList();
  }

  /// Get exercises by equipment
  Future<List<Exercise>> getExercisesByEquipment(String equipment) async {
    final allExercises = await getAllExercises();
    return allExercises.where((exercise) => exercise.equipment == equipment).toList();
  }

  /// Search exercises by name or description
  Future<List<Exercise>> searchExercises(String query) async {
    final allExercises = await getAllExercises();
    final searchLower = query.toLowerCase();
    
    return allExercises.where((exercise) {
      return exercise.title.toLowerCase().contains(searchLower) ||
             (exercise.description?.toLowerCase().contains(searchLower) ?? false) ||
             exercise.type.toLowerCase().contains(searchLower);
    }).toList();
  }

  /// Fetch exercise categories from the API
  Future<List<WorkoutType>> getExerciseCategories() async {
    try {
      final response = await _apiService.get(
        AppConstants.getExercisesCategoryEndpoint,
      );

      if (response.statusCode == 200) {
        final categoryApiResponse = ExerciseCategoryApiResponse.fromJson(response.data);
        
        // Convert API data to WorkoutType domain models
        final categories = categoryApiResponse.data.map((apiData) {
          return WorkoutType.fromApiData({
            'id': apiData.id,
            'en_name': apiData.enName,
            'icon': apiData.icon,
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
}
