import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class InjuryQuestionBody extends StatefulWidget {
  const InjuryQuestionBody({super.key});

  @override
  State<InjuryQuestionBody> createState() => _InjuryQuestionBodyState();
}

class _InjuryQuestionBodyState extends State<InjuryQuestionBody> {
  final TextEditingController _injuryController = TextEditingController();
  bool _isLoading = false;
  final int _currentStep = 14; // This is question 14 of 14 (final question)
  final int _totalSteps = 14;

  @override
  void dispose() {
    _injuryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Common Header
        QuestionHeader(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          title: 'Let\'s Set Up Your Plan',
        ),
        
        SizedBox(height: responsive.hp(4)),
        
        // Question
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          child: Text(
            'Current or Previous Injury? (Describe)',
            style: AppTextStyles.heading2.copyWith(
              fontSize: responsive.sp(24),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        
        SizedBox(height: responsive.hp(2)),
        
        // Textarea Input
        Expanded(
          child: _buildTextareaInput(responsive),
        ),

        SizedBox(height: responsive.hp(2)),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(4)),
      ],
    );
  }

  Widget _buildTextareaInput(ResponsiveHelper responsive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(responsive.w(16)),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFF848484),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: TextField(
        controller: _injuryController,
        maxLines: 8, // Multiple lines for textarea
        maxLength: 500, // Character limit
        decoration: InputDecoration(
          hintText: 'Describe any current or previous injuries (optional)',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            fontSize: responsive.sp(16),
            color: const Color(0xFF848484),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          counterText: '', // Hide character counter
        ),
        style: AppTextStyles.bodyMedium.copyWith(
          fontSize: responsive.sp(16),
          color: AppColors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }

  Widget _buildContinueButton(ResponsiveHelper responsive) {
    return SizedBox(
      width: double.infinity,
      height: responsive.h(50),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, 0.50),
            end: Alignment(1.00, 0.50),
            colors: [Color(0xFF28A228), Color(0xD85CD65C)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1928A228),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: -25,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: _handleContinue,
            child: Container(
              width: double.infinity,
              height: responsive.h(56),
              alignment: Alignment.center,
              child: _isLoading
                  ? SizedBox(
                      width: responsive.w(24),
                      height: responsive.h(24),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Complete Setup',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: responsive.sp(16),
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.50,
                        letterSpacing: 0.50,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement injury description submission logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Injury description: ${_injuryController.text.isEmpty ? "None specified" : _injuryController.text}'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        
        // Navigate to completion screen
        context.push(AppRouter.questionDone);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
