import '../helpers/api_response_helper.dart';
import '../services/language_service.dart';

/// مثال عملي لاستخدام البيانات الحقيقية من API
class RealApiExample {
  
  /// مثال لمعالجة بيانات التمارين الحقيقية من API
  static Future<void> processRealExerciseData() async {
    // البيانات الحقيقية من API كما في الصورة
    final realApiResponse = {
      'status': 'success',
      'data': [
        {
          'id': 1,
          'exercise_category_id': 1,
          'ar_name': '1 تمرين', // البيانات العربية الموجودة
          'ar_description': null, // فارغة
          'en_name': 'Exercise 1', // البيانات الإنجليزية
          'en_description': null, // فارغة
          'gif': 'exercises/gifs/01K1QR7EHW7CNB6KG3PVPEEGV9.gif',
          'gender': 'male',
          'created_at': '2025-08-03T10:39:20.000000Z',
          'updated_at': '2025-08-31T17:44:49.000000Z',
          'day_id': 3,
          'goal': 'General Fitness'
        },
        {
          'id': 3,
          'exercise_category_id': 2,
          'ar_name': '3 تمرين', // البيانات العربية الموجودة
          'ar_description': null, // فارغة
          'en_name': 'Exercise 3', // البيانات الإنجليزية
          'en_description': null, // فارغة
          'gif': 'exercises/gifs/01K1QR8WMRXHF0386JWAZKZX6T.gif',
          'gender': 'both',
          'created_at': '2025-08-03T10:40:07.000000Z',
          'updated_at': '2025-08-31T17:44:19.000000Z',
          'day_id': 1,
          'goal': 'Weight Loss'
        }
      ]
    };

    // تعيين اللغة إلى العربية
    await LanguageService.instance.changeLanguage('ar');
    
    // معالجة البيانات مع الترجمة التلقائية
    final processedResponse = await ApiResponseHelper.processApiResponse(
      realApiResponse,
      specificFields: ['name', 'description', 'goal'],
    );

    print('البيانات المعالجة:');
    for (var exercise in processedResponse['data']) {
      print('التمرين: ${exercise['name']}'); // سيكون مترجم من الإنجليزية إلى العربية
      print('الهدف: ${exercise['goal']}'); // سيكون مترجم من الإنجليزية إلى العربية
    }
  }

  /// مثال لاستخدام البيانات في واجهة المستخدم
  static Future<List<Map<String, dynamic>>> getExercisesForUI() async {
    try {
      // محاكاة استدعاء API الحقيقي
      final apiResponse = {
        'status': 'success',
        'data': [
          {
            'id': 1,
            'ar_name': '1 تمرين',
            'ar_description': null,
            'en_name': 'Exercise 1',
            'en_description': null,
            'gif': 'exercises/gifs/01K1QR7EHW7CNB6KG3PVPEEGV9.gif',
            'gender': 'male',
            'goal': 'General Fitness'
          },
          {
            'id': 3,
            'ar_name': '3 تمرين',
            'ar_description': null,
            'en_name': 'Exercise 3',
            'en_description': null,
            'gif': 'exercises/gifs/01K1QR8WMRXHF0386JWAZKZX6T.gif',
            'gender': 'both',
            'goal': 'Weight Loss'
          }
        ]
      };

      // الحصول على اللغة الحالية
      final currentLang = LanguageService.instance.currentLanguage;
      
      // معالجة البيانات
      final processedResponse = await ApiResponseHelper.processApiResponse(
        apiResponse,
        specificFields: ['name', 'description', 'goal'],
        currentLang: currentLang,
      );

      return processedResponse['data'] ?? [];
    } catch (e) {
      print('خطأ في جلب البيانات: $e');
      return [];
    }
  }

  /// مثال لاستخدام البيانات في نموذج التمرين
  static Future<ExerciseModel> createExerciseFromApi(Map<String, dynamic> apiData) async {
    // إنشاء النموذج من البيانات الخام
    final exercise = ExerciseModel.fromJson(apiData);
    
    // معالجة الحقول القابلة للترجمة
    await exercise.processTextFields(apiData, [
      'name',
      'description', 
      'goal',
    ]);
    
    return exercise;
  }
}

/// نموذج التمرين المحدث
class ExerciseModel {
  final int id;
  String name;
  String? description;
  String? goal;
  final String gif;
  final String gender;

  ExerciseModel({
    required this.id,
    required this.name,
    this.description,
    this.goal,
    required this.gif,
    required this.gender,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '', // سيتم تحديثه بالترجمة
      description: json['description'],
      goal: json['goal'],
      gif: json['gif'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  /// معالجة الحقول القابلة للترجمة
  Future<void> processTextFields(Map<String, dynamic> data, List<String> fieldNames) async {
    for (String fieldName in fieldNames) {
      final arValue = data['ar_$fieldName'] as String?;
      final enValue = data['en_$fieldName'] as String?;
      
      // الحصول على القيمة المترجمة
      final translatedValue = await ApiResponseHelper.getLocalizedValueAuto(arValue, enValue);
      
      // تطبيق القيمة المترجمة على النموذج
      switch (fieldName) {
        case 'name':
          name = translatedValue;
          break;
        case 'description':
          description = translatedValue;
          break;
        case 'goal':
          goal = translatedValue;
          break;
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'goal': goal,
      'gif': gif,
      'gender': gender,
    };
  }
}
