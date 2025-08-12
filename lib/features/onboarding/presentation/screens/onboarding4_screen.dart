import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/responsive_helper.dart';

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
                      padding: EdgeInsets.symmetric(horizontal: responsive.wp(5)),
                      child: Text(
                        'Smart Fitness Powered\nby AI',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.onboardingTitle.copyWith(
                          fontSize: responsive.sp(22),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.hp(1.5)),
                    SizedBox(
                      width: responsive.wp(82.9),
                      child: Text(
                        'Get personalized training plans, intelligent suggestions and detailed tracking — all powered by AI.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.onboardingDescription.copyWith(
                          fontSize: responsive.sp(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            

            
            // Skip button
            Positioned(
              right: responsive.wp(6.4),
              top: responsive.hp(8),
              child: GestureDetector(
                onTap: () {
                  // Navigate to home screen
                  context.push('/home');
                },
                child: Text(
                  'Skip',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.skipButton.copyWith(
                    fontSize: responsive.sp(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
