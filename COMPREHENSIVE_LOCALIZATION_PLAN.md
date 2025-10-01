# خطة الترجمة الشاملة للتطبيق

## 📋 **النصوص المكتشفة التي تحتاج ترجمة**

### **1. نصوص Profile Screen**
```dart
// في lib/features/profile/presentation/screens/profile_screen.dart
"Products" → l10n.products
"Notifications" → l10n.notifications  
"Main Goal" → l10n.mainGoal
"Favourite Exercise" → l10n.favouriteExercise
"Language" → l10n.language
"English" → l10n.english
```

### **2. نصوص Auth Screens**
```dart
// في lib/features/auth/login/presentation/screens/login_screen.dart
"Log In" → l10n.login
"Welcome Back" → l10n.welcomeBack

// في lib/features/auth/signup/presentation/signup_screen.dart
"Enter your email and password for login" → l10n.loginInstructions

// في lib/features/onboarding/presentation/screens/onboarding_pageview_screen.dart
"Register" → l10n.register
```

### **3. نصوص Report Screen**
```dart
// في lib/features/report/presentation/screens/report_screen.dart
"This Week" → l10n.thisWeek
"Statistics" → l10n.statistics
"Today" → l10n.today
"Last week" → l10n.lastWeek
"Last Month" → l10n.lastMonth
"Minutes" → l10n.minutes
"Kcal" → l10n.kcal
```

### **4. نصوص Error Messages**
```dart
// في جميع الملفات
"Error" → l10n.error
"OK" → l10n.ok
"Retry" → l10n.retry
"Try Again" → l10n.tryAgain
"Browse Products" → l10n.browseProducts
```

### **5. نصوص Store/Products**
```dart
// في lib/features/store/presentation/screens/favorite_products_screen.dart
"Favorite Products" → l10n.favoriteProducts
"Product added to cart successfully" → l10n.productAddedToCart
"Product removed from cart" → l10n.productRemovedFromCart
```

### **6. نصوص Workout/Exercise**
```dart
// في lib/features/workout/presentation/screens/scan_exercise_screen.dart
"Error" → l10n.error
"OK" → l10n.ok
```

### **7. نصوص Questions**
```dart
// في lib/features/questions/data/services/questions_service.dart
"Age" → l10n.age
"Height" → l10n.height
"Current Weight" → l10n.currentWeight
"Target Weight" → l10n.targetWeight
"Main Goal" → l10n.mainGoal
"Current Activity Level" → l10n.currentActivityLevel
"Preferred Training Types" → l10n.preferredTrainingTypes
"Available Equipment" → l10n.availableEquipment
"Current Diet System" → l10n.currentDietSystem
"Health Status" → l10n.healthStatus
```

### **8. نصوص Profile Widgets**
```dart
// في lib/features/profile/presentation/widgets/
"Plan Includes" → l10n.planIncludes
"Increase Muscle" → l10n.increaseMuscle
```

## 🎯 **خطة التطبيق**

### **المرحلة 1: إضافة النصوص المفقودة إلى ARB**
### **المرحلة 2: تحديث الملفات لاستخدام الترجمة**
### **المرحلة 3: اختبار النظام الكامل**
