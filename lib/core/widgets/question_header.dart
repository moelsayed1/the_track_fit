import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/responsive_helper.dart';

class QuestionHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;

  const QuestionHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Column(
      children: [
        SizedBox(height: responsive.hp(4)),
        
        // Title
        Text(
          title,
          style: AppTextStyles.heading1.copyWith(
            fontSize: responsive.sp(14),
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          textAlign: TextAlign.center,
        ),
        
        SizedBox(height: responsive.hp(4)),
        
        // Progress Bar
        Row(
          children: [
            Expanded(
              child: Container(
                height: responsive.h(16),
                decoration: BoxDecoration(
                  color: const Color(0x26848484), // Light gray background
                  borderRadius: BorderRadius.circular(10),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: currentStep / totalSteps,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: responsive.w(16)),
            Text(
              '$currentStep/$totalSteps',
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: responsive.sp(14),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
