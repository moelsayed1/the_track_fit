# دليل استخدام LocalizedText Widgets

## نظرة عامة
تم إنشاء مجموعة من الـ widgets المخصصة التي تختار الخط المناسب تلقائياً حسب اللغة المختارة:
- **العربية**: خط Cairo
- **الإنجليزية**: خط Poppins

## الـ Widgets المتاحة

### 1. LocalizedText
الـ widget الأساسي الذي يطبق الخط المناسب تلقائياً.

```dart
LocalizedText(
  'النص المراد عرضه',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  textAlign: TextAlign.center,
)
```

### 2. LocalizedHeading
للعناوين الرئيسية والفرعية.

```dart
LocalizedHeading(
  'عنوان رئيسي',
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Color(0xFF28A228),
)
```

### 3. LocalizedBodyText
للنصوص الأساسية في التطبيق.

```dart
LocalizedBodyText(
  'نص أساسي في التطبيق',
  fontSize: 16,
  fontWeight: FontWeight.normal,
  height: 1.5,
)
```

### 4. LocalizedCaption
للنصوص التوضيحية الصغيرة.

```dart
LocalizedCaption(
  'نص توضيحي صغير',
  fontSize: 12,
  color: Colors.grey[600],
)
```

### 5. LocalizedButtonText
لنصوص الأزرار.

```dart
LocalizedButtonText(
  'زر',
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: Colors.white,
)
```

## كيفية الاستخدام

### 1. استيراد الـ Widget
```dart
import 'package:the_track_fit/core/widgets/localized_text.dart';
```

### 2. استخدام الـ Widget
```dart
// بدلاً من
Text(
  'النص',
  style: TextStyle(
    fontFamily: 'Poppins', // أو 'Cairo'
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
  ),
)

// استخدم
LocalizedText(
  'النص',
  fontSize: 16,
  fontWeight: FontWeight.w500,
)
```

### 3. استخدام Extensions
```dart
// للحصول على الخط المناسب
String fontFamily = context.localizedFontFamily;

// لتطبيق الخط على TextStyle موجود
TextStyle style = TextStyle(fontSize: 16).localized;
```

## المميزات

### ✅ اختيار الخط التلقائي
- يختار خط Cairo للعربية تلقائياً
- يختار خط Poppins للإنجليزية تلقائياً

### ✅ دعم جميع خصائص Text
- fontSize, fontWeight, color
- textAlign, maxLines, overflow
- decoration, height, letterSpacing
- wordSpacing

### ✅ سهولة الاستخدام
- نفس واجهة Text widget
- لا حاجة لتحديد fontFamily يدوياً
- دعم كامل للـ ScreenUtil

### ✅ تحديث تلقائي
- يتحدث الخط تلقائياً عند تغيير اللغة
- يعمل مع LanguageBloc
- لا حاجة لإعادة بناء الـ widget يدوياً

## أمثلة عملية

### في ProfileScreen
```dart
// قبل التحديث
Text(
  displayName,
  style: TextStyle(
    color: const Color(0xFF1E1E1E),
    fontSize: 16.sp,
    fontFamily: 'Poppins', // خط ثابت
    fontWeight: FontWeight.w500,
  ),
)

// بعد التحديث
LocalizedText(
  displayName,
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: const Color(0xFF1E1E1E),
  // الخط يتغير تلقائياً حسب اللغة
)
```

### في الأزرار
```dart
ElevatedButton(
  onPressed: () {},
  child: LocalizedButtonText(
    AppLocalizations.of(context)!.login,
    color: Colors.white,
  ),
)
```

### في العناوين
```dart
LocalizedHeading(
  AppLocalizations.of(context)!.welcome,
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Color(0xFF28A228),
)
```

## نصائح للاستخدام

### 1. استخدم LocalizedText بدلاً من Text
- في جميع النصوص الثابتة
- في النصوص الديناميكية
- في جميع شاشات التطبيق

### 2. استخدم الـ widgets المتخصصة
- LocalizedHeading للعناوين
- LocalizedBodyText للنصوص الأساسية
- LocalizedCaption للنصوص الصغيرة
- LocalizedButtonText للأزرار

### 3. لا تحدد fontFamily يدوياً
- دع الـ widget يختار الخط المناسب
- استخدم fontSize بدلاً من fontSize.sp
- استخدم fontWeight مباشرة

### 4. اختبر في كلا اللغتين
- تأكد من ظهور النصوص بشكل صحيح
- اختبر تغيير اللغة
- تأكد من تطبيق الخط المناسب

## مثال كامل

```dart
class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: LocalizedText(
          AppLocalizations.of(context)!.home,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان رئيسي
            LocalizedHeading(
              AppLocalizations.of(context)!.welcome,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF28A228),
            ),
            
            SizedBox(height: 16.h),
            
            // نص أساسي
            LocalizedBodyText(
              AppLocalizations.of(context)!.description,
              fontSize: 16,
              height: 1.5,
            ),
            
            SizedBox(height: 24.h),
            
            // زر
            ElevatedButton(
              onPressed: () {},
              child: LocalizedButtonText(
                AppLocalizations.of(context)!.getStarted,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 16.h),
            
            // نص توضيحي
            LocalizedCaption(
              AppLocalizations.of(context)!.note,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
```

## الخلاصة

هذه الـ widgets تجعل تطبيق الخطوط المناسبة أمراً سهلاً وتلقائياً، مما يحسن تجربة المستخدم ويوفر الوقت في التطوير. استخدمها في جميع أنحاء التطبيق لضمان تطبيق الخطوط الصحيحة في كلا اللغتين.
