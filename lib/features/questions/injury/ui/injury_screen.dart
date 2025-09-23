import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'widgets/injury_question_body.dart';

class InjuryQuestionScreen extends StatelessWidget {
  const InjuryQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6), // Light green background
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(4.3), // 16px equivalent
          ),
          child: const InjuryQuestionBody(),
        ),
      ),
    );
  }
}
