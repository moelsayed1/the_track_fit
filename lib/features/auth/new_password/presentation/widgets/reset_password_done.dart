import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/router/app_router.dart';

class ResetPasswordDone extends StatelessWidget {
  const ResetPasswordDone({super.key, required this.text, this.textStyle});

  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.60),
        ),
        child: Center(
          child: Container(
            width: responsive.w(343),
            height: responsive.h(329),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success GIF Animation
                SizedBox(
                  width: responsive.w(150),
                  height: responsive.h(150),
                  child: Image.asset(
                    AppAnimations.doneGif,
                    fit: BoxFit.contain,
                  ),
                ),
                
                SizedBox(height: responsive.h(16)),
                
                // Congratulations Title
                Text(
                  'Congratulations!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading2.copyWith(
                    fontSize: responsive.sp(20),
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
                
                SizedBox(height: responsive.h(8)),
                
                // Subtitle
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: responsive.sp(14),
                    color: AppColors.gray,
                  ),
                ),
                
                SizedBox(height: responsive.h(24)),
                
                // Go To Home Page Button
                SizedBox(
                  width: responsive.w(279),
                  height: responsive.h(56),
                  child: PrimaryButton(
                    text: 'Go To Home Page',
                    style: TextStyle(
                      fontSize: responsive.sp(18),
                    ),
                    onPressed: () => _handleGoToHome(context),
                    height: responsive.h(56),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleGoToHome(BuildContext context) {
    // Navigate to home page
    context.push(AppRouter.home);
  }
}