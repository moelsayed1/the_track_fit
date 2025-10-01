# دليل التطبيق العملي لنظام الترجمة

## ✅ **ما تم تطبيقه فعلياً في الكود**

### 1. **إعداد Localization في main.dart** ✅
```dart
return MaterialApp.router(
  locale: currentLocale, // 👈 اللغة حسب الـ Bloc
  supportedLocales: const [
    Locale('en'),
    Locale('ar'),
  ],
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  localeResolutionCallback: (locale, supportedLocales) {
    return supportedLocales.contains(locale) ? locale : const Locale('ar');
  },
);
```

### 2. **استبدال النصوص المكتوبة بيدوياً بـ ARB** ✅

#### **قبل التطبيق:**
```dart
Text("Home")
Text("Products")
Text("Settings")
Text("Language")
```

#### **بعد التطبيق:**
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.home)        // "Home" / "الرئيسية"
Text(l10n.newProducts) // "New Products" / "منتجات جديدة"
Text(l10n.settings)    // "Settings" / "الإعدادات"
Text(l10n.language)    // "Language" / "اللغة"
```

### 3. **تطبيق الترجمة على بيانات API** ✅

#### **مثال عملي:**
```dart
// استجابة API الحقيقية
final apiResponse = {
  'data': [
    {
      'id': 1,
      'ar_name': '1 تمرين',
      'en_name': 'Exercise 1',
      'ar_description': null,
      'en_description': 'A basic upper body exercise',
    }
  ]
};

// تطبيق الترجمة
final processedResponse = await ApiLocalizationHelper.processApiResponse(
  apiResponse,
  specificFields: ['name', 'description'],
);

// النتيجة: البيانات ستكون مترجمة حسب اللغة المختارة
```

### 4. **ربط زر تغيير اللغة بـ Bloc** ✅

#### **في Language Selector:**
```dart
GestureDetector(
  onTap: () {
    // 👈 استخدام Bloc بدل LanguageService مباشرة
    context.read<LanguageBloc>().add(LanguageChanged(languageCode));
  },
  child: Container(/* ... */),
)
```

#### **في Profile Screen:**
```dart
Future<void> _toggleLanguage() async {
  final currentLang = LanguageService.instance.currentLanguage;
  final newLang = currentLang == 'ar' ? 'en' : 'ar';
  
  // تغيير اللغة باستخدام Bloc
  context.read<LanguageBloc>().add(LanguageChanged(newLang));
}
```

### 5. **تحديث Bloc للاستجابة لتغيير اللغة** ✅

#### **النتيجة:**
- ✅ **النصوص الثابتة تتحدث أوتوماتيك** عند تغيير اللغة
- ✅ **البيانات الجديدة من API تترجم** حسب اللغة المختارة
- ✅ **التطبيق يعمل فعلياً Multi-language**

## 🎯 **النتائج المحققة**

### **1. النصوص الثابتة (Static UI)**
```dart
// قبل التطبيق
Text("Home")           // دائماً إنجليزي
Text("Products")       // دائماً إنجليزي
Text("Settings")       // دائماً إنجليزي

// بعد التطبيق
Text(l10n.home)        // "Home" أو "الرئيسية" حسب اللغة
Text(l10n.newProducts) // "New Products" أو "منتجات جديدة"
Text(l10n.settings)    // "Settings" أو "الإعدادات"
```

### **2. بيانات API (Dynamic Data)**
```dart
// قبل التطبيق
Text(exercise['en_name']) // دائماً إنجليزي

// بعد التطبيق
Text(exercise['name'])    // مترجم تلقائياً حسب اللغة
```

### **3. تغيير اللغة**
```dart
// قبل التطبيق
await LanguageService.instance.changeLanguage('ar');
// لا يحدث شيء في الواجهة

// بعد التطبيق
context.read<LanguageBloc>().add(LanguageChanged('ar'));
// الواجهة تتحدث فوراً!
```

## 📱 **كيفية الاستخدام في التطبيق**

### **1. في أي Widget جديد:**
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        Text(l10n.home),        // 👈 من ARB
        Text(l10n.workout),     // 👈 من ARB
        Text(l10n.settings),    // 👈 من ARB
      ],
    );
  }
}
```

### **2. في Repository جديد:**
```dart
class MyRepository {
  Future<List<MyModel>> getData() async {
    final response = await ApiService().get('/api/endpoint');
    
    // 👈 معالجة البيانات مع الترجمة
    final processedResponse = await ApiLocalizationHelper.processApiResponse(
      response.data,
      specificFields: ['title', 'description'],
    );
    
    return (processedResponse['data'] as List)
        .map((json) => MyModel.fromJson(json))
        .toList();
  }
}
```

### **3. لإضافة زر تغيير اللغة:**
```dart
ElevatedButton(
  onPressed: () {
    context.read<LanguageBloc>().add(LanguageChanged('ar'));
  },
  child: Text("العربية"),
),

ElevatedButton(
  onPressed: () {
    context.read<LanguageBloc>().add(LanguageChanged('en'));
  },
  child: Text("English"),
),
```

## 🔧 **إضافة نصوص جديدة**

### **1. إضافة إلى ARB files:**
```json
// lib/l10n/app_en.arb
{
  "newText": "New Text"
}

// lib/l10n/app_ar.arb
{
  "newText": "نص جديد"
}
```

### **2. استخدام في الكود:**
```dart
Text(l10n.newText) // "New Text" أو "نص جديد"
```

### **3. إعادة توليد الملفات:**
```bash
flutter pub get
```

## 🎉 **النتيجة النهائية**

✅ **النظام يعمل فعلياً في التطبيق!**

- **النصوص الثابتة**: تتحدث أوتوماتيك عند تغيير اللغة
- **بيانات API**: تترجم تلقائياً حسب اللغة المختارة  
- **تغيير اللغة**: يحدث الواجهة فوراً باستخدام Bloc
- **سهولة الصيانة**: إضافة نصوص جديدة بسهولة

**التطبيق الآن يدعم فعلياً اللغتين العربية والإنجليزية!** 🚀
