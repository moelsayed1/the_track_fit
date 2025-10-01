# حل مشكلة الترجمة

## المشكلة
النظام لا يزال يعرض اللغة الإنجليزية بدلاً من العربية.

## الحلول المطبقة

### 1. تغيير اللغة الافتراضية
تم تغيير اللغة الافتراضية من الإنجليزية إلى العربية في `app_constants.dart`:

```dart
// قبل التعديل
static const String defaultLanguage = 'en';

// بعد التعديل
static const String defaultLanguage = 'ar';
```

### 2. اختبار الترجمة
استخدم هذا الكود لاختبار الترجمة:

```dart
import 'package:the_track_fit/core/examples/test_translation.dart';

// في أي مكان في التطبيق
await TestTranslation.quickTest();
```

### 3. كيفية التأكد من عمل الترجمة

#### الخطوة 1: تحقق من اللغة الحالية
```dart
print('اللغة الحالية: ${LanguageService.instance.currentLanguage}');
// يجب أن تطبع: ar
```

#### الخطوة 2: اختبار الترجمة البسيطة
```dart
final result = await ApiResponseHelper.getLocalizedValueAuto(
  '1 تمرين',      // العربية من API
  'Exercise 1',   // الإنجليزية من API
);
print('النتيجة: $result');
// يجب أن تطبع: "تمرين 1" (مترجم من الإنجليزية)
```

#### الخطوة 3: اختبار معالجة البيانات الكاملة
```dart
final apiResponse = {
  'data': [
    {
      'ar_name': '1 تمرين',
      'en_name': 'Exercise 1',
      'ar_description': null,
      'en_description': 'A basic exercise',
    }
  ]
};

final processedResponse = await ApiResponseHelper.processApiResponse(
  apiResponse,
  specificFields: ['name', 'description'],
);

print('الاسم: ${processedResponse['data'][0]['name']}');
// يجب أن تطبع: "تمرين 1" (مترجم من الإنجليزية)
```

### 4. إذا لم تعمل الترجمة

#### تحقق من الاتصال بالإنترنت
الترجمة تتطلب اتصال بالإنترنت لأنها تستخدم Google Translate.

#### تحقق من اللغة المحددة
```dart
// تأكد من أن اللغة محددة على العربية
await LanguageService.instance.changeLanguage('ar');
print('اللغة: ${LanguageService.instance.currentLanguage}');
```

#### تحقق من البيانات
تأكد أن البيانات تحتوي على الحقول الإنجليزية:
```dart
// البيانات يجب أن تحتوي على
{
  'ar_name': '1 تمرين',     // العربية (اختيارية)
  'en_name': 'Exercise 1',  // الإنجليزية (مطلوبة للترجمة)
}
```

### 5. مثال كامل للاستخدام

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _getExercises(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final exercise = snapshot.data![index];
              return ListTile(
                title: Text(exercise['name']), // سيكون مترجم تلقائياً
                subtitle: Text(exercise['description'] ?? ''),
              );
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
  
  Future<List<Map<String, dynamic>>> _getExercises() async {
    // استدعاء API
    final response = await ApiService().get('/api/get-all-exercises');
    
    // معالجة البيانات مع الترجمة
    final processedResponse = await ApiResponseHelper.processApiResponse(
      response.data,
      specificFields: ['name', 'description'],
    );
    
    return processedResponse['data'] ?? [];
  }
}
```

### 6. نصائح مهمة

1. **تأكد من الاتصال بالإنترنت** - الترجمة تتطلب إنترنت
2. **استخدم البيانات الإنجليزية** - النظام يترجم من الإنجليزية إلى العربية
3. **اختبر الترجمة أولاً** - استخدم `TestTranslation.quickTest()`
4. **تحقق من اللغة المحددة** - تأكد أن `currentLanguage` هو `'ar'`

### 7. إذا استمرت المشكلة

1. أعد تشغيل التطبيق
2. تأكد من تحديث `pubspec.yaml` مع `flutter pub get`
3. تحقق من وجود أخطاء في الكونسول
4. استخدم `TestTranslation.testBasicTranslation()` للتشخيص
