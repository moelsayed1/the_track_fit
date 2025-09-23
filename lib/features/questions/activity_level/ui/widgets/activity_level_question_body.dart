import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class ActivityLevelQuestionBody extends StatefulWidget {
  const ActivityLevelQuestionBody({super.key});

  @override
  State<ActivityLevelQuestionBody> createState() => _ActivityLevelQuestionBodyState();
}

class _ActivityLevelQuestionBodyState extends State<ActivityLevelQuestionBody> {
  final List<String> _selectedActivities = [];
  bool _isLoading = false;
  final int _currentStep = 8; // This is question 8 of 14
  final int _totalSteps = 14;

  // Activity level options from the API response
  final List<Map<String, String>> _activityOptions = [
    {'value': 'no_activity', 'label': 'No Activity'},
    {'value': 'light_activity', 'label': 'Light Activity (Twice a Week)'},
    {'value': 'moderate_activity', 'label': 'Moderate Activity (3-4 Times a Week)'},
    {'value': 'high_activity', 'label': 'High Activity (5 Times a Week)'},
    {'value': 'professional_athlete', 'label': 'Professional or Semi-Professional Athlete'},
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
            'What\'s your Current Activity Level?',
            style: AppTextStyles.heading2.copyWith(
              fontSize: responsive.sp(24),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        
        SizedBox(height: responsive.hp(2)),
        
        // Activity Options - Make scrollable
        Expanded(
          child: SingleChildScrollView(
            child: _buildActivityOptions(responsive),
          ),
        ),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(4)),
      ],
    );
  }

  Widget _buildActivityOptions(ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.h(8)),
      child: Column(
        children: _activityOptions.map((option) {
          final isSelected = _selectedActivities.contains(option['value']);
          return Column(
            children: [
              _buildActivityOption(
                responsive,
                value: option['value']!,
                label: option['label']!,
                isSelected: isSelected,
                onTap: () => _toggleActivity(option['value']!),
              ),
              if (option != _activityOptions.last)
                SizedBox(height: responsive.h(16)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActivityOption(
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
    final isEnabled = _selectedActivities.isNotEmpty;
    
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

  void _toggleActivity(String activity) {
    setState(() {
      if (_selectedActivities.contains(activity)) {
        _selectedActivities.remove(activity);
      } else {
        _selectedActivities.add(activity);
      }
    });
  }

  void _handleContinue() async {
    if (_selectedActivities.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement activity level selection logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Activity levels selected: ${_selectedActivities.length}'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        
        // Navigate to next question screen
        context.push(AppRouter.trainingTypesQuestion);
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
