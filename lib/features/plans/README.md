# Plans Feature

This feature contains the promotional offer screen for the Track Fit app.

## Components

### PromotionalOfferScreen
A full-screen responsive promotional offer display that appears after completing the question flow:
- Green gradient background matching the Figma design
- Alarm GIF animation at the top
- Limited time offer messaging
- 50% off pricing display
- Countdown timer
- Call-to-action button

### PromotionalOfferBody
The main UI component containing all the promotional offer elements with responsive sizing.

## Navigation Flow

The promotional offer screen is integrated into the app's question flow:

1. **User completes all questions** (Gender → Fitness Level → Height → Weight)
2. **Taps "Continue" on weight question** → Navigates to promotional offer
3. **User can either**:
   - Tap "Go Premium now" button → Navigates to home
   - Tap "Skip" button → Navigates to home
   - Tap close (X) button → Navigates to home

## Usage

```dart
import 'package:the_track_fit/features/plans/presentation/index.dart';

// Navigate to the promotional offer screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const PromotionalOfferScreen(),
  ),
);

// Or use GoRouter
context.push(AppRouter.promotionalOffer);
```

## Design Specifications

- **Responsive Design**: Uses Flutter ScreenUtil for adaptive sizing across all devices
- **Base dimensions**: 375 x 812 (iPhone X/11 Pro as reference)
- **Background**: Linear gradient from `#28A228` to `#5CD65C` (with transparency)
- **Primary text color**: White
- **Accent color**: `#FDC416` (Golden yellow for highlights)
- **Font family**: Poppins
- **Button**: White with green border and green text

## UI Layout

The screen follows a clean, centered layout:
1. **Top**: Skip button (left) and Close button (right)
2. **Alarm GIF**: 200x200 animated alarm clock illustration
3. **Content**: Limited Time Offer text
4. **Subtitle**: Cancel anytime No hidden fees
5. **Main Offer**: 50% OFF in large golden text
6. **Pricing**: Original price (struck through) and discounted price
7. **Countdown**: "Your Offer ends in" with timer
8. **CTA**: "Go Premium now" button at bottom

## Responsive Features

- **Width**: Uses `.w` extension for responsive widths
- **Height**: Uses `.h` extension for responsive heights
- **Font sizes**: Uses `.sp` extension for responsive text scaling
- **Radius**: Uses `.r` extension for responsive border radius
- **Spacing**: All margins and padding scale proportionally
- **Full screen**: Automatically adapts to any screen size

## Navigation Options

- **Skip Button**: Left-aligned, semi-transparent white background
- **Close Button**: Right-aligned, white X icon
- **CTA Button**: "Go Premium now" - navigates to home screen
- All navigation options lead to the home screen

## Assets

- **Alarm GIF**: Uses `assets/images/alarm.gif` for the animated alarm clock illustration
- All colors and spacing match the provided Figma code exactly
- Responsive scaling maintains design proportions across devices
