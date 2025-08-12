import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/page_indicator.dart';
import '../../../../core/utils/responsive_helper.dart';

class Onboarding3Screen extends StatelessWidget {
  const Onboarding3Screen({super.key});

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
                    image: AssetImage("assets/images/on_boarding_image3.jpg"),
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
                        'Scan Your Plate. Know Your Calories Instantly',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.onboardingTitle.copyWith(
                          fontSize: responsive.sp(22),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                    SizedBox(height: responsive.hp(1)),
                    SizedBox(
                      width: responsive.wp(82.9),
                      child: Text(
                        'Take a photo of your food and our AI will instantly identify calories, nutrients, and track it automatically.',
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
              top: responsive.hp(8.4),
              child: GestureDetector(
                onTap: () {
                  // Navigate to home screen
                  context.go('/home');
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
            


            // Bottom safe area (home indicator)
            Positioned(
              left: 0,
              bottom: 0,
              child: SizedBox(
                width: responsive.screenWidth,
                height: responsive.hp(4.2),
                child: Stack(
                  children: [
                    Positioned(
                      left: responsive.wp(32.3),
                      bottom: responsive.hp(2.6),
                      child: Container(
                        width: responsive.wp(35.7),
                        height: responsive.hp(0.6),
                        decoration: ShapeDecoration(
                          color: AppColors.darkGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
