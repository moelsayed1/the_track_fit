import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class AdditionalGoalsQuestionBody extends StatefulWidget {
  const AdditionalGoalsQuestionBody({super.key});

  @override
  State<AdditionalGoalsQuestionBody> createState() => _AdditionalGoalsQuestionBodyState();
}

class _AdditionalGoalsQuestionBodyState extends State<AdditionalGoalsQuestionBody> {
  final List<String> _selectedAdditionalGoals = [];
  bool _isLoading = false;
  final int _currentStep = 15; // This is question 15 of 15 (final question)
  final int _totalSteps = 15;

  // Additional goals options from the API response
  final List<Map<String, String>> _additionalGoalsOptions = [
    {'value': 'better_sleep', 'label': 'Better Sleep'},
    {'value': 'better_focus_energy', 'label': 'Better Focus and Energy'},
    {'value': 'better_meal_planning', 'label': 'Better Meal Planning'},
    {'value': 'build_sports_routine', 'label': 'Build a Sports Routine'},
  ];

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
            'Additional Goals (Optional)',
            style: AppTextStyles.heading2.copyWith(
              fontSize: responsive.sp(24),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        
        SizedBox(height: responsive.hp(2)),
        
        // Additional Goals Options - Make scrollable
        Expanded(
          child: SingleChildScrollView(
            child: _buildAdditionalGoalsOptions(responsive),
          ),
        ),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(4)),
      ],
    );
  }

  Widget _buildAdditionalGoalsOptions(ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.h(8)),
      child: Column(
        children: _additionalGoalsOptions.map((option) {
          final isSelected = _selectedAdditionalGoals.contains(option['value']);
          return Column(
            children: [
              _buildAdditionalGoalOption(
                responsive,
                value: option['value']!,
                label: option['label']!,
                isSelected: isSelected,
                onTap: () => _toggleAdditionalGoal(option['value']!),
              ),
              if (option != _additionalGoalsOptions.last)
                SizedBox(height: responsive.h(16)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAdditionalGoalOption(
    ResponsiveHelper responsive, {
    required String value,
    required String label,
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
            // Checkbox
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
                  borderRadius: BorderRadius.circular(4), // Square checkbox
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: responsive.w(14),
                    )
                  : null,
            ),
            
            SizedBox(width: responsive.w(16)),
            
            // Text Content
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: responsive.sp(16),
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(ResponsiveHelper responsive) {
    // This is optional, so button is always enabled
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

  void _toggleAdditionalGoal(String additionalGoal) {
    setState(() {
      if (_selectedAdditionalGoals.contains(additionalGoal)) {
        _selectedAdditionalGoals.remove(additionalGoal);
      } else {
        _selectedAdditionalGoals.add(additionalGoal);
      }
    });
  }

  void _handleContinue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement additional goals selection logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Additional goals selected: ${_selectedAdditionalGoals.length}'),
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
