# دليل استكشاف أخطاء الترجمة

## 🚨 **المشكلة الحالية**
الـ localization بيتم بس النصوص مش بتتغير، بس الـ directionality (اتجاه النص) بيشتغل.

## 🔍 **الأسباب المحتملة**

### 1. **مشكلة في Bloc State Management**
```dart
// المشكلة: Bloc مش بيحدث الـ UI بشكل صحيح
BlocBuilder<LanguageBloc, LanguageState>(
  builder: (context, languageState) {
    // languageState مش بيتم تحديثه
  },
)
```

### 2. **مشكلة في AppLocalizations**
```dart
// المشكلة: AppLocalizations مش بيتم تحديثه
final l10n = AppLocalizations.of(context)!;
Text(l10n.home) // النص مش بيتغير
```

### 3. **مشكلة في Locale Resolution**
```dart
// المشكلة: Locale مش بيتم تحديثه في MaterialApp
locale: currentLocale, // مش بيتم تحديثه
```

## ✅ **الحلول المطبقة**

### **الحل 1: استخدام LocalizedApp منفصل**
```dart
// في main.dart
child: const LocalizedApp(), // 👈 استخدام LocalizedApp المنفصل
```

### **الحل 2: إضافة Language Test Section**
```dart
// في ProfileScreen
Widget _buildLanguageTestSection() {
  return BlocBuilder<LanguageBloc, LanguageState>(
    builder: (context, languageState) {
      final currentLanguage = languageState is LanguageLoaded 
          ? languageState.currentLanguage 
          : LanguageService.instance.currentLanguage;
      
      return Container(
        child: Column(
          children: [
            Text('Current: $currentLanguage'),
            ElevatedButton(
              onPressed: () {
                context.read<LanguageBloc>().add(LanguageChanged('ar'));
              },
              child: Text('العربية'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<LanguageBloc>().add(LanguageChanged('en'));
              },
              child: Text('English'),
            ),
          ],
        ),
      );
    },
  );
}
```

### **الحل 3: إنشاء LanguageTestWidget**
```dart
// في localized_app.dart
class LanguageTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final l10n = AppLocalizations.of(context)!;
        final currentLanguage = languageState is LanguageLoaded 
            ? languageState.currentLanguage 
            : 'ar';
        
        return Scaffold(
          appBar: AppBar(title: Text(l10n.home)),
          body: Column(
            children: [
              Text('Current Language: $currentLanguage'),
              Text(l10n.home),
              Text(l10n.workout),
              Text(l10n.settings),
              // ... المزيد من النصوص
            ],
          ),
        );
      },
    );
  }
}
```

## 🧪 **خطوات الاختبار**

### **الخطوة 1: اختبار Bloc State**
```dart
// أضف هذا في أي Widget
BlocBuilder<LanguageBloc, LanguageState>(
  builder: (context, languageState) {
    print('Language State: ${languageState.runtimeType}');
    if (languageState is LanguageLoaded) {
      print('Current Language: ${languageState.currentLanguage}');
    }
    return Container();
  },
)
```

### **الخطوة 2: اختبار AppLocalizations**
```dart
// أضف هذا في أي Widget
final l10n = AppLocalizations.of(context)!;
print('Home Text: ${l10n.home}');
print('Workout Text: ${l10n.workout}');
```

### **الخطوة 3: اختبار Locale**
```dart
// أضف هذا في أي Widget
final locale = Localizations.localeOf(context);
print('Current Locale: $locale');
```

## 🔧 **إصلاحات إضافية**

### **إصلاح 1: إضافة debugPrint**
```dart
// في LanguageBloc
@override
Stream<LanguageState> mapEventToState(LanguageEvent event) async* {
  if (event is LanguageChanged) {
    print('Language changed to: ${event.languageCode}');
    await _languageService.changeLanguage(event.languageCode);
    yield LanguageLoaded(event.languageCode);
    print('Language state emitted: ${event.languageCode}');
  }
}
```

### **إصلاح 2: إضافة BlocListener**
```dart
// في أي Widget
BlocListener<LanguageBloc, LanguageState>(
  listener: (context, state) {
    if (state is LanguageLoaded) {
      print('Language changed to: ${state.currentLanguage}');
      // إعادة بناء الـ Widget
      setState(() {});
    }
  },
  child: YourWidget(),
)
```

### **إصلاح 3: إضافة Key للـ MaterialApp**
```dart
MaterialApp.router(
  key: ValueKey(currentLocale.languageCode), // 👈 إضافة Key
  locale: currentLocale,
  // ... باقي الإعدادات
)
```

## 🎯 **النتيجة المتوقعة**

بعد تطبيق هذه الحلول:

1. ✅ **النصوص ستتغير** عند تغيير اللغة
2. ✅ **الـ directionality سيعمل** بشكل صحيح
3. ✅ **الـ Bloc state سيتحدث** بشكل صحيح
4. ✅ **الـ AppLocalizations سيعمل** بشكل صحيح

## 🚀 **الخطوات التالية**

1. **اختبر التطبيق** مع الأزرار الجديدة
2. **راقب الـ console** للأخطاء
3. **تأكد من تحديث النصوص** عند تغيير اللغة
4. **اختبر الـ directionality** (RTL/LTR)

إذا كانت المشكلة لا تزال موجودة، فالمشكلة قد تكون في:
- إعدادات الـ ARB files
- إعدادات الـ l10n.yaml
- إعدادات الـ pubspec.yaml
