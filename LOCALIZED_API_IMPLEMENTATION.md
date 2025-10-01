# Localized API Implementation Guide

This document explains how to implement automatic localization for API responses in your Track Fit Flutter app, supporting both Arabic and English languages.

## Overview

The system automatically handles API responses based on the selected app language:
- **Arabic Language**: Uses Arabic fields (`title_ar`, `description_ar`) if available, otherwise translates English fields to Arabic
- **English Language**: Always uses English fields (`title_en`, `description_en`) directly without translation

## Core Components

### 1. TranslationService (`lib/core/services/translation_service.dart`)
Handles the core translation logic and language detection.

### 2. ApiResponseHelper (`lib/core/helpers/api_response_helper.dart`)
Provides helper functions for processing API responses with localization.

### 3. TranslatableModel (`lib/core/models/translatable_model.dart`)
Base class for models that need localization support.

### 4. TranslatedRepository (`lib/core/repositories/translated_repository.dart`)
Repository pattern with automatic localization.

## Usage Examples

### Basic Usage

```dart
import 'package:the_track_fit/core/helpers/api_response_helper.dart';

// Example API response
final apiResponse = {
  'id': 1,
  'title_ar': 'تمرين الضغط', // Arabic title exists
  'title_en': 'Push Up', // English title
  'description_ar': '', // Arabic description is empty
  'description_en': 'A basic upper body exercise', // English description
};

// Get localized value based on current app language
final localizedTitle = await ApiResponseHelper.getLocalizedValueAuto(
  apiResponse['title_ar'],
  apiResponse['title_en'],
);

// If current language is Arabic: returns 'تمرين الضغط'
// If current language is English: returns 'Push Up'
```

### Manual Language Specification

```dart
// Force Arabic regardless of current app language
final arabicTitle = await ApiResponseHelper.getLocalizedValue(
  apiResponse['title_ar'],
  apiResponse['title_en'],
  'ar', // Force Arabic
);

// Force English regardless of current app language
final englishTitle = await ApiResponseHelper.getLocalizedValue(
  apiResponse['title_ar'],
  apiResponse['title_en'],
  'en', // Force English
);
```

### Processing Entire API Response

```dart
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

// Process entire response with automatic language detection
final processedResponse = await ApiResponseHelper.processApiResponse(
  apiResponse,
  specificFields: ['title', 'description'],
);

// All titles and descriptions will be in the current app language
```

### Using Repository Pattern

```dart
import 'package:the_track_fit/core/repositories/translated_repository.dart';

class ExerciseRepository extends TranslatedRepository {
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
}
```

### Creating Localized Models

```dart
class ExerciseModel extends TranslatableModel {
  final int id;
  String title;
  String description;
  String category;

  ExerciseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
    );
  }

  /// Create from API response with automatic localization
  static Future<ExerciseModel> fromApiResponse(Map<String, dynamic> json) async {
    final model = ExerciseModel.fromJson(json);
    
    // Process translatable fields
    await model.processTextFields(json, [
      'title',
      'description',
      'category',
    ]);
    
    return model;
  }

  @override
  void _setTranslatedField(String fieldName, String value) {
    switch (fieldName) {
      case 'title':
        title = value;
        break;
      case 'description':
        description = value;
        break;
      case 'category':
        category = value;
        break;
    }
  }
}
```

## API Response Formats

### Format 1: Separate Language Fields
```json
{
  "id": 1,
  "title_ar": "تمرين الضغط",
  "title_en": "Push Up",
  "description_ar": "",
  "description_en": "A basic upper body exercise"
}
```

### Format 2: Base Fields Only
```json
{
  "id": 1,
  "title": "Push Up",
  "description": "A basic upper body exercise"
}
```

### Format 3: Mixed Format
```json
{
  "id": 1,
  "title_ar": "تمرين الضغط",
  "title_en": "Push Up",
  "description": "A basic upper body exercise"
}
```

## Language Behavior

### When Arabic is Selected:
1. **Arabic field exists and not empty**: Use Arabic field directly
2. **Arabic field is empty/null**: Translate English field to Arabic
3. **Only base field exists**: Translate base field to Arabic
4. **No fields exist**: Return empty string

### When English is Selected:
1. **English field exists**: Use English field directly
2. **Only Arabic field exists**: Use Arabic field directly (no translation)
3. **Only base field exists**: Use base field directly
4. **No fields exist**: Return empty string

## Integration with Existing Code

### Step 1: Update Your API Calls
```dart
// Before
Future<List<Exercise>> getExercises() async {
  final response = await ApiService().get('/api/get-all-exercises');
  return (response.data['data'] as List)
      .map((json) => Exercise.fromJson(json))
      .toList();
}

// After
Future<List<Exercise>> getExercises() async {
  final response = await ApiService().get('/api/get-all-exercises');
  final processedResponse = await ApiResponseHelper.processApiResponse(
    response.data,
    specificFields: ['title', 'description', 'category'],
  );
  return (processedResponse['data'] as List)
      .map((json) => Exercise.fromJson(json))
      .toList();
}
```

### Step 2: Update Your Models
```dart
// Before
class Exercise {
  final String title;
  final String description;
  
  Exercise.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        description = json['description'] ?? '';
}

// After
class Exercise extends TranslatableModel {
  String title;
  String description;
  
  Exercise.fromJson(Map<String, dynamic> json)
      : title = json['title'] ?? '',
        description = json['description'] ?? '';
  
  static Future<Exercise> fromApiResponse(Map<String, dynamic> json) async {
    final exercise = Exercise.fromJson(json);
    await exercise.processTextFields(json, ['title', 'description']);
    return exercise;
  }
  
  @override
  void _setTranslatedField(String fieldName, String value) {
    switch (fieldName) {
      case 'title':
        title = value;
        break;
      case 'description':
        description = value;
        break;
    }
  }
}
```

### Step 3: Update Your UI
```dart
// Your UI will automatically display the correct language
// No changes needed in your UI code!
Text(exercise.title) // Will show Arabic or English based on app language
```

## Supported Endpoints

All endpoints from your Postman collection are supported:

### Authentication
- `/api/register` - User registration messages
- `/api/login` - Login messages
- `/api/logout` - Logout messages

### Profile
- `/api/profile` - Profile data
- `/api/update` - Update messages
- `/api/main-goal-option` - Goal options
- `/api/update-main-goal` - Goal update messages

### Workout
- `/api/get-all-exercises` - Exercise data
- `/api/get-exercises-category` - Category data
- `/api/get-exercises-filter` - Filter options
- `/api/get-exercises-by-day` - Daily exercises

### Products
- `/api/new-products` - Product data
- `/api/get-cart` - Cart items
- `/api/store-in-cart` - Cart messages
- `/api/favorites/products` - Favorite products

### Other
- `/api/get-meals-by-day` - Meal data
- `/api/get-questions` - Question data
- `/api/submit-answers` - Answer messages
- `/api/get-active-packages` - Package data

## Error Handling

The system handles errors gracefully:

```dart
try {
  final localizedValue = await ApiResponseHelper.getLocalizedValueAuto(
    arValue,
    enValue,
  );
  // Use localizedValue
} catch (e) {
  // Fallback to English value
  final fallbackValue = enValue ?? '';
}
```

## Performance Considerations

1. **Translation Caching**: Consider implementing caching for frequently translated text
2. **Batch Translation**: Use `translateBatch()` for multiple texts
3. **Async Processing**: All translation operations are async
4. **Error Fallbacks**: Always provide fallback values

## Testing

```dart
// Test with Arabic language
LanguageService.instance.changeLanguage('ar');
final arabicResult = await ApiResponseHelper.getLocalizedValueAuto(
  'تمرين الضغط',
  'Push Up',
);
assert(arabicResult == 'تمرين الضغط');

// Test with English language
LanguageService.instance.changeLanguage('en');
final englishResult = await ApiResponseHelper.getLocalizedValueAuto(
  'تمرين الضغط',
  'Push Up',
);
assert(englishResult == 'Push Up');
```

## Troubleshooting

### Common Issues

1. **Translation not working**: Check internet connection (Google Translate requires internet)
2. **Language not changing**: Ensure `LanguageService.instance.changeLanguage()` is called
3. **Empty values**: Check if API response has the expected field names
4. **Performance issues**: Consider caching frequently used translations

### Debug Mode

```dart
// Enable debug logging
final result = await ApiResponseHelper.getLocalizedValueAuto(
  arValue,
  enValue,
);
print('Current language: ${LanguageService.instance.currentLanguage}');
print('Result: $result');
```

## Future Enhancements

1. **Offline Translation**: Implement offline translation using local models
2. **Translation Caching**: Cache translations to improve performance
3. **Custom Translation Service**: Support for other translation services
4. **Language Detection**: Auto-detect content language
5. **Pluralization**: Support for plural forms in different languages

## Support

For issues or questions about the localized API implementation, please refer to:
- Translation Service: `lib/core/services/translation_service.dart`
- API Response Helper: `lib/core/helpers/api_response_helper.dart`
- Examples: `lib/core/examples/localized_api_examples.dart`
