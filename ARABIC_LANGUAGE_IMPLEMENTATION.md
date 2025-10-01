# Arabic Language Implementation Guide

This document explains how Arabic language support has been implemented in the Track Fit Flutter app.

## Overview

The app now supports both English and Arabic languages with:
- Automatic language detection and persistence
- RTL (Right-to-Left) layout support for Arabic
- Language-specific API calls
- Comprehensive translation system

## Files Added/Modified

### 1. Configuration Files
- `l10n.yaml` - Localization configuration
- `lib/l10n/app_en.arb` - English translations
- `lib/l10n/app_ar.arb` - Arabic translations

### 2. Core Services
- `lib/core/services/language_service.dart` - Language management service
- `lib/core/constants/app_constants.dart` - Updated with language constants
- `lib/core/services/api_service.dart` - Updated to include language parameters

### 3. UI Components
- `lib/core/widgets/language_selector.dart` - Language selection widget
- `lib/features/profile/presentation/screens/profile_screen.dart` - Updated with localization

### 4. Main App
- `lib/main.dart` - Updated with localization delegates
- `pubspec.yaml` - Added flutter_localizations dependency

## How to Use

### 1. Basic Localization

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Text(l10n.welcome); // Automatically shows Arabic or English
  }
}
```

### 2. Language Service Usage

```dart
import 'package:the_track_fit/core/services/language_service.dart';

// Get current language
String currentLang = LanguageService.instance.currentLanguage; // 'en' or 'ar'

// Change language
await LanguageService.instance.changeLanguage('ar');

// Check if Arabic
bool isArabic = LanguageService.instance.isArabic;

// Get text direction
TextDirection direction = LanguageService.instance.textDirection;

// Get alignment helpers
Alignment alignment = LanguageService.instance.alignment;
CrossAxisAlignment crossAxis = LanguageService.instance.crossAxisAlignment;
```

### 3. API Calls with Language

All API calls automatically include the language parameter:

```dart
// This will automatically add ?lang=en or ?lang=ar to the request
final response = await ApiService().get('/api/exercises');

// You can disable language parameter if needed
final response = await ApiService().get('/api/exercises', includeLanguage: false);
```

### 4. RTL Layout Support

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languageService = LanguageService.instance;
    
    return Column(
      crossAxisAlignment: languageService.crossAxisAlignment, // Auto RTL/LTR
      children: [
        Text('Content'),
        Row(
          mainAxisAlignment: languageService.mainAxisAlignment, // Auto RTL/LTR
          children: [
            Icon(Icons.star),
            Text('Rating'),
          ],
        ),
      ],
    );
  }
}
```

## API Endpoints with Language Support

All endpoints from the Postman collection now support language parameters:

### Authentication Endpoints
- `/api/register?lang=ar`
- `/api/login?lang=ar`
- `/api/logout?lang=ar`
- `/api/send-otp?lang=ar`
- `/api/reset-password?lang=ar`

### Profile Endpoints
- `/api/profile?lang=ar`
- `/api/update?lang=ar`
- `/api/main-goal-option?lang=ar`
- `/api/update-main-goal?lang=ar`

### Workout Endpoints
- `/api/get-all-exercises?lang=ar`
- `/api/get-exercises-category?lang=ar`
- `/api/get-exercises-filter?lang=ar`
- `/api/get-exercises-by-day?lang=ar`

### Product Endpoints
- `/api/new-products?lang=ar`
- `/api/get-cart?lang=ar`
- `/api/store-in-cart?lang=ar`
- `/api/favorites/products?lang=ar`

### Other Endpoints
- `/api/get-meals-by-day?lang=ar`
- `/api/get-questions?lang=ar`
- `/api/submit-answers?lang=ar`
- `/api/get-active-packages?lang=ar`
- `/api/current-subscription-package?lang=ar`

## Adding New Translations

### 1. Add to ARB Files

**English (`lib/l10n/app_en.arb`):**
```json
{
  "newKey": "English Text"
}
```

**Arabic (`lib/l10n/app_ar.arb`):**
```json
{
  "newKey": "النص العربي"
}
```

### 2. Regenerate Localizations

```bash
flutter pub get
```

### 3. Use in Code

```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.newKey);
```

## Language Switching

### Method 1: Using Language Selector Widget

```dart
import 'package:the_track_fit/core/widgets/language_selector.dart';

// In your widget
LanguageSelector()
```

### Method 2: Programmatic Language Change

```dart
// Change to Arabic
await LanguageService.instance.changeLanguage('ar');

// Change to English
await LanguageService.instance.changeLanguage('en');
```

## Best Practices

### 1. Always Use Localization
- Never hardcode text strings
- Always use `AppLocalizations.of(context)!.keyName`

### 2. RTL Layout Support
- Use `LanguageService.instance.crossAxisAlignment` for column alignment
- Use `LanguageService.instance.mainAxisAlignment` for row alignment
- Use `LanguageService.instance.alignment` for general alignment

### 3. API Calls
- Let the ApiService handle language parameters automatically
- Only disable `includeLanguage` for endpoints that don't support it

### 4. Testing
- Test both English and Arabic layouts
- Verify RTL layout works correctly
- Test API responses in both languages

## Troubleshooting

### 1. Localization Not Working
- Ensure `flutter pub get` was run after adding dependencies
- Check that `l10n.yaml` exists and is properly configured
- Verify ARB files are in the correct location

### 2. RTL Layout Issues
- Use the alignment helpers from `LanguageService`
- Test with longer Arabic text
- Check for hardcoded alignments

### 3. API Language Parameter Not Working
- Verify `includeLanguage: true` is set (default)
- Check that the API endpoint supports the `lang` parameter
- Test with both `en` and `ar` values

## Future Enhancements

1. **Dynamic Language Loading**: Load translations from the server
2. **Language Detection**: Auto-detect device language
3. **More Languages**: Add support for additional languages
4. **Pluralization**: Add support for plural forms
5. **Date/Number Formatting**: Localize date and number formats

## Support

For issues or questions about the Arabic language implementation, please refer to:
- Flutter Internationalization: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
- ARB Format: https://github.com/google/app-resource-bundle
- RTL Support: https://flutter.dev/docs/development/accessibility-and-localization/internationalization#rtl-languages
