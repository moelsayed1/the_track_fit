import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import '../../../../../core/router/app_router.dart';
import 'package:go_router/go_router.dart';

class GenderScreenBody extends StatefulWidget {
  const GenderScreenBody({super.key});

  @override
  State<GenderScreenBody> createState() => _GenderScreenBodyState();
}

class _GenderScreenBodyState extends State<GenderScreenBody> {
  String? _selectedGender;
  bool _isLoading = false;
  int _currentStep = 0; // Start from question 1
  final int _totalSteps = 4; // Total of 6 questions

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: responsive.hp(5)), // 44px equivalent
        
        // Common Header
        QuestionHeader(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          title: 'Let\'s Set Up Your Plan',
        ),
        
        SizedBox(height: responsive.hp(4)), // 16px equivalent
        
        // Question
        _buildQuestion(responsive),
        
        SizedBox(height: responsive.hp(6)), // 24px equivalent
        
        // Gender Selection Options
        _buildGenderOptions(responsive),
        
        const Spacer(),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(4)), // 16px equivalent
      ],
    );
  }



  Widget _buildQuestion(ResponsiveHelper responsive) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Text(
        'What\'s your gender ?',
        style: AppTextStyles.heading2.copyWith(
          fontSize: responsive.sp(24),
          fontWeight: FontWeight.w700,
          color: AppColors.black,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget _buildGenderOptions(ResponsiveHelper responsive) {
    return Column(
      children: [
        // Female Option
        _buildGenderOption(
          responsive,
          gender: 'female',
          icon: AppLogos.female,
          label: 'Female',
          isSelected: _selectedGender == 'female',
          onTap: () => _selectGender('female'),
        ),
        
        SizedBox(height: responsive.h(24)),
        
        // Male Option
        _buildGenderOption(
          responsive,
          gender: 'male',
          icon: AppLogos.male,
          label: 'Male',
          isSelected: _selectedGender == 'male',
          onTap: () => _selectGender('male'),
        ),
      ],
    );
  }

  Widget _buildGenderOption(
    ResponsiveHelper responsive, {
    required String gender,
    required String icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: responsive.w(128),
        height: responsive.h(128),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.grayLight.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: responsive.w(51),
              height: responsive.h(72),
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : AppColors.gray,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: responsive.h(8)),
            // Text(
            //   label,
            //   style: AppTextStyles.bodyMedium.copyWith(
            //     fontSize: responsive.sp(16),
            //     fontWeight: FontWeight.w500,
            //     color: isSelected ? Colors.white : AppColors.gray,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(ResponsiveHelper responsive) {
    final isEnabled = _selectedGender != null;
    
    return SizedBox(
      width: double.infinity,
      height: responsive.h(50),
      child: Container(
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primaryGreen : const Color(0xFFBDBDBD), // Grey when disabled
          borderRadius: BorderRadius.circular(30),
          boxShadow: isEnabled ? [
            BoxShadow(
              color: AppColors.primaryGreen.withValues(alpha: 0.25),
              offset: const Offset(0, 10),
              blurRadius: 25,
            ),
          ] : null, // No shadow when disabled
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
                        fontWeight: FontWeight.w600,
                        color: isEnabled ? Colors.white : Colors.grey[600]!,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
      _currentStep = 1; // Update progress to 2/6 after selecting gender
    });
  }

  void _handleContinue() async {
    if (_selectedGender == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement gender selection logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        // Mark user as no longer a first-time user
        await _markUserAsReturningUser();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gender selected: $_selectedGender'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        
        // Navigate to next question screen (Fitness Level)
        context.push(AppRouter.fitnessLevel);
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

  Future<void> _markUserAsReturningUser() async {
    // TODO: Implement actual logic to mark user as returning
    // This could:
    // - Update SharedPreferences with "hasCompletedOnboarding: true"
    // - Make API call to update user profile
    // - Update local database
    
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate API call
  }
}
