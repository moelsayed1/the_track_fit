import 'package:flutter/material.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'widgets/fitness_level_body.dart';

class FitnessLevelScreen extends StatelessWidget {
  const FitnessLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6), // Light green background from Figma
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(4.3), // 16px equivalent
          ),
          child: FitnessLevelBody(),
        ),
      ),
    );
  }
}
