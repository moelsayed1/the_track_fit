import 'package:flutter/material.dart';
import 'package:the_track_fit/features/questions/data/services/answers_service.dart';
import 'package:the_track_fit/features/questions/data/services/questions_service.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import '../../../../../core/widgets/question_continue_button.dart';
import '../../../../../core/widgets/localized_text.dart';
import '../../../../../core/extensions/localization_extensions.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class SpecialDietQuestionBody extends StatefulWidget {
  const SpecialDietQuestionBody({super.key});

  @override
  State<SpecialDietQuestionBody> createState() => _SpecialDietQuestionBodyState();
}

class _SpecialDietQuestionBodyState extends State<SpecialDietQuestionBody> {
  final TextEditingController _specialDietController = TextEditingController();
  bool _isLoading = false;
  final int _currentStep = 13; // This is question 13 of 14
  final int _totalSteps = 14;

  // Services
  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;

  String _questionText = 'Special Diet? (Describe)';

  @override
  void initState() {
    super.initState();
    _loadSpecialDietQuestion();
  }

  Future<void> _loadSpecialDietQuestion() async {
    try {
      setState(() {
      });

      final question = await _questionsService.getSpecialDietQuestion();
      
      if (question != null) {
        setState(() {
          _questionText = question.localizedText;
        });
      } else {
        setState(() {
        });
      }
    } catch (e) {
      setState(() {
      });
    }
  }

  @override
  void dispose() {
    _specialDietController.dispose();
    super.dispose();
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
            _questionText,
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
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
        
        SizedBox(height: responsive.hp(2)),
        ],
      ),
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
        controller: _specialDietController,
        maxLines: 8, // Multiple lines for textarea
        maxLength: 500, // Character limit
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.specialDietHint,
          hintStyle: TextStyle(
            fontSize: 16,
            fontFamily: context.fontFamily,
            color: const Color(0xFF848484),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          counterText: '', // Hide character counter
        ),
        style: TextStyle(
          fontSize: 16,
          fontFamily: context.fontFamily,
          color: AppColors.black,
        ),
        textAlignVertical: TextAlignVertical.top,
      ),
    );
  }

  Widget _buildContinueButton(ResponsiveHelper responsive) {
    return QuestionContinueButton(
      isEnabled: true, // Always enabled for optional text input
      isLoading: _isLoading,
      onPressed: _handleContinue,
      text: AppLocalizations.of(context)!.completeSetup,
    );
  }

  void _handleContinue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the question ID from the service
      final question = await _questionsService.getSpecialDietQuestion();
      if (question != null) {
        // Add the answer to the answers service (as single string for textarea)
        _answersService.addAnswer(question.id, _specialDietController.text);
        
        // Submit answers to API
        await _answersService.submitAnswers();
      }
      
      if (mounted) {
        // Navigate to next question screen
        context.push(AppRouter.injuryQuestion);
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
