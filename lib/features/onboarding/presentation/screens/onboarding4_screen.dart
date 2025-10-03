import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/localized_text.dart';
import '../../../../core/widgets/language_toggle_button.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';

class Onboarding4Screen extends StatelessWidget {
  const Onboarding4Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      body: Container(
        width: responsive.screenWidth,
        height: responsive.screenHeight,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(color: AppColors.white),
        child: Stack(
          children: [
            // Background image with crop effect
            Positioned(
              left: responsive.wp(-49.2),
              top: 0,
              child: Container(
                width: responsive.wp(208.8),
                height: responsive.hp(64.5),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.onboarding4),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Gradient overlay
            Positioned(
              left: 0,
              top: responsive.hp(28.8),
              child: Container(
                width: responsive.screenWidth,
                height: responsive.hp(60.5),
                decoration: const BoxDecoration(
                  gradient: AppColors.onboardingOverlay,
                ),
              ),
            ),

            // Main content
            Positioned(
              left: responsive.wp(6.4),
              top: responsive.hp(57),
              child: SizedBox(
                width: responsive.wp(87.2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title and description
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(5),
                      ),
                      child: Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return LocalizedText(
                            l10n.smartFitnessPoweredByAi,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                            textAlign: TextAlign.center,
                            letterSpacing: 0.50,
                            style: TextStyle(height: 1.2),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: responsive.hp(1.5)),
                    SizedBox(
                      width: responsive.wp(82.9),
                      child: Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return LocalizedText(
                            l10n.getPersonalizedTrainingPlans,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: AppColors.gray,
                            textAlign: TextAlign.center,
                            style: TextStyle(height: 1.4),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
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

            // Skip button
            Positioned(
              right: responsive.wp(4.3),
              top: responsive.hp(6),
              child: GestureDetector(
                onTap: () {
                  // Navigate to home screen
                  context.push(AppRouter.signup);
                },
                child: Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return LocalizedText(
                      l10n.skip,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                      textAlign: TextAlign.right,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
