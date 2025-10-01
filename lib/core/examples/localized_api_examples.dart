import 'dart:developer';

import '../helpers/api_response_helper.dart';
import '../services/language_service.dart';
import '../repositories/translated_repository.dart';

/// Examples of how to use the localized API system
class LocalizedApiExamples {
  final ExerciseRepository _exerciseRepository = ExerciseRepository();

  /// Example 1: Basic localized value usage
  Future<void> basicLocalizedValueExample() async {
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

    // Test with Arabic language selected
    LanguageService.instance.changeLanguage('ar');
    await Future.delayed(Duration(milliseconds: 100)); // Wait for language change

    // Get localized title (will use Arabic since it exists)
    final arabicTitle = await ApiResponseHelper.getLocalizedValueAuto(
      apiResponse['title_ar'] as String?,
      apiResponse['title_en'] as String?,
    );
    log('Arabic Title: $arabicTitle'); // Output: تمرين الضغط

    // Get localized description (will translate from English since Arabic is empty)
    final arabicDescription = await ApiResponseHelper.getLocalizedValueAuto(
      apiResponse['description_ar'] as String?,
      apiResponse['description_en'] as String?,
    );
    log('Arabic Description: $arabicDescription'); // Output: تمرين أساسي للجزء العلوي من الجسم

    // Test with English language selected
    LanguageService.instance.changeLanguage('en');
    await Future.delayed(Duration(milliseconds: 100)); // Wait for language change

    // Get localized title (will use English directly)
    final englishTitle = await ApiResponseHelper.getLocalizedValueAuto(
      apiResponse['title_ar'] as String?,
      apiResponse['title_en'] as String?,
    );
    log('English Title: $englishTitle'); // Output: Push Up

    // Get localized description (will use English directly)
    final englishDescription = await ApiResponseHelper.getLocalizedValueAuto(
      apiResponse['description_ar'] as String?,
      apiResponse['description_en'] as String?,
    );
    log('English Description: $englishDescription'); // Output: A basic upper body exercise
  }

  /// Example 2: Processing API response with specific language
  Future<void> processApiResponseWithLanguageExample() async {
    // Example API response
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

    // Process with Arabic language
    final arabicResponse = await ApiResponseHelper.processApiResponse(
      apiResponse,
      specificFields: ['title', 'description'],
      currentLang: 'ar',
    );
    log('Arabic Response: $arabicResponse');
    // All titles and descriptions will be in Arabic

    // Process with English language
    final englishResponse = await ApiResponseHelper.processApiResponse(
      apiResponse,
      specificFields: ['title', 'description'],
      currentLang: 'en',
    );
    log('English Response: $englishResponse');
    // All titles and descriptions will be in English
  }

  /// Example 3: Using repository with automatic language detection
  Future<void> repositoryWithAutoLanguageExample() async {
    try {
      // Set language to Arabic
      LanguageService.instance.changeLanguage('ar');
      await Future.delayed(Duration(milliseconds: 100));

      // Get exercises - will automatically use Arabic or translate to Arabic
      final arabicExercises = await _exerciseRepository.getAllExercises();
      
      for (var exercise in arabicExercises) {
        log('Arabic Exercise: ${exercise.title}'); // Will be in Arabic
        log('Arabic Description: ${exercise.description}'); // Will be in Arabic
      }

      // Set language to English
      LanguageService.instance.changeLanguage('en');
      await Future.delayed(Duration(milliseconds: 100));

      // Get exercises - will automatically use English
      final englishExercises = await _exerciseRepository.getAllExercises();
      
      for (var exercise in englishExercises) {
        log('English Exercise: ${exercise.title}'); // Will be in English
        log('English Description: ${exercise.description}'); // Will be in English
      }
    } catch (e) {
      log('Error: $e');
    }
  }

  /// Example 4: Manual language specification
  Future<void> manualLanguageSpecificationExample() async {
    // Example API response
    final apiResponse = {
      'id': 1,
      'title_ar': 'تمرين الضغط',
      'title_en': 'Push Up',
      'description_ar': '',
      'description_en': 'A basic upper body exercise',
    };

    // Get value in Arabic regardless of current app language
    final arabicTitle = await ApiResponseHelper.getLocalizedValue(
      apiResponse['title_ar'] as String?,
      apiResponse['title_en'] as String?,
      'ar',
    );
    log('Forced Arabic: $arabicTitle'); // Output: تمرين الضغط

    // Get value in English regardless of current app language
    final englishTitle = await ApiResponseHelper.getLocalizedValue(
      apiResponse['title_ar'] as String?,
      apiResponse['title_en'] as String?,
      'en',
    );
    log('Forced English: $englishTitle'); // Output: Push Up
  }

  /// Example 5: Handling different API response structures
  Future<void> differentApiStructuresExample() async {
    // Structure 1: Simple object with Arabic/English fields
    final simpleResponse = {
      'name_ar': 'تمرين',
      'name_en': 'Exercise',
      'description_ar': '',
      'description_en': 'Physical activity',
    };

    // Process with Arabic
    final arabicSimple = await ApiResponseHelper.processApiResponse(
      simpleResponse,
      currentLang: 'ar',
    );
    log('Arabic Simple: $arabicSimple');

    // Process with English
    final englishSimple = await ApiResponseHelper.processApiResponse(
      simpleResponse,
      currentLang: 'en',
    );
    log('English Simple: $englishSimple');

    // Structure 2: Object with only base fields (no _ar/_en)
    final baseResponse = {
      'name': 'Exercise',
      'description': 'Physical activity',
      'category': 'Fitness',
    };

    // Process with Arabic (will translate base fields)
    final arabicBase = await ApiResponseHelper.processApiResponse(
      baseResponse,
      currentLang: 'ar',
    );
    log('Arabic Base: $arabicBase');

    // Process with English (will use base fields directly)
    final englishBase = await ApiResponseHelper.processApiResponse(
      baseResponse,
      currentLang: 'en',
    );
    log('English Base: $englishBase');
  }

  /// Example 6: Real-world API integration
  Future<void> realWorldApiIntegrationExample() async {
    // Simulate your existing API calls with localization
    final exerciseApiResponse = {
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

    // Process based on current app language
    final currentLang = LanguageService.instance.currentLanguage;
    final processedResponse = await ApiResponseHelper.processApiResponse(
      exerciseApiResponse,
      specificFields: ['title', 'description', 'category', 'equipment', 'instructions', 'tips'],
      currentLang: currentLang,
    );

    log('Processed for $currentLang: $processedResponse');
  }

  /// Example 7: Error handling and fallbacks
  Future<void> errorHandlingExample() async {
    try {
      // Test with null values
      final result1 = await ApiResponseHelper.getLocalizedValueAuto(null, null);
      log('Null values result: "$result1"'); // Output: ""

      // Test with empty values
      final result2 = await ApiResponseHelper.getLocalizedValueAuto('', '');
      log('Empty values result: "$result2"'); // Output: ""

      // Test with only English value
      final result3 = await ApiResponseHelper.getLocalizedValueAuto(null, 'Hello World');
      log('Only English result: $result3'); // Will translate to Arabic or use English based on current language

      // Test with only Arabic value
      final result4 = await ApiResponseHelper.getLocalizedValueAuto('مرحبا بالعالم', null);
      log('Only Arabic result: $result4'); // Will use Arabic or translate to English based on current language

    } catch (e) {
      log('Error handled gracefully: $e');
    }
  }
}

/// Example of how to integrate with your existing API service
class ExistingApiIntegration {
  /// Example: Modify your existing exercise API call to support both languages
  Future<List<Map<String, dynamic>>> getExercisesWithLocalization() async {
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

      // Get current app language
      final currentLang = LanguageService.instance.currentLanguage;

      // Process with automatic localization
      final processedResponse = await ApiResponseHelper.processApiResponse(
        response,
        specificFields: ['title', 'description', 'category', 'equipment', 'instructions', 'tips'],
        currentLang: currentLang,
      );

      return processedResponse['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to fetch exercises: $e');
    }
  }

  /// Example: Modify your existing product API call
  Future<List<Map<String, dynamic>>> getProductsWithLocalization() async {
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

      // Get current app language
      final currentLang = LanguageService.instance.currentLanguage;

      // Process with automatic localization
      final processedResponse = await ApiResponseHelper.processApiResponse(
        response,
        specificFields: ['name', 'description', 'category', 'brand', 'ingredients'],
        currentLang: currentLang,
      );

      return processedResponse['data'] ?? [];
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }
}
