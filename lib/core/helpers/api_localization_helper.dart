import 'package:the_track_fit/core/services/language_service.dart';
import 'package:translator/translator.dart';

/// Helper class for handling API data localization
class ApiLocalizationHelper {
  static final _translator = GoogleTranslator();

  /// Get localized value from API response
  /// If current language is Arabic: use arValue if exists, otherwise translate enValue
  /// If current language is English: always use enValue
  static Future<String> getLocalizedValue(
    String? arValue,
    String? enValue,
    String currentLang,
  ) async {
    // If current language is English, always use English value
    if (currentLang == 'en') {
      return enValue ?? '';
    }

    // If current language is Arabic
    if (currentLang == 'ar') {
      // If Arabic value exists and is not empty, use it
      if (arValue != null && arValue.isNotEmpty) {
        return arValue;
      }
      
      // If English value exists, translate it to Arabic
      if (enValue != null && enValue.isNotEmpty) {
        try {
          final translation = await _translator.translate(enValue, from: 'en', to: 'ar');
          return translation.text;
        } catch (e) {
          // If translation fails, return English value as fallback
          return enValue;
        }
      }
    }

    // Fallback to empty string
    return '';
  }

  /// Get localized value synchronously (for cases where translation is not needed)
  static String getLocalizedValueSync(
    String? arValue,
    String? enValue,
    String currentLang,
  ) {
    // If current language is English, always use English value
    if (currentLang == 'en') {
      return enValue ?? '';
    }

    // If current language is Arabic
    if (currentLang == 'ar') {
      // If Arabic value exists and is not empty, use it
      if (arValue != null && arValue.isNotEmpty) {
        return arValue;
      }
      
      // If English value exists, return it (will be translated later if needed)
      if (enValue != null && enValue.isNotEmpty) {
        return enValue;
      }
    }

    // Fallback to empty string
    return '';
  }

  /// Process a list of items with localization
  static Future<List<Map<String, dynamic>>> processLocalizedList(
    List<dynamic> items,
    String currentLang,
    List<String> textFields,
  ) async {
    final List<Map<String, dynamic>> processedItems = [];

    for (final item in items) {
      if (item is Map<String, dynamic>) {
        final Map<String, dynamic> processedItem = Map.from(item);
        
        for (final field in textFields) {
          final arField = 'ar_$field';
          final enField = 'en_$field';
          
          if (item.containsKey(arField) || item.containsKey(enField)) {
            final arValue = item[arField];
            final enValue = item[enField];
            
            final localizedValue = await getLocalizedValue(
              arValue,
              enValue,
              currentLang,
            );
            
            // Add the localized value to the processed item
            processedItem[field] = localizedValue;
          }
        }
        
        processedItems.add(processedItem);
      }
    }

    return processedItems;
  }

  /// Process a single item with localization
  static Future<Map<String, dynamic>> processLocalizedItem(
    Map<String, dynamic> item,
    String currentLang,
    List<String> textFields,
  ) async {
    final Map<String, dynamic> processedItem = Map.from(item);
    
    for (final field in textFields) {
      final arField = 'ar_$field';
      final enField = 'en_$field';
      
      if (item.containsKey(arField) || item.containsKey(enField)) {
        final arValue = item[arField];
        final enValue = item[enField];
        
        final localizedValue = await getLocalizedValue(
          arValue,
          enValue,
          currentLang,
        );
        
        // Add the localized value to the processed item
        processedItem[field] = localizedValue;
      }
    }
    
    return processedItem;
  }

  /// Process API response with localization
  static Future<Map<String, dynamic>> processApiResponse(
    Map<String, dynamic> apiResponse,
    {List<String>? specificFields}
  ) async {
    final currentLang = LanguageService.instance.currentLanguage;
    final Map<String, dynamic> processedResponse = Map.from(apiResponse);
    
    if (apiResponse.containsKey('data')) {
      final data = apiResponse['data'];
      
      if (data is List) {
        // Process list of items
        final processedData = await processLocalizedList(
          data,
          currentLang,
          specificFields ?? ['name', 'description', 'title', 'text'],
        );
        processedResponse['data'] = processedData;
      } else if (data is Map<String, dynamic>) {
        // Process single item
        final processedData = await processLocalizedItem(
          data,
          currentLang,
          specificFields ?? ['name', 'description', 'title', 'text'],
        );
        processedResponse['data'] = processedData;
      }
    }
    
    return processedResponse;
  }
}

/// Extension for easy access to current language
extension ApiLocalizationExtension on String {
  /// Get localized value for this string field
  Future<String> getLocalized(String? arValue, String? enValue) async {
    final currentLang = LanguageService.instance.currentLanguage;
    return ApiLocalizationHelper.getLocalizedValue(arValue, enValue, currentLang);
  }
}