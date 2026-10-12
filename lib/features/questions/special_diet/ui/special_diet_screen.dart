import 'package:flutter/material.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'widgets/special_diet_question_body.dart';

class SpecialDietQuestionScreen extends StatelessWidget {
  const SpecialDietQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      backgroundColor: AppColors.background, // Dark background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(4.3), // 16px equivalent
          ),
          child: const SpecialDietQuestionBody(),
        ),
      ),
    );
  }
}
