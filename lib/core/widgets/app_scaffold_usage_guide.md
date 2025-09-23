# AppScaffold Usage Guide

## Overview
The `AppScaffold` widget provides consistent top spacing (12.h by default) across all screens in your app.

## Basic Usage

### For Simple Screens
```dart
import 'package:the_track_fit/core/widgets/app_scaffold.dart';

@override
Widget build(BuildContext context) {
  return AppScaffold(
    backgroundColor: const Color(0xFFF6FFF6),
    body: Column(
      children: [
        // Your screen content here
        // The 12.h top spacing is automatically added
      ],
    ),
  );
}
```

### For Screens with Custom SafeArea
```dart
import 'package:the_track_fit/core/widgets/app_scaffold.dart';

@override
Widget build(BuildContext context) {
  return AppScaffoldWithCustomSafeArea(
    backgroundColor: const Color(0xFFF6FFF6),
    bottom: false, // Custom SafeArea behavior
    body: Column(
      children: [
        // Your screen content here
        // The 12.h top spacing is automatically added
      ],
    ),
  );
}
```

## Migration from Regular Scaffold

### Before (Regular Scaffold)
```dart
return Scaffold(
  backgroundColor: const Color(0xFFF6FFF6),
  body: SafeArea(
    child: Column(
      children: [
        // Your content
      ],
    ),
  ),
);
```

### After (AppScaffold)
```dart
return AppScaffold(
  backgroundColor: const Color(0xFFF6FFF6),
  body: Column(
    children: [
      // Your content
      // 12.h top spacing is automatically added
    ],
  ),
);
```

## Custom Top Spacing
You can customize the top spacing if needed:

```dart
return AppScaffold(
  topSpacing: 20.0, // Custom spacing
  backgroundColor: const Color(0xFFF6FFF6),
  body: Column(
    children: [
      // Your content
    ],
  ),
);
```

## Benefits
- ✅ Consistent 12.h top spacing across all screens
- ✅ Easy to maintain and update
- ✅ No need to manually add SizedBox(height: 12.h) to every screen
- ✅ Clean and organized code structure
- ✅ Customizable spacing when needed

## Implementation Status
- ✅ AppScaffold widget created
- ✅ Home screen updated
- ✅ Home screen feature updated  
- ✅ Store screen updated
- 🔄 Other screens can be updated following the same pattern
