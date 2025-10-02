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

class HeightQuestionBody extends StatefulWidget {
  const HeightQuestionBody({super.key});

  @override
  State<HeightQuestionBody> createState() => _HeightQuestionBodyState();
}

class _HeightQuestionBodyState extends State<HeightQuestionBody> {
  int _selectedHeight = 0; // Default height in cm - now mutable
  bool _isLoading = false;
  final int _currentStep = 4; // This is question 4 of 14
  final int _totalSteps = 14;
  
  // Services
  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;
  
  String _questionText = 'What\'s your Height ?';
  final int _minHeight = 140; // Minimum height in cm
  final int _maxHeight = 220; // Maximum height in cm
  
  @override
  void initState() {
    super.initState();
    _loadHeightQuestion();
  }

  Future<void> _loadHeightQuestion() async {
    try {
      setState(() {
      });

      final question = await _questionsService.getHeightQuestion();
      
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
        
        SizedBox(height: responsive.hp(6)),
        
                 // Height Display Box
         _buildHeightDisplayBox(responsive),
        
        SizedBox(height: responsive.hp(6)),
        
                 // Height Picker
         SizedBox(
           height: responsive.h(200), // Fixed height for the picker area
           child: Stack(
             children: [
               // Custom Height Picker
               Center(
                 child: ListWheelScrollView(
                   itemExtent: responsive.h(50), // Height of each item
                   perspective: 0.002, // Slight 3D effect
                   diameterRatio: 2, // Controls the curvature
                   physics: const FixedExtentScrollPhysics(), // Snaps to items
                   onSelectedItemChanged: (index) {
                     setState(() {
                       _selectedHeight = _minHeight + index;
                     });
                   },
                   children: List.generate(
                     _maxHeight - _minHeight + 1,
                     (index) {
                       final heightValue = _minHeight + index;
                       final isSelected = heightValue == _selectedHeight;
                       
                       return Center(
                         child: isSelected
                             ? Row(
                                 mainAxisSize: MainAxisSize.min,
                                 children: [
                                   Text(
                                     '$heightValue',
                                     style: TextStyle(
                                       color: const Color(0xFF28A228), // Green color for selected
                                       fontSize: responsive.sp(28),
                                       fontFamily: 'Poppins',
                                       fontWeight: FontWeight.w600,
                                       letterSpacing: 0.70,
                                     ),
                                   ),
                                   SizedBox(width: responsive.w(8)),
                                   Text(
                                     'cm',
                                     style: TextStyle(
                                       color: const Color(0xFF1E1E1E), // Black color
                                       fontSize: responsive.sp(16),
                                       fontFamily: 'Poppins',
                                       fontWeight: FontWeight.w400,
                                       letterSpacing: 0.70,
                                     ),
                                   ),
                                 ],
                               )
                             : Text(
                                 '$heightValue',
                                 style: TextStyle(
                                   color: const Color(0xFF848484), // Gray color for unselected
                                   fontSize: responsive.sp(20),
                                   fontFamily: 'Poppins',
                                   fontWeight: FontWeight.w400,
                                   letterSpacing: 0.70,
                                 ),
                               ),
                       );
                     },
                   ),
                 ),
               ),
               // Top selection line overlay
               Positioned(
                 left: 0,
                 right: 0,
                 top: responsive.h(75), // Above selected item
                 child: Center(
                   child: Container(
                     width: responsive.w(120), // Shorter width, centered
                     height: 1, // Thin line
                     decoration: BoxDecoration(
                       color: const Color(0xFF28A228), // Green color
                       borderRadius: BorderRadius.circular(0.5),
                     ),
                   ),
                 ),
               ),
               // Bottom selection line overlay
               Positioned(
                 left: 0,
                 right: 0,
                 top: responsive.h(125), // Below selected item (75 + 50)
                 child: Center(
                   child: Container(
                     width: responsive.w(120), // Shorter width, centered
                     height: 1, // Thin line
                     decoration: BoxDecoration(
                       color: const Color(0xFF28A228), // Green color
                       borderRadius: BorderRadius.circular(0.5),
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
        
        const Spacer(),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(4)),
        ],
      ),
    );
  }

    Widget _buildHeightDisplayBox(ResponsiveHelper responsive) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.w(8),
        vertical: responsive.h(16),
      ),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFF28A228), // Green border
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Center(
        child: Text(
          '$_selectedHeight',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: responsive.sp(20),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1,
            letterSpacing: 0.70,
          ),
        ),
      ),
    );
  }



  Widget _buildContinueButton(ResponsiveHelper responsive) {
    return QuestionContinueButton(
      isEnabled: true, // Always enabled since height is always selected
      isLoading: _isLoading,
      onPressed: _handleContinue,
    );
  }

  void _handleContinue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get the question ID from the service
      final question = await _questionsService.getHeightQuestion();
      if (question != null) {
        // Add the answer to the answers service (as single value)
        _answersService.addAnswer(question.id, _selectedHeight.toString());
        
        // Submit answers to API
        await _answersService.submitAnswers();
      }
      
      if (mounted) {
        // Navigate to next question screen
        context.push(AppRouter.weightQuestion);
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
