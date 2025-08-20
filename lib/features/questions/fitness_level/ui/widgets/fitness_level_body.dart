import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class FitnessLevelBody extends StatefulWidget {
  const FitnessLevelBody({super.key});

  @override
  State<FitnessLevelBody> createState() => _FitnessLevelBodyState();
}

class _FitnessLevelBodyState extends State<FitnessLevelBody> {
  String? _selectedFitnessLevel;
  bool _isLoading = false;
  final int _currentStep = 2; // This is question 2 of 6
  final int _totalSteps = 4;

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
            'What\'s your Fitness Level ?',
            style: AppTextStyles.heading2.copyWith(
              fontSize: responsive.sp(24),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        
        SizedBox(height: responsive.hp(6)),
        
        // Fitness Level Options
        _buildFitnessLevelOptions(responsive),
        
        const Spacer(),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(4)),
      ],
    );
  }

  Widget _buildFitnessLevelOptions(ResponsiveHelper responsive) {
    return Column(
      children: [
        // Beginner Option
        _buildFitnessOption(
          responsive,
          level: 'Beginner',
          description: 'I\'m just getting started with workouts.',
          isSelected: _selectedFitnessLevel == 'Beginner',
          onTap: () => _selectFitnessLevel('Beginner'),
        ),
        
        SizedBox(height: responsive.h(16)),
        
        // Intermediate Option
        _buildFitnessOption(
          responsive,
          level: 'Intermediate',
          description: 'I exercise regularly and know the basics.',
          isSelected: _selectedFitnessLevel == 'Intermediate',
          onTap: () => _selectFitnessLevel('Intermediate'),
        ),
        
        SizedBox(height: responsive.h(16)),
        
        // Advanced Option
        _buildFitnessOption(
          responsive,
          level: 'Advanced',
          description: 'I\'ve been training for a while and want serious results.',
          isSelected: _selectedFitnessLevel == 'Advanced',
          onTap: () => _selectFitnessLevel('Advanced'),
        ),
      ],
    );
  }

  Widget _buildFitnessOption(
    ResponsiveHelper responsive, {
    required String level,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(responsive.w(16)),
        decoration: ShapeDecoration(
          color: isSelected 
              ? const Color(0x3328A228) // Light green when selected
              : const Color(0x26848484), // Light gray when not selected
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: isSelected 
                  ? AppColors.primaryGreen 
                  : const Color(0xFF848484),
            ),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          children: [
            // Radio Button
            Container(
              width: responsive.w(22),
              height: responsive.h(22),
              padding: EdgeInsets.all(responsive.w(4)),
              decoration: ShapeDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isSelected 
                        ? AppColors.primaryGreen 
                        : const Color(0xFF848484),
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: isSelected
                  ? Container(
                      width: responsive.w(9),
                      height: responsive.h(9),
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(),
                      ),
                    )
                  : null,
            ),
            
            SizedBox(width: responsive.w(16)),
            
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    level,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: responsive.sp(16),
                      fontWeight: FontWeight.w500,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: responsive.h(4)),
                  Text(
                    description,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: responsive.sp(12),
                      fontWeight: FontWeight.w400,
                      color: isSelected 
                          ? const Color(0xFF1E1E1E) 
                          : const Color(0xFF848484),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(ResponsiveHelper responsive) {
    final isEnabled = _selectedFitnessLevel != null;
    
    return SizedBox(
      width: double.infinity,
      height: responsive.h(50),
      child: Container(
        decoration: BoxDecoration(
          gradient: isEnabled 
              ? const LinearGradient(
                  begin: Alignment(0.00, 0.50),
                  end: Alignment(1.00, 0.50),
                  colors: [Color(0xFF28A228), Color(0xD85CD65C)],
                )
              : null,
          color: isEnabled ? null : const Color(0xFFBDBDBD),
          borderRadius: BorderRadius.circular(30),
          boxShadow: isEnabled ? [
            BoxShadow(
              color: const Color(0x1928A228),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: -25,
            ),
          ] : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: isEnabled ? _handleContinue : null,
            child: Container(
              width: double.infinity,
              height: responsive.h(56),
              alignment: Alignment.center,
              child: _isLoading
                  ? SizedBox(
                      width: responsive.w(24),
                      height: responsive.h(24),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isEnabled ? Colors.white : Colors.grey[600]!,
                        ),
                      ),
                    )
                  : Text(
                      'Continue',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: responsive.sp(16),
                        fontWeight: FontWeight.w500,
                        color: isEnabled ? Colors.white : Colors.grey[600]!,
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

  void _selectFitnessLevel(String level) {
    setState(() {
      _selectedFitnessLevel = level;
    });
  }

  void _handleContinue() async {
    if (_selectedFitnessLevel == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement fitness level selection logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fitness level selected: $_selectedFitnessLevel'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        
        // Navigate to next question screen (Height Question)
        context.push(AppRouter.heightQuestion);
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