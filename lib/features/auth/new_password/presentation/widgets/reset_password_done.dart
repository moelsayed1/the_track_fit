import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/localized_text.dart';
import '../../../../../core/router/app_router.dart';

class ResetPasswordDone extends StatelessWidget {
  const ResetPasswordDone({
    super.key, 
    required this.text, 
    this.textStyle,
    this.isFromCheckout = false,
  });

  final String text;
  final TextStyle? textStyle;
  final bool isFromCheckout;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
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
                LocalizedText(
                  'Congratulations!',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: responsive.h(8)),
                
                // Subtitle
                LocalizedText(
                  text,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.gray,
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: responsive.h(24)),
                
                // Conditional Button
                SizedBox(
                  width: responsive.w(279),
                  height: responsive.h(56),
                  child: PrimaryButton(
                    text: isFromCheckout ? 'Go to Home Page' : 'Go to Login Page',
                    style: TextStyle(
                      fontSize: responsive.sp(18),
                    ),
                    onPressed: () => _handleNavigation(context),
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

  void _handleNavigation(BuildContext context) {
    if (isFromCheckout) {
      // Navigate to home page when coming from checkout
      context.push(AppRouter.home);
    } else {
      // Navigate to login page when coming from reset password
      context.push(AppRouter.login);
    }
  }
}