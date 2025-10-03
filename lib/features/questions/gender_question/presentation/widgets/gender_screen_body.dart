import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import '../../../../../core/widgets/question_continue_button.dart';
import '../../../../../core/widgets/localized_text.dart';
import '../../../../../core/extensions/localization_extensions.dart';
import '../../../../../core/router/app_router.dart';
import 'package:go_router/go_router.dart';
import '../../../../../generated/l10n/app_localizations.dart';

class GenderScreenBody extends StatefulWidget {
  const GenderScreenBody({super.key});

  @override
  State<GenderScreenBody> createState() => _GenderScreenBodyState();
}

class _GenderScreenBodyState extends State<GenderScreenBody> {
  String? _selectedGender;
  bool _isLoading = false;
  int _currentStep = 2; // Start from question 2
  final int _totalSteps = 14; // Total of 14 questions

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Directionality(
      textDirection: context.textDirection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        SizedBox(height: responsive.hp(0)), // 44px equivalent
        
        // Common Header
        QuestionHeader(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          title: AppLocalizations.of(context)!.letsSetUpYourPlan,
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
      ),
    );
  }



  Widget _buildQuestion(ResponsiveHelper responsive) {
    return Container(
      width: double.infinity,
      alignment: AlignmentDirectional.centerStart,
      child: LocalizedText(
        AppLocalizations.of(context)!.whatsYourGender,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
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
          label: AppLocalizations.of(context)!.female,
          isSelected: _selectedGender == 'female',
          onTap: () => _selectGender('female'),
        ),
        
        SizedBox(height: responsive.h(24)),
        
        // Male Option
        _buildGenderOption(
          responsive,
          gender: 'male',
          icon: AppLogos.male,
          label: AppLocalizations.of(context)!.male,
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
    return QuestionContinueButton(
      isEnabled: _selectedGender != null,
      isLoading: _isLoading,
      onPressed: _handleContinue,
    );
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
      _currentStep = 2; // Update progress to 2/12 after selecting gender
    });
  }

  void _handleContinue() async {
    if (_selectedGender == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        // Mark user as no longer a first-time user
        await _markUserAsReturningUser();
        
        // Navigate to next question screen (Fitness Level)
        context.push(AppRouter.fitnessLevel);
      }
    } catch (e) {
      // Error handling - could log to analytics or show error state
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _markUserAsReturningUser() async {
    // This could:
    // - Update SharedPreferences with "hasCompletedOnboarding: true"
    // - Make API call to update user profile
    // - Update local database
    
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate API call
  }
}
