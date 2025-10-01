# دليل ترجمة البيانات القادمة من API

## نظرة عامة

تم تطبيق نظام ترجمة شامل للبيانات القادمة من API في تطبيق Track Fit. النظام يدعم الترجمة التلقائية للبيانات بين العربية والإنجليزية بناءً على اللغة المختارة في التطبيق.

## المكونات الرئيسية

### 1. ApiLocalizationHelper

```dart
import 'package:the_track_fit/core/helpers/api_localization_helper.dart';

// الحصول على قيمة مترجمة
String localizedValue = await ApiLocalizationHelper.getLocalizedValue(
  arValue,    // القيمة العربية
  enValue,    // القيمة الإنجليزية
  currentLang // اللغة الحالية ('ar' أو 'en')
);

// الحصول على قيمة مترجمة بشكل متزامن
String localizedValue = ApiLocalizationHelper.getLocalizedValueSync(
  arValue,
  enValue,
  currentLang
);
```

### 2. النماذج المحدثة

#### نموذج المنتج (Product)
```dart
// الحصول على الاسم المترجم
String productName = product.name; // يستخدم الترجمة تلقائياً

// الحصول على الوصف المترجم
String productDescription = product.description; // يستخدم الترجمة تلقائياً

// الحصول على القيم المترجمة بشكل غير متزامن مع الترجمة
String localizedName = await product.localizedName;
String localizedDescription = await product.localizedDescription;
```

#### نموذج التمرين (Exercise)
```dart
// الحصول على الاسم المترجم
String exerciseName = exercise.localizedName;

// الحصول على الوصف المترجم
String exerciseDescription = exercise.localizedDescription;

// الحصول على القيم المترجمة بشكل غير متزامن مع الترجمة
String localizedName = await exercise.localizedNameAsync;
String localizedDescription = await exercise.localizedDescriptionAsync;
```

#### نموذج السؤال (Question)
```dart
// الحصول على النص المترجم
String questionText = question.localizedText;

// الحصول على النص المترجم بشكل غير متزامن مع الترجمة
String localizedText = await question.localizedTextAsync;
```

#### نموذج خيارات السؤال (QuestionOption)
```dart
// الحصول على النص المترجم
String optionText = option.localizedText;

// الحصول على النص المترجم بشكل غير متزامن مع الترجمة
String localizedText = await option.localizedTextAsync;
```

## كيفية عمل النظام

### 1. البيانات القادمة من API

البيانات القادمة من API تحتوي على حقول عربية وإنجليزية:

```json
{
  "id": 1,
  "ar_name": "منتج 1",
  "en_name": "Product 1",
  "ar_description": "وصف المنتج بالعربية",
  "en_description": "Product description in English",
  "price": "100.00"
}
```

### 2. آلية الترجمة

- **إذا كانت اللغة المختارة هي الإنجليزية**: يتم عرض القيمة الإنجليزية مباشرة
- **إذا كانت اللغة المختارة هي العربية**:
  - إذا كانت القيمة العربية موجودة وغير فارغة: يتم عرضها مباشرة
  - إذا كانت القيمة العربية غير موجودة أو فارغة: يتم ترجمة القيمة الإنجليزية إلى العربية باستخدام Google Translate

### 3. الترجمة التلقائية

النماذج تقوم بترجمة البيانات تلقائياً عند إنشائها من API response:

```dart
// في نموذج المنتج
factory Product.fromJson(Map<String, dynamic> json) {
  return Product(
    id: json['id'] as int,
    enName: json['en_name'] as String,
    arName: json['ar_name'] as String,
    enDescription: json['en_description'] as String,
    arDescription: json['ar_description'] as String,
    // ... باقي الحقول
  );
}

// الـ getter للاسم المترجم
String get name {
  final currentLang = LanguageService.instance.currentLanguage;
  return ApiLocalizationHelper.getLocalizedValueSync(arName, enName, currentLang);
}
```

## أمثلة على الاستخدام

### 1. في شاشة المنتجات

```dart
// عرض اسم المنتج
Text(
  product.name, // يستخدم الترجمة تلقائياً
  style: TextStyle(fontSize: 16),
)

// عرض وصف المنتج
Text(
  product.description, // يستخدم الترجمة تلقائياً
  style: TextStyle(fontSize: 14),
)
```

### 2. في شاشة التمارين

```dart
// عرض اسم التمرين
Text(
  exercise.localizedName, // يستخدم الترجمة تلقائياً
  style: TextStyle(fontSize: 16),
)

// عرض وصف التمرين
Text(
  exercise.localizedDescription, // يستخدم الترجمة تلقائياً
  style: TextStyle(fontSize: 14),
)
```

### 3. في شاشة الأسئلة

```dart
// عرض نص السؤال
Text(
  question.localizedText, // يستخدم الترجمة تلقائياً
  style: TextStyle(fontSize: 18),
)

// عرض خيارات السؤال
for (final option in question.options!) {
  Text(
    option.localizedText, // يستخدم الترجمة تلقائياً
    style: TextStyle(fontSize: 16),
  )
}
```

## تحديث البيانات عند تغيير اللغة

عند تغيير اللغة في التطبيق، يتم تحديث البيانات تلقائياً لأن النماذج تستخدم `LanguageService.instance.currentLanguage` في الـ getters.

## معالجة الأخطاء

إذا فشلت الترجمة من Google Translate، يتم عرض القيمة الإنجليزية كبديل:

```dart
try {
  final translation = await _translator.translate(enValue, from: 'en', to: 'ar');
  return translation.text;
} catch (e) {
  // إذا فشلت الترجمة، يتم عرض القيمة الإنجليزية
  return enValue;
}
```

## نصائح للاستخدام

1. **استخدم الـ getters المترجمة**: استخدم `product.name` بدلاً من `product.enName`
2. **تجنب الوصول المباشر للحقول**: لا تستخدم `product.arName` أو `product.enName` مباشرة
3. **استخدم الترجمة غير المتزامنة عند الحاجة**: استخدم `await product.localizedName` إذا كنت تريد ترجمة فورية
4. **تأكد من تحديث اللغة**: استخدم `LanguageService.instance.currentLanguage` للحصول على اللغة الحالية

## الملفات المحدثة

- `lib/core/helpers/api_localization_helper.dart` - Helper class للترجمة
- `lib/features/store/domain/models/product.dart` - نموذج المنتج مع الترجمة
- `lib/features/workout/domain/models/exercise.dart` - نموذج التمرين مع الترجمة
- `lib/features/questions/domain/models/question.dart` - نموذج السؤال مع الترجمة
- `lib/features/questions/domain/models/question_option.dart` - نموذج خيارات السؤال مع الترجمة
- `lib/features/workout/data/repositories/exercise_repository.dart` - repository التمارين المحدث
- `lib/features/store/presentation/ui/screens/product_detail_screen.dart` - شاشة تفاصيل المنتج المحدثة
- `lib/features/questions/diet_system/ui/widgets/diet_system_question_body.dart` - شاشة أسئلة النظام الغذائي المحدثة

## الخلاصة

النظام الآن يدعم الترجمة التلقائية للبيانات القادمة من API. عند تغيير اللغة في التطبيق، ستظهر جميع البيانات باللغة المختارة تلقائياً، مع دعم الترجمة التلقائية للبيانات التي لا تحتوي على ترجمة عربية.
