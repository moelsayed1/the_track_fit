import 'package:flutter/material.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import '../widgets/otp_screen_body.dart';

class OtpScreen extends StatelessWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Dark background

      body: SafeArea(
        child: SingleChildScrollView(child: OtpScreenBody(email: email)),
      ),
    );
  }
}
