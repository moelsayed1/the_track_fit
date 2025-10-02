import 'package:flutter/material.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import '../../../../../core/widgets/question_continue_button.dart';
import '../../../../../core/widgets/localized_text.dart';
import '../../../../../core/extensions/localization_extensions.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';
import '../../../../questions/data/services/questions_service.dart';
import '../../../../questions/data/services/answers_service.dart';
import '../../../../questions/domain/models/question.dart';

class AgeQuestionBody extends StatefulWidget {
  const AgeQuestionBody({super.key});

  @override
  State<AgeQuestionBody> createState() => _AgeQuestionBodyState();
}

class _AgeQuestionBodyState extends State<AgeQuestionBody> {
  String? _selectedAge;
  bool _isLoading = false;
  bool _isLoadingOptions = true;
  String? _error;
  Question? _ageQuestion;
  final int _currentStep = 1; // This is question 1 of 14
  final int _totalSteps = 14;

  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;

  @override
  void initState() {
    super.initState();
    _loadAgeQuestion();
  }

  Future<void> _loadAgeQuestion() async {
    try {
      setState(() {
        _isLoadingOptions = true;
        _error = null;
      });

      // Clear cache and force refresh questions for first-time users
      _questionsService.clearCache();
      final question = await _questionsService.getAgeQuestion();
      
      if (mounted) {
        setState(() {
          _ageQuestion = question;
          _isLoadingOptions = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoadingOptions = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Directionality(
      textDirection: context.textDirection,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        // Common Header
        QuestionHeader(
          currentStep: _currentStep,
          totalSteps: _totalSteps,
          title: AppLocalizations.of(context)!.letsSetUpYourPlan,
        ),
        
        SizedBox(height: responsive.hp(4)),
        
        // Question
        Container(
          width: double.infinity,
          alignment: AlignmentDirectional.centerStart,
          child: LocalizedText(
            _ageQuestion?.localizedText ?? AppLocalizations.of(context)!.whatsYourAge,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.start,
          ),
        ),
        
        SizedBox(height: responsive.hp(6)),
        
        // Age Options
        _buildAgeOptions(responsive),
        
        const Spacer(),
        
        // Continue Button
        GestureDetector(onTap: () => _handleContinue(), child: _buildContinueButton(responsive)),
        
        SizedBox(height: responsive.hp(4)),
        ],
      ),
    );
  }

  Widget _buildAgeOptions(ResponsiveHelper responsive) {
    if (_isLoadingOptions) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          children: [
            LocalizedText(
              AppLocalizations.of(context)!.errorLoadingAgeOptions,
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.red,
            ),
            SizedBox(height: responsive.h(16)),
            ElevatedButton(
              onPressed: _loadAgeQuestion,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: LocalizedText(
                AppLocalizations.of(context)!.retry,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_ageQuestion?.options == null || _ageQuestion!.options!.isEmpty) {
      return Center(
        child: LocalizedText(
          AppLocalizations.of(context)!.noAgeOptionsAvailable,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
      );
    }

    return Column(
      children: _ageQuestion!.options!.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _selectedAge == option.en;
        
        return Column(
          children: [
            _buildAgeOption(
              responsive,
              value: option.en,
              label: option.localizedText,
              isSelected: isSelected,
              onTap: () => _selectAge(option.en),
            ),
            if (index != _ageQuestion!.options!.length - 1)
              SizedBox(height: responsive.h(16)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildAgeOption(
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
            // Radio Button
            Container(
              width: responsive.w(22),
              height: responsive.h(22),
              padding: EdgeInsets.all(responsive.w(5)),
              decoration: ShapeDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: isSelected 
                        ? AppColors.primaryGreen 
                        : const Color(0xFF848484),
                  ),
                  borderRadius: BorderRadius.circular(15), // Circular radio button
                ),
              ),
              child: isSelected
                  ? Container(
                      width: responsive.w(8),
                      height: responsive.h(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
            
            SizedBox(width: responsive.w(16)),
            
            // Text Content
            Expanded(
              child: LocalizedText(
                label,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(ResponsiveHelper responsive) {
    return QuestionContinueButton(
      isEnabled: _selectedAge != null,
      isLoading: _isLoading,
      onPressed: _handleContinue,
    );
  }

  void _selectAge(String age) {
    setState(() {
      _selectedAge = age;
    });
  }

  void _handleContinue() async {
    if (_selectedAge == null || _ageQuestion == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Add the answer to the answers service
      _answersService.addAnswer(_ageQuestion!.id, _selectedAge!);
      
      // Submit answers to API
      await _answersService.submitAnswers();
      
      if (mounted) {
        // Navigate to next question screen (Height Question)
        context.push(AppRouter.heightQuestion);
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
}
