import '../services/translation_service.dart';
import '../services/language_service.dart';

class ApiResponseHelper {
  static final TranslationService _translationService = TranslationService();

  /// Get localized value for any field based on current app language
  static Future<String> getLocalizedValue(String? arValue, String? enValue, String currentLang) async {
    return await _translationService.getLocalizedValue(arValue, enValue, currentLang);
  }

  /// Get localized value using current app language automatically
  static Future<String> getLocalizedValueAuto(String? arValue, String? enValue) async {
    return await _translationService.getLocalizedValueAuto(arValue, enValue);
  }

  /// Get translated value for any field - returns Arabic text (backward compatibility)
  static Future<String> getTranslatedValue(String? arValue, String? enValue) async {
    return await _translationService.getTranslatedValue(arValue, enValue);
  }

  /// Process a single text field from API response based on current language
  static Future<String> processTextField(Map<String, dynamic> data, String fieldName, {String? currentLang}) async {
    final arValue = data['${fieldName}_ar'] as String?;
    final enValue = data['${fieldName}_en'] as String?;
    
    // Use current language from parameter or auto-detect
    final lang = currentLang ?? LanguageService.instance.currentLanguage;
    
    // If no specific language fields, try the base field name
    if (arValue == null && enValue == null) {
      final baseValue = data[fieldName] as String?;
      if (baseValue != null && baseValue.trim().isNotEmpty) {
        // If current language is Arabic, translate from English to Arabic
        if (lang == 'ar') {
          return await _translationService.translateToArabic(baseValue);
        } else {
          // If current language is English, use the base value directly
          return baseValue.trim();
        }
      }
    }
    
    return await getLocalizedValue(arValue, enValue, lang);
  }

  /// Process multiple text fields from API response
  static Future<Map<String, String>> processTextFields(
    Map<String, dynamic> data,
    List<String> fieldNames, {
    String? currentLang,
  }) async {
    final Map<String, String> results = {};
    
    for (String fieldName in fieldNames) {
      results[fieldName] = await processTextField(data, fieldName, currentLang: currentLang);
    }
    
    return results;
  }

  /// Process a list of items with text fields
  static Future<List<Map<String, dynamic>>> processListItems(
    List<dynamic> items,
    List<String> textFields, {
    String? currentLang,
  }) async {
    final List<Map<String, dynamic>> processedItems = [];
    
    for (var item in items) {
      if (item is Map<String, dynamic>) {
        final Map<String, dynamic> processedItem = Map.from(item);
        
        // Process each text field
        for (String fieldName in textFields) {
          final localizedValue = await processTextField(item, fieldName, currentLang: currentLang);
          processedItem[fieldName] = localizedValue;
        }
        
        processedItems.add(processedItem);
      }
    }
    
    return processedItems;
  }

  /// Process nested objects with text fields
  static Future<Map<String, dynamic>> processNestedObject(
    Map<String, dynamic> data,
    String nestedKey,
    List<String> textFields,
  ) async {
    final Map<String, dynamic> result = Map.from(data);
    
    if (data.containsKey(nestedKey) && data[nestedKey] is Map<String, dynamic>) {
      final nestedData = data[nestedKey] as Map<String, dynamic>;
      final Map<String, dynamic> processedNested = Map.from(nestedData);
      
      for (String fieldName in textFields) {
        final translatedValue = await processTextField(nestedData, fieldName);
        processedNested[fieldName] = translatedValue;
      }
      
      result[nestedKey] = processedNested;
    }
    
    return result;
  }

  /// Process paginated response with text fields
  static Future<Map<String, dynamic>> processPaginatedResponse(
    Map<String, dynamic> response,
    List<String> textFields,
  ) async {
    final Map<String, dynamic> result = Map.from(response);
    
    if (response.containsKey('data') && response['data'] is List) {
      final List<dynamic> items = response['data'] as List;
      result['data'] = await processListItems(items, textFields);
    }
    
    return result;
  }

  /// Common field names that typically need translation
  static const List<String> commonTextFields = [
    'title',
    'name',
    'description',
    'content',
    'message',
    'label',
    'text',
    'subtitle',
    'summary',
    'details',
    'instruction',
    'note',
    'comment',
    'category',
    'type',
    'status',
    'reason',
    'address',
    'location',
  ];

  /// Auto-detect text fields in API response
  static List<String> detectTextFields(Map<String, dynamic> data) {
    final List<String> textFields = [];
    
    for (String key in data.keys) {
      // Check if it's a text field (not ending with _ar or _en)
      if (!key.endsWith('_ar') && !key.endsWith('_en')) {
        final value = data[key];
        if (value is String && value.trim().isNotEmpty) {
          // Check if it looks like text content
          if (value.length > 2 && !RegExp(r'^\d+$').hasMatch(value)) {
            textFields.add(key);
          }
        }
      }
    }
    
    return textFields;
  }

  /// Process entire API response automatically
  static Future<Map<String, dynamic>> processApiResponse(
    Map<String, dynamic> response, {
    List<String>? specificFields,
    String? currentLang,
  }) async {
    final Map<String, dynamic> result = Map.from(response);
    
    // Use current language from parameter or auto-detect
    final lang = currentLang ?? LanguageService.instance.currentLanguage;
    
    // Determine which fields to process
    List<String> fieldsToProcess = specificFields ?? [];
    
    if (fieldsToProcess.isEmpty) {
      // Auto-detect text fields
      fieldsToProcess = detectTextFields(response);
    }
    
    // Process top-level fields
    for (String fieldName in fieldsToProcess) {
      if (response.containsKey(fieldName)) {
        final localizedValue = await processTextField(response, fieldName, currentLang: lang);
        result[fieldName] = localizedValue;
      }
    }
    
    // Process nested data arrays
    if (response.containsKey('data') && response['data'] is List) {
      final List<dynamic> items = response['data'] as List;
      result['data'] = await processListItems(items, fieldsToProcess, currentLang: lang);
    }
    
    // Process other common nested structures
    final List<String> nestedKeys = ['items', 'results', 'products', 'exercises', 'categories'];
    for (String key in nestedKeys) {
      if (response.containsKey(key) && response[key] is List) {
        final List<dynamic> items = response[key] as List;
        result[key] = await processListItems(items, fieldsToProcess, currentLang: lang);
      }
    }
    
    return result;
  }
}
