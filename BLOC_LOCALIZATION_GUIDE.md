# Bloc-Based Localization Implementation Guide

This guide explains how to implement dynamic localization in your Flutter app using Bloc architecture for both static UI texts and API response data.

## Overview

The system provides:
1. **Static UI Localization**: Using ARB files and Flutter's localization system
2. **API Response Localization**: Automatic handling of Arabic/English fields with translation fallback
3. **Bloc State Management**: Language changes managed through Bloc events and states

## Architecture

### 1. Language Bloc (`lib/core/bloc/language/language_bloc.dart`)
- **Events**: `LanguageInitialized`, `LanguageChanged`
- **States**: `LanguageInitial`, `LanguageLoaded`, `LanguageError`
- **Purpose**: Manages language state and notifies UI of changes

### 2. Language Service (`lib/core/services/language_service.dart`)
- **Purpose**: Handles language persistence and provides language utilities
- **Methods**: `initialize()`, `changeLanguage()`, `currentLanguage`, `isArabic`, `isEnglish`

### 3. API Localization Helper (`lib/core/helpers/api_localization_helper.dart`)
- **Purpose**: Processes API responses with automatic localization
- **Key Method**: `getLocalizedValue(String? arValue, String? enValue, String currentLang)`

## Implementation

### 1. Static UI Localization

#### ARB Files
- `lib/l10n/app_en.arb` - English translations
- `lib/l10n/app_ar.arb` - Arabic translations
- `l10n.yaml` - Configuration file

#### Usage in Widgets
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        Text(l10n.home),           // "Home" / "الرئيسية"
        Text(l10n.workout),        // "Workout" / "التمارين"
        Text(l10n.dailyGoal),      // "Daily goal" / "الهدف اليومي"
        Text(l10n.yourActivity),  // "Your Activity" / "نشاطك"
      ],
    );
  }
}
```

### 2. API Response Localization

#### Basic Usage
```dart
// API response with both Arabic and English fields
final apiResponse = {
  'id': 1,
  'ar_name': 'تمرين الضغط',
  'en_name': 'Push Up',
  'ar_description': null,
  'en_description': 'A basic upper body exercise',
};

// Get localized value
final localizedName = await ApiLocalizationHelper.getLocalizedValueAuto(
  apiResponse['ar_name'],
  apiResponse['en_name'],
);

// Result: "تمرين الضغط" (if Arabic) or "Push Up" (if English)
```

#### Processing Entire API Response
```dart
final processedResponse = await ApiLocalizationHelper.processApiResponse(
  apiResponse,
  specificFields: ['name', 'description', 'category'],
);

// All specified fields will be localized based on current language
```

### 3. Bloc Integration

#### Setting up Bloc Provider
```dart
MultiBlocProvider(
  providers: [
    // ... other providers
    BlocProvider(
      create: (context) => LanguageBloc(languageService: LanguageService.instance)
        ..add(const LanguageInitialized()),
    ),
  ],
  child: BlocBuilder<LanguageBloc, LanguageState>(
    builder: (context, languageState) {
      return MaterialApp.router(
        locale: languageState is LanguageLoaded 
            ? Locale(languageState.currentLanguage)
            : LanguageService.instance.currentLocale,
        // ... other properties
      );
    },
  ),
)
```

#### Using Bloc in Widgets
```dart
class LanguageSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final l10n = AppLocalizations.of(context)!;
        final currentLanguage = languageState is LanguageLoaded 
            ? languageState.currentLanguage 
            : 'en';
        
        return Row(
          children: [
            Text(l10n.language),
            Radio<String>(
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context.read<LanguageBloc>().add(LanguageChanged(value));
                }
              },
            ),
            Text(l10n.english),
            Radio<String>(
              value: 'ar',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context.read<LanguageBloc>().add(LanguageChanged(value));
                }
              },
            ),
            Text(l10n.arabic),
          ],
        );
      },
    );
  }
}
```

## Localization Rules

### For API Responses:

#### When Arabic is Selected:
1. **Arabic field exists and not empty**: Use Arabic field directly
2. **Arabic field is missing/empty**: Translate English field to Arabic
3. **Both fields missing**: Return empty string

#### When English is Selected:
1. **English field exists**: Use English field directly
2. **English field missing**: Use Arabic field directly (no translation)
3. **Both fields missing**: Return empty string

### For Static UI:
- Automatically switches based on current locale
- Uses Flutter's built-in localization system
- No translation needed - direct mapping from ARB files

## Example Implementation

### Complete Widget Example
```dart
class ExerciseListWidget extends StatefulWidget {
  @override
  State<ExerciseListWidget> createState() => _ExerciseListWidgetState();
}

class _ExerciseListWidgetState extends State<ExerciseListWidget> {
  List<Map<String, dynamic>> _exercises = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() => _isLoading = true);
    
    try {
      // Simulate API call
      final apiResponse = {
        'data': [
          {
            'id': 1,
            'ar_name': 'تمرين الضغط',
            'en_name': 'Push Up',
            'ar_description': null,
            'en_description': 'A basic upper body exercise',
          }
        ]
      };

      // Process with localization
      final processedResponse = await ApiLocalizationHelper.processApiResponse(
        apiResponse,
        specificFields: ['name', 'description'],
      );

      setState(() {
        _exercises = List<Map<String, dynamic>>.from(processedResponse['data'] ?? []);
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final l10n = AppLocalizations.of(context)!;
        
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.workout), // Static UI localization
            actions: [
              IconButton(
                icon: Icon(Icons.language),
                onPressed: () => _showLanguageDialog(context),
              ),
            ],
          ),
          body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _exercises[index];
                    return ListTile(
                      title: Text(exercise['name'] ?? ''), // API localization
                      subtitle: Text(exercise['description'] ?? ''), // API localization
                    );
                  },
                ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        
        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, languageState) {
            final currentLanguage = languageState is LanguageLoaded 
                ? languageState.currentLanguage 
                : 'en';
            
            return AlertDialog(
              title: Text(l10n.language),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioListTile<String>(
                    title: Text(l10n.english),
                    value: 'en',
                    groupValue: currentLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LanguageBloc>().add(LanguageChanged(value));
                        Navigator.pop(context);
                        _loadExercises(); // Reload data with new language
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(l10n.arabic),
                    value: 'ar',
                    groupValue: currentLanguage,
                    onChanged: (value) {
                      if (value != null) {
                        context.read<LanguageBloc>().add(LanguageChanged(value));
                        Navigator.pop(context);
                        _loadExercises(); // Reload data with new language
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(l10n.cancel),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
```

## Repository Integration

### Example Repository with Localization
```dart
class ExerciseRepository {
  final ApiService _apiService;

  ExerciseRepository({required ApiService apiService}) : _apiService = apiService;

  Future<List<Exercise>> getAllExercises() async {
    try {
      final response = await _apiService.get('/api/get-all-exercises');
      
      // Process with localization
      final processedResponse = await ApiLocalizationHelper.processApiResponse(
        response.data,
        specificFields: ['name', 'description', 'category'],
      );

      return (processedResponse['data'] as List)
          .map((json) => Exercise.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load exercises: $e');
    }
  }
}
```

## Testing

### Test Language Changes
```dart
void testLanguageChange() {
  // Test Arabic
  context.read<LanguageBloc>().add(LanguageChanged('ar'));
  // UI should update to Arabic
  
  // Test English
  context.read<LanguageBloc>().add(LanguageChanged('en'));
  // UI should update to English
}
```

### Test API Localization
```dart
void testApiLocalization() async {
  final result = await ApiLocalizationHelper.getLocalizedValueAuto(
    'تمرين الضغط',  // Arabic
    'Push Up',      // English
  );
  
  // Should return localized value based on current language
  print('Localized: $result');
}
```

## Benefits

1. **Consistent State Management**: Uses your existing Bloc architecture
2. **Automatic UI Updates**: Language changes trigger UI rebuilds automatically
3. **Flexible API Handling**: Supports various API response formats
4. **Translation Fallback**: Automatically translates missing Arabic content
5. **Performance**: Efficient state management with minimal rebuilds
6. **Maintainable**: Clear separation of concerns between UI and data localization

## Migration from Provider

If you were using Provider before, the migration is straightforward:

1. Replace `Consumer<LanguageService>` with `BlocBuilder<LanguageBloc, LanguageState>`
2. Replace `context.read<LanguageService>().changeLanguage()` with `context.read<LanguageBloc>().add(LanguageChanged())`
3. Access current language through `languageState.currentLanguage` instead of `languageService.currentLanguage`

## Troubleshooting

### Common Issues

1. **Language not changing**: Ensure BlocProvider is properly set up
2. **UI not updating**: Check that BlocBuilder is wrapping the widget
3. **Translation errors**: Verify internet connection for Google Translate
4. **Missing translations**: Check ARB files for missing keys

### Debug Tips

```dart
// Check current language state
BlocBuilder<LanguageBloc, LanguageState>(
  builder: (context, state) {
    print('Current state: $state');
    if (state is LanguageLoaded) {
      print('Current language: ${state.currentLanguage}');
      print('Is Arabic: ${state.isArabic}');
    }
    return YourWidget();
  },
)
```

This Bloc-based localization system provides a robust, scalable solution that integrates seamlessly with your existing architecture while providing comprehensive localization support for both static UI and dynamic API content.
