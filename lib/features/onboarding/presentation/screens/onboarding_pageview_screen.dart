import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding3_screen.dart';
import 'package:the_track_fit/features/onboarding/presentation/screens/onboarding4_screen.dart';
import '../../../../core/widgets/page_indicator.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/localized_text.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../../core/constants/app_colors.dart';
import 'onboarding1_screen.dart';
import 'onboarding2_screen.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';

typedef OnNextPressed = void Function();
typedef OnCreateAccountPressed = void Function();

class OnboardingPageViewScreen extends StatefulWidget {
  const OnboardingPageViewScreen({super.key});

  @override
  State<OnboardingPageViewScreen> createState() =>
      _OnboardingPageViewScreenState();
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
      // Navigate to signup on last page
      context.push(AppRouter.signup);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
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

            // Language toggle button
            Positioned(
              left: responsive.wp(4.3),
              top: responsive.hp(6),
              child: const LanguageToggleButton(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                borderRadius: 20,
              ),
            ),

            // Page indicator overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: responsive.hp(
                26.5,
              ), // Position between content and buttons
              child: Center(
                child: PageIndicator(currentPage: _currentPage, totalPages: 4),
              ),
            ),
          ],
        ),
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
        Positioned(
          left: ResponsiveHelper(context).wp(4.3),
          bottom: ResponsiveHelper(context).hp(8),
          right: ResponsiveHelper(context).wp(4.3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showGetStarted) ...[
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return PrimaryButton(
                      text: l10n.getStarted,
                      onPressed: onNextPressed,
                      height: ResponsiveHelper(context).hp(6.9),
                    );
                  },
                ),
                SizedBox(height: ResponsiveHelper(context).hp(2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) {
                        final l10n = AppLocalizations.of(context)!;
                        return LocalizedText(
                          "${l10n.dontHaveAccount} ",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.white,
                        );
                      },
                    ),
                    GestureDetector(
                      onTap: () => context.push(AppRouter.signup),
                      child: Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return LocalizedText(
                            l10n.signUp,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return PrimaryButton(
                      text: l10n.next,
                      onPressed: onNextPressed,
                      height: ResponsiveHelper(context).hp(6.9),
                    );
                  },
                ),
                SizedBox(height: ResponsiveHelper(context).hp(2)),
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return OutlineButton(
                      text: l10n.createAccount,
                      onPressed: () {
                        context.push(AppRouter.signup);
                      },
                      height: ResponsiveHelper(context).hp(6.9),
                    );
                  },
                ),
              ],
            ],
          ),
        ),

        // Separate positioned "Don't have an account" text for last screen
        // if (showGetStarted)
        //   Positioned(
        //     left: 0,
        //     right: 0,
        //     bottom: ResponsiveHelper(context).hp(13.5), // CONTROL POSITION HERE
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           "Don't have an account? ",
        //           style: TextStyle(
        //             color: AppColors.grayMedium,
        //             fontSize: ResponsiveHelper(context).sp(14),
        //           ),
        //         ),
        //         GestureDetector(
        //           onTap: () {
        //             // Navigate to register screen
        //             context.push('/signup');
        //           },
        //           child: Text(
        //             "Register",
        //             style: TextStyle(
        //               color: AppColors.primaryGreen,
        //               fontSize: ResponsiveHelper(context).sp(14),
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
      ],
    );
  }
}
