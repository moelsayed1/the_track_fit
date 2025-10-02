import '../helpers/api_response_helper.dart';
import '../services/api_service.dart';
import '../models/translatable_model.dart';

/// Base repository class that handles automatic translation
abstract class TranslatedRepository {
  final ApiService _apiService = ApiService();

  /// Process API response with automatic translation
  Future<Map<String, dynamic>> processApiResponse(
    Map<String, dynamic> response, {
    List<String>? textFields,
  }) async {
    return await ApiResponseHelper.processApiResponse(response, specificFields: textFields);
  }

  /// Process list of items with translation
  Future<List<Map<String, dynamic>>> processListResponse(
    List<dynamic> items,
    List<String> textFields,
  ) async {
    return await ApiResponseHelper.processListItems(items, textFields);
  }

  /// Generic GET request with translation
  Future<Map<String, dynamic>> getTranslated(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    List<String>? textFields,
  }) async {
    try {
      final response = await _apiService.get(endpoint, queryParameters: queryParameters);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return await processApiResponse(data, textFields: textFields);
      } else {
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch translated data: $e');
    }
  }

  /// Generic POST request with translation
  Future<Map<String, dynamic>> postTranslated(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    List<String>? textFields,
  }) async {
    try {
      final response = await _apiService.post(endpoint, data: data, queryParameters: queryParameters);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        return await processApiResponse(responseData, textFields: textFields);
      } else {
        throw Exception('API request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post translated data: $e');
    }
  }
}

/// Example repository for exercises
class ExerciseRepository extends TranslatedRepository {
  /// Get all exercises with automatic translation
  Future<List<ExerciseModel>> getAllExercises() async {
    try {
      final response = await getTranslated(
        '/api/get-all-exercises',
        textFields: ['title', 'description', 'category', 'equipment', 'instructions', 'tips'],
      );

      final List<dynamic> exercisesData = response['data'] ?? [];
      final List<ExerciseModel> exercises = [];

      for (var exerciseData in exercisesData) {
        if (exerciseData is Map<String, dynamic>) {
          final exercise = await ExerciseModel.fromApiResponse(exerciseData);
          exercises.add(exercise);
        }
      }

      return exercises;
    } catch (e) {
      throw Exception('Failed to fetch exercises: $e');
    }
  }

  /// Get exercises by category with translation
  Future<List<ExerciseModel>> getExercisesByCategory(String categoryId) async {
    try {
      final response = await getTranslated(
        '/api/get-exercises-category',
        queryParameters: {'category_id': categoryId},
        textFields: ['title', 'description', 'category', 'equipment', 'instructions', 'tips'],
      );

      final List<dynamic> exercisesData = response['data'] ?? [];
      final List<ExerciseModel> exercises = [];

      for (var exerciseData in exercisesData) {
        if (exerciseData is Map<String, dynamic>) {
          final exercise = await ExerciseModel.fromApiResponse(exerciseData);
          exercises.add(exercise);
        }
      }

      return exercises;
    } catch (e) {
      throw Exception('Failed to fetch exercises by category: $e');
    }
  }

  /// Get exercise categories with translation
  Future<List<CategoryModel>> getExerciseCategories() async {
    try {
      final response = await getTranslated(
        '/api/get-exercises-category',
        textFields: ['name', 'description'],
      );

      final List<dynamic> categoriesData = response['data'] ?? [];
      final List<CategoryModel> categories = [];

      for (var categoryData in categoriesData) {
        if (categoryData is Map<String, dynamic>) {
          final category = await CategoryModel.fromApiResponse(categoryData);
          categories.add(category);
        }
      }

      return categories;
    } catch (e) {
      throw Exception('Failed to fetch exercise categories: $e');
    }
  }
}

/// Example repository for products
class ProductRepository extends TranslatedRepository {
  /// Get new products with translation
  Future<List<ProductModel>> getNewProducts({int perPage = 10, int page = 1}) async {
    try {
      final response = await getTranslated(
        '/api/new-products',
        queryParameters: {'per_page': perPage, 'page': page},
        textFields: ['name', 'description', 'category', 'brand', 'ingredients'],
      );

      final List<dynamic> productsData = response['data'] ?? [];
      final List<ProductModel> products = [];

      for (var productData in productsData) {
        if (productData is Map<String, dynamic>) {
          final product = await ProductModel.fromApiResponse(productData);
          products.add(product);
        }
      }

      return products;
    } catch (e) {
      throw Exception('Failed to fetch new products: $e');
    }
  }

  /// Get favorite products with translation
  Future<List<ProductModel>> getFavoriteProducts() async {
    try {
      final response = await getTranslated(
        '/api/favorites/products',
        textFields: ['name', 'description', 'category', 'brand', 'ingredients'],
      );

      final List<dynamic> productsData = response['data'] ?? [];
      final List<ProductModel> products = [];

      for (var productData in productsData) {
        if (productData is Map<String, dynamic>) {
          final product = await ProductModel.fromApiResponse(productData);
          products.add(product);
        }
      }

      return products;
    } catch (e) {
      throw Exception('Failed to fetch favorite products: $e');
    }
  }
}

/// Example repository for main goals
class GoalRepository extends TranslatedRepository {
  /// Get main goal options with translation
  Future<List<CategoryModel>> getMainGoalOptions() async {
    try {
      final response = await getTranslated(
        '/api/main-goal-option',
        textFields: ['name', 'description'],
      );

      final List<dynamic> goalsData = response['data'] ?? [];
      final List<CategoryModel> goals = [];

      for (var goalData in goalsData) {
        if (goalData is Map<String, dynamic>) {
          final goal = await CategoryModel.fromApiResponse(goalData);
          goals.add(goal);
        }
      }

      return goals;
    } catch (e) {
      throw Exception('Failed to fetch main goal options: $e');
    }
  }
}

/// Example repository for questions
class QuestionRepository extends TranslatedRepository {
  /// Get questions with translation
  Future<List<Map<String, dynamic>>> getQuestions() async {
    try {
      final response = await getTranslated(
        '/api/get-questions',
        textFields: ['question', 'description', 'category'],
      );

      return response['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to fetch questions: $e');
    }
  }
}
