import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/router/app_router.dart';

class QuestionDone extends StatefulWidget {
  const QuestionDone({super.key});

  @override
  State<QuestionDone> createState() => _QuestionDoneState();
}

class _QuestionDoneState extends State<QuestionDone>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0, // Changed to 100% to complete the progress
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.addListener(() {
      setState(() {
        _currentProgress = _progressAnimation.value;
      });
    });

    // Add status listener to navigate when animation completes
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Navigate to promotional offer when progress reaches 100%
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            context.push(AppRouter.home);
          }
        });
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light off-white background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Progress Indicator
            SizedBox(
              width: responsive.w(120),
              height: responsive.h(120),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  Container(
                    width: responsive.w(120),
                    height: responsive.h(120),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFE9ECEF), // Light gray outline
                        width: 8,
                      ),
                    ),
                  ),
                  // Progress circle
                  SizedBox(
                    width: responsive.w(120),
                    height: responsive.h(120),
                    child: CircularProgressIndicator(
                      value: _currentProgress,
                      strokeWidth: 8,
                      backgroundColor: Colors.transparent,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primaryGreen,
                      ),
                    ),
                  ),
                  // Percentage text
                  Text(
                    '${(_currentProgress * 100).toInt()}%',
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: responsive.sp(24),
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: responsive.h(40)),
            
            // Main heading
            Text(
              "We're building your personalized plan",
              style: AppTextStyles.heading1.copyWith(
                fontSize: responsive.sp(20),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: responsive.h(16)),
            
            // Subtitle
            Text(
              "Your journey starts in a few seconds.",
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: responsive.sp(16),
                color: const Color(0xFF6C757D), // Light gray color
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}