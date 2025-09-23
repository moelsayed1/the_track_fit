import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../widgets/new_password_screen_body.dart';

class NewPasswordScreen extends StatelessWidget {
  final String email;
  final String otp;
  
  const NewPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6), // Light green background from Figma
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: responsive.sp(20),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: NewPasswordScreenBody(email: email, otp: otp),
        ),
      ),
    );
  }
}