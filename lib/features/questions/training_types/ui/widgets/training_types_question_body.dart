import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class TrainingTypesQuestionBody extends StatefulWidget {
  const TrainingTypesQuestionBody({super.key});

  @override
  State<TrainingTypesQuestionBody> createState() => _TrainingTypesQuestionBodyState();
}

class _TrainingTypesQuestionBodyState extends State<TrainingTypesQuestionBody> {
  final List<String> _selectedTrainingTypes = [];
  bool _isLoading = false;
  final int _currentStep = 9; // This is question 9 of 14
  final int _totalSteps = 14;

  // Training types options from the API response
  final List<Map<String, String>> _trainingTypeOptions = [
    {'value': 'cardio', 'label': 'Cardio (Running, Cycling, Jumping Ropes)'},
    {'value': 'resistance_training', 'label': 'Resistance Training (Iron or Bodyweight)'},
    {'value': 'hiit', 'label': 'HIIT (High Intensity Interval Training)'},
    {'value': 'home_training', 'label': 'Home Training'},
    {'value': 'yoga_pilates', 'label': 'Yoga or Pilates'},
    {'value': 'rehabilitation', 'label': 'Muscle/Sports Rehabilitation Exercises'},
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
            'What\'s your Preferred Training Types?',
            style: AppTextStyles.heading2.copyWith(
              fontSize: responsive.sp(24),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        
        SizedBox(height: responsive.hp(2)),
        
        // Training Types Options - Make scrollable
        Expanded(
          child: SingleChildScrollView(
            child: _buildTrainingTypeOptions(responsive),
          ),
        ),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(4)),
      ],
    );
  }

  Widget _buildTrainingTypeOptions(ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.h(8)),
      child: Column(
        children: _trainingTypeOptions.map((option) {
          final isSelected = _selectedTrainingTypes.contains(option['value']);
          return Column(
            children: [
              _buildTrainingTypeOption(
                responsive,
                value: option['value']!,
                label: option['label']!,
                isSelected: isSelected,
                onTap: () => _toggleTrainingType(option['value']!),
              ),
              if (option != _trainingTypeOptions.last)
                SizedBox(height: responsive.h(16)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTrainingTypeOption(
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
    final isEnabled = _selectedTrainingTypes.isNotEmpty;
    
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

  void _toggleTrainingType(String trainingType) {
    setState(() {
      if (_selectedTrainingTypes.contains(trainingType)) {
        _selectedTrainingTypes.remove(trainingType);
      } else {
        _selectedTrainingTypes.add(trainingType);
      }
    });
  }

  void _handleContinue() async {
    if (_selectedTrainingTypes.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement training types selection logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Training types selected: ${_selectedTrainingTypes.length}'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        
        // Navigate to next question screen
        context.push(AppRouter.equipmentQuestion);
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
