import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding3_screen.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding4_screen.dart';
import '../../../../core/widgets/page_indicator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/constants/app_colors.dart';
import 'onboarding1_screen.dart';
import 'onboarding2_screen.dart';

typedef OnNextPressed = void Function();
typedef OnCreateAccountPressed = void Function();

class OnboardingPageViewScreen extends StatefulWidget {
  const OnboardingPageViewScreen({super.key});

  @override
  State<OnboardingPageViewScreen> createState() => _OnboardingPageViewScreenState();
}

class _OnboardingPageViewScreenState extends State<OnboardingPageViewScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to home on last page
      context.go('/home');
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      body: Stack(
        children: [
          // PageView with onboarding screens
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              OnboardingScreenWrapper(
                screen: const Onboarding1Screen(),
                onNextPressed: _nextPage,
                showGetStarted: false,
              ),
              OnboardingScreenWrapper(
                screen: const Onboarding2Screen(),
                onNextPressed: _nextPage,
                showGetStarted: false,
              ),
              OnboardingScreenWrapper(
                screen: const Onboarding3Screen(),
                onNextPressed: _nextPage,
                showGetStarted: false,
              ),
              OnboardingScreenWrapper(
                screen: const Onboarding4Screen(),
                onNextPressed: _nextPage,
                showGetStarted: true,
              ),
            ],
          ),
          
          // Page indicator overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: responsive.hp(26.5), // Position between content and buttons
            child: Center(
              child: PageIndicator(
                currentPage: _currentPage,
                totalPages: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingScreenWrapper extends StatelessWidget {
  final Widget screen;
  final VoidCallback onNextPressed;
  final bool showGetStarted;

  const OnboardingScreenWrapper({
    super.key,
    required this.screen,
    required this.onNextPressed,
    required this.showGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Original screen content
        screen,
        
        // Override buttons with functional ones
        Positioned(
          left: ResponsiveHelper(context).wp(4.3),
          bottom: ResponsiveHelper(context).hp(8),
          right: ResponsiveHelper(context).wp(4.3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Next/Get Started button
              PrimaryButton(
                text: showGetStarted ? 'Get Started' : 'Next',
                onPressed: onNextPressed,
                height: ResponsiveHelper(context).hp(6.9),
              ),
              SizedBox(height: ResponsiveHelper(context).hp(2)),
              
              // Create Account or Register link
              if (!showGetStarted)
                OutlineButton(
                  text: 'Create Account',
                  onPressed: () {
                    // Navigate to signup screen
                    context.go('/home');
                  },
                  height: ResponsiveHelper(context).hp(6.9),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.grayMedium,
                        fontSize: ResponsiveHelper(context).sp(14),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to register screen
                        context.go('/home');
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: ResponsiveHelper(context).sp(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
