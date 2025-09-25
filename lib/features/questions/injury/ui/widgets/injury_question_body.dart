import 'package:flutter/material.dart';
import 'package:the_track_fit/features/questions/data/services/answers_service.dart';
import 'package:the_track_fit/features/questions/data/services/questions_service.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import '../../../../../core/widgets/question_continue_button.dart';
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

  // Services
  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;

  String _questionText = 'Current or Previous Injury? (Describe)';

  @override
  void initState() {
    super.initState();
    _loadInjuryQuestion();
  }

  Future<void> _loadInjuryQuestion() async {
    try {
      setState(() {
      });

      final question = await _questionsService.getCurrentOrPreviousInjuryQuestion();
      
      if (question != null) {
        setState(() {
          _questionText = question.enText;
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
            _questionText,
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
    return QuestionContinueButton(
      isEnabled: true, // Always enabled for optional text input
      isLoading: _isLoading,
      onPressed: _handleContinue,
      text: 'Complete Setup',
    );
  }

  void _handleContinue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the question ID from the service
      final question = await _questionsService.getCurrentOrPreviousInjuryQuestion();
      if (question != null) {
        // Add the answer to the answers service (as single string for textarea)
        _answersService.addAnswer(question.id, _injuryController.text);
        
        // Submit answers to API
        await _answersService.submitAnswers();
      }
      
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
            content: Text('Error submitting answer: ${e.toString()}'),
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
