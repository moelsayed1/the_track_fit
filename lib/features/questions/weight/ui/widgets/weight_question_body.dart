import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/constants/app_text_styles.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/widgets/question_header.dart';
import 'package:the_track_fit/core/widgets/question_continue_button.dart';
import 'package:the_track_fit/features/questions/data/services/answers_service.dart';
import 'package:the_track_fit/features/questions/data/services/questions_service.dart';

class WeightQuestionBody extends StatefulWidget {
  const WeightQuestionBody({super.key});

  @override
  State<WeightQuestionBody> createState() => _WeightQuestionBodyState();
}

class _WeightQuestionBodyState extends State<WeightQuestionBody> {
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _weightFocusNode = FocusNode();
  bool _isInputFilled = false;
  
  // Services
  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;
  
  String _questionText = 'What\'s your Current Weight?';

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_onWeightChanged);
    _weightFocusNode.addListener(_onFocusChanged);
    _loadWeightQuestion();
  }

  Future<void> _loadWeightQuestion() async {
    try {
      setState(() {
      });

      final question = await _questionsService.getCurrentWeightQuestion();
      
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
    _weightController.dispose();
    _weightFocusNode.dispose();
    super.dispose();
  }

  void _onWeightChanged() {
    setState(() {
      _isInputFilled = _weightController.text.isNotEmpty;
    });
  }

  void _onFocusChanged() {
    setState(() {
      // This will trigger a rebuild to update the border color
    });
  }



  void _onContinuePressed() async {
    if (_weightController.text.isNotEmpty) {
      try {
        // Get the question ID from the service
        final question = await _questionsService.getCurrentWeightQuestion();
        if (question != null) {
          // Add the answer to the answers service (as single value)
          _answersService.addAnswer(question.id, _weightController.text);
          
          // Submit answers to API
          await _answersService.submitAnswers();
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Weight submitted: ${_weightController.text} kg'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
          
          // Navigate to target weight question after current weight selection
          context.push(AppRouter.targetWeightQuestion);
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xFFF6FFF6), // Background color from Figma
      child: Column(
        children: [
          SizedBox(height: responsive.h(28)),
          
          // Question Header
          QuestionHeader(
            title: "Let's Set Up Your Plan",
            currentStep: 5,
            totalSteps: 14,
          ),
          
          SizedBox(height: responsive.h(34.5)),
          
          // Question Text
          _buildQuestion(responsive),
          
          SizedBox(height: responsive.h(24)),
          
          // Weight Input Field
          _buildWeightInputField(responsive),
          
          const Spacer(),
          
          // Continue Button (always show, but disabled when no input)
          _buildContinueButton(responsive),
          
          SizedBox(height: responsive.h(72)),
                ],
      ),
    );
  }

  Widget _buildQuestion(ResponsiveHelper responsive) {
    return Container(
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
    );
  }

    Widget _buildWeightInputField(ResponsiveHelper responsive) {
    return Container(
      width: double.infinity,
      height: responsive.h(50), // Reduced height from default
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12), // Reduced vertical padding
      decoration: BoxDecoration(
        border: Border.all(
          color: _weightFocusNode.hasFocus ? AppColors.primaryGreen : AppColors.gray, // Green when focused, gray when not
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          controller: _weightController,
          focusNode: _weightFocusNode,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: AppColors.black,
            fontSize: responsive.sp(20),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1,
            letterSpacing: 0.70,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '',
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(ResponsiveHelper responsive) {
    return QuestionContinueButton(
      isEnabled: _isInputFilled,
      onPressed: _onContinuePressed,
    );
  }

}
