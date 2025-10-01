import 'dart:developer';
import '../helpers/api_response_helper.dart';
import '../services/language_service.dart';

/// اختبار الترجمة
class TestTranslation {
  
  /// اختبار بسيط للترجمة
  static Future<void> testBasicTranslation() async {
    log('=== بدء اختبار الترجمة ===');
    
    // تعيين اللغة إلى العربية
    await LanguageService.instance.changeLanguage('ar');
    log('اللغة الحالية: ${LanguageService.instance.currentLanguage}');
    
    // بيانات تجريبية
    final testData = {
      'ar_name': '1 تمرين',        // العربية من API
      'en_name': 'Exercise 1',     // الإنجليزية من API
      'ar_description': null,      // فارغة
      'en_description': 'A basic upper body exercise', // الإنجليزية
    };
    
    // اختبار الترجمة
    final translatedName = await ApiResponseHelper.getLocalizedValueAuto(
      testData['ar_name'],
      testData['en_name'],
    );
    
    log('الاسم المترجم: $translatedName');
    
    final translatedDescription = await ApiResponseHelper.getLocalizedValueAuto(
      testData['ar_description'],
      testData['en_description'],
    );
    
    log('الوصف المترجم: $translatedDescription');
    
    // اختبار مع اللغة الإنجليزية
    await LanguageService.instance.changeLanguage('en');
    log('اللغة الحالية: ${LanguageService.instance.currentLanguage}');
    
    final englishName = await ApiResponseHelper.getLocalizedValueAuto(
      testData['ar_name'],
      testData['en_name'],
    );
    
    log('الاسم بالإنجليزية: $englishName');
  }
  
  /// اختبار معالجة البيانات الكاملة
  static Future<void> testFullDataProcessing() async {
    log('=== اختبار معالجة البيانات الكاملة ===');
    
    // تعيين اللغة إلى العربية
    await LanguageService.instance.changeLanguage('ar');
    
    // البيانات الكاملة من API
    final apiResponse = {
      'status': 'success',
      'data': [
        {
          'id': 1,
          'ar_name': '1 تمرين',
          'en_name': 'Exercise 1',
          'ar_description': null,
          'en_description': 'A basic upper body exercise',
          'goal': 'General Fitness'
        },
        {
          'id': 2,
          'ar_name': '2 تمرين',
          'en_name': 'Exercise 2',
          'ar_description': null,
          'en_description': 'A cardio workout',
          'goal': 'Weight Loss'
        }
      ]
    };
    
    // معالجة البيانات
    final processedResponse = await ApiResponseHelper.processApiResponse(
      apiResponse,
      specificFields: ['name', 'description', 'goal'],
    );
    
    log('البيانات المعالجة:');
    for (var exercise in processedResponse['data']) {
      log('التمرين: ${exercise['name']}');
      log('الوصف: ${exercise['description']}');
      log('الهدف: ${exercise['goal']}');
      log('---');
    }
  }
  
  /// اختبار سريع للترجمة
  static Future<void> quickTest() async {
    log('=== اختبار سريع ===');
    
    // تعيين اللغة إلى العربية
    await LanguageService.instance.changeLanguage('ar');
    
    // اختبار ترجمة بسيطة
    final result = await ApiResponseHelper.getLocalizedValueAuto(
      '1 تمرين',      // العربية
      'Exercise 1',   // الإنجليزية
    );
    
    log('النتيجة: $result');
    
    // يجب أن تكون النتيجة: "تمرين 1" (مترجم من الإنجليزية)
  }
}
