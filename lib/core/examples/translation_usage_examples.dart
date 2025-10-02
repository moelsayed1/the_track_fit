import 'dart:developer';

import '../helpers/api_response_helper.dart';
import '../services/translation_service.dart';
import '../repositories/translated_repository.dart';

/// Examples of how to use the translation system in your app
class TranslationUsageExamples {
  final TranslationService _translationService = TranslationService();
  final ExerciseRepository _exerciseRepository = ExerciseRepository();
  final ProductRepository _productRepository = ProductRepository();
  final GoalRepository _goalRepository = GoalRepository();

  /// Example 1: Basic translation helper usage
  Future<void> basicTranslationExample() async {
    // Example API response
    final apiResponse = {
      'id': 1,
      'title_ar': 'تمرين الضغط', // Arabic title exists
      'title_en': 'Push Up', // English title
      'description_ar': '', // Arabic description is empty
      'description_en': 'A basic upper body exercise', // English description
      'category_ar': null, // Arabic category is null
      'category_en': 'Strength Training', // English category
    };

    // Get translated title (will use Arabic since it exists)
    final translatedTitle = await ApiResponseHelper.getTranslatedValue(
      apiResponse['title_ar'] as String?,
      apiResponse['title_en'] as String?,
    );
    log('Title: $translatedTitle'); // Output: تمرين الضغط

    // Get translated description (will translate from English since Arabic is empty)
    final translatedDescription = await ApiResponseHelper.getTranslatedValue(
      apiResponse['description_ar'] as String?,
      apiResponse['description_en'] as String?,
    );
    log('Description: $translatedDescription'); // Output: تمرين أساسي للجزء العلوي من الجسم

    // Get translated category (will translate from English since Arabic is null)
    final translatedCategory = await ApiResponseHelper.getTranslatedValue(
      apiResponse['category_ar'] as String?,
      apiResponse['category_en'] as String?,
    );
    log('Category: $translatedCategory'); // Output: تدريب القوة
  }

  /// Example 2: Processing entire API response
  Future<void> processApiResponseExample() async {
    // Example API response with multiple items
    final apiResponse = {
      'status': 'success',
      'data': [
        {
          'id': 1,
          'title_ar': 'تمرين الضغط',
          'title_en': 'Push Up',
          'description_ar': '',
          'description_en': 'A basic upper body exercise',
        },
        {
          'id': 2,
          'title_ar': '',
          'title_en': 'Squat',
          'description_ar': 'تمرين أساسي للساقين',
          'description_en': 'A basic lower body exercise',
        },
      ],
    };

    // Process the entire response
    final processedResponse = await ApiResponseHelper.processApiResponse(
      apiResponse,
      specificFields: ['title', 'description'],
    );

    log('Processed Response: $processedResponse');
    // All titles and descriptions will be in Arabic
  }

  /// Example 3: Using repository with automatic translation
  Future<void> repositoryExample() async {
    try {
      // Get all exercises with automatic translation
      final exercises = await _exerciseRepository.getAllExercises();
      
      for (var exercise in exercises) {
        log('Exercise: ${exercise.title}'); // Will be in Arabic
        log('Description: ${exercise.description}'); // Will be in Arabic
        log('Category: ${exercise.category}'); // Will be in Arabic
      }

      // Get products with automatic translation
      final products = await _productRepository.getNewProducts();
      
      for (var product in products) {
        log('Product: ${product.name}'); // Will be in Arabic
        log('Description: ${product.description}'); // Will be in Arabic
      }

      // Get goals with automatic translation
      final goals = await _goalRepository.getMainGoalOptions();
      
      for (var goal in goals) {
        log('Goal: ${goal.name}'); // Will be in Arabic
        log('Description: ${goal.description}'); // Will be in Arabic
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  /// Example 4: Manual translation for specific cases
  Future<void> manualTranslationExample() async {
    // Translate individual text
    final englishText = 'Welcome to Track Fit';
    final arabicText = await _translationService.translateToArabic(englishText);
    log('Translated: $arabicText'); // Output: مرحباً بك في تتبع اللياقة

    // Batch translate multiple texts
    final englishTexts = [
      'Strength Training',
      'Cardio Workout',
      'Flexibility Exercise',
    ];
    
    final arabicTexts = await _translationService.translateBatch(englishTexts);
    log('Batch translated: $arabicTexts');
    // Output: [تدريب القوة, تمرين القلب, تمرين المرونة]
  }

  /// Example 5: Handling different API response structures
  Future<void> differentApiStructuresExample() async {
    // Structure 1: Simple object
    final simpleResponse = {
      'name_ar': 'تمرين',
      'name_en': 'Exercise',
      'description_ar': '',
      'description_en': 'Physical activity',
    };

    final processedSimple = await ApiResponseHelper.processApiResponse(simpleResponse);
    log('Simple response: $processedSimple');

    // Structure 2: Nested object
    final nestedResponse = {
      'user': {
        'name_ar': 'أحمد',
        'name_en': 'Ahmed',
        'goal_ar': '',
        'goal_en': 'Lose weight',
      },
    };

    final processedNested = await ApiResponseHelper.processNestedObject(
      nestedResponse,
      'user',
      ['name', 'goal'],
    );
    log('Nested response: $processedNested');

    // Structure 3: Paginated response
    final paginatedResponse = {
      'data': [
        {'title_ar': 'تمرين 1', 'title_en': 'Exercise 1'},
        {'title_ar': '', 'title_en': 'Exercise 2'},
      ],
      'pagination': {
        'current_page': 1,
        'total_pages': 5,
      },
    };

    final processedPaginated = await ApiResponseHelper.processPaginatedResponse(
      paginatedResponse,
      ['title'],
    );
    log('Paginated response: $processedPaginated');
  }

  /// Example 6: Error handling
  Future<void> errorHandlingExample() async {
    try {
      // This will handle translation errors gracefully
      final result = await ApiResponseHelper.getTranslatedValue(
        null, // No Arabic value
        'This will be translated', // English value
      );
      log('Result: $result'); // Will show translated text or fallback to English
    } catch (e) {
      log('Translation error handled: $e');
    }
  }
}

/// Example of how to integrate with your existing API calls
class ExistingApiIntegration {
  /// Example: Modify your existing exercise API call
  Future<List<Map<String, dynamic>>> getExercisesWithTranslation() async {
    try {
      // Your existing API call
      // final response = await ApiService().get('/api/get-all-exercises');
      
      // Simulate API response
      final response = {
        'status': 'success',
        'data': [
          {
            'id': 1,
            'title_ar': 'تمرين الضغط',
            'title_en': 'Push Up',
            'description_ar': '',
            'description_en': 'A basic upper body exercise',
            'category_ar': '',
            'category_en': 'Strength Training',
            'equipment_ar': '',
            'equipment_en': 'None',
            'instructions_ar': '',
            'instructions_en': 'Start in plank position...',
            'tips_ar': '',
            'tips_en': 'Keep your core tight...',
            'image_url': 'https://example.com/image.jpg',
            'duration': 30,
            'calories': 10,
          },
        ],
      };

      // Process with automatic translation
      final processedResponse = await ApiResponseHelper.processApiResponse(
        response,
        specificFields: ['title', 'description', 'category', 'equipment', 'instructions', 'tips'],
      );

      return processedResponse['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to fetch exercises: $e');
    }
  }

  /// Example: Modify your existing product API call
  Future<List<Map<String, dynamic>>> getProductsWithTranslation() async {
    try {
      // Simulate API response
      final response = {
        'status': 'success',
        'data': [
          {
            'id': 1,
            'name_ar': '',
            'name_en': 'Protein Powder',
            'description_ar': '',
            'description_en': 'High quality protein supplement',
            'category_ar': '',
            'category_en': 'Supplements',
            'brand_ar': '',
            'brand_en': 'Fitness Brand',
            'ingredients_ar': '',
            'ingredients_en': 'Whey protein, vitamins, minerals',
            'price': 29.99,
            'image_url': 'https://example.com/product.jpg',
            'stock': 100,
          },
        ],
      };

      // Process with automatic translation
      final processedResponse = await ApiResponseHelper.processApiResponse(
        response,
        specificFields: ['name', 'description', 'category', 'brand', 'ingredients'],
      );

      return processedResponse['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}
