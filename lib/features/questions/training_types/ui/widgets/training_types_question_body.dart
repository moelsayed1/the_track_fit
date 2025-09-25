import 'dart:developer';

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

class TrainingTypesQuestionBody extends StatefulWidget {
  const TrainingTypesQuestionBody({super.key});

  @override
  State<TrainingTypesQuestionBody> createState() => _TrainingTypesQuestionBodyState();
}

class _TrainingTypesQuestionBodyState extends State<TrainingTypesQuestionBody> {
  final List<String> _selectedTrainingTypes = [];
  bool _isLoading = false;
  bool _isLoadingOptions = true;
  String? _error;
  final int _currentStep = 9; // This is question 9 of 14
  final int _totalSteps = 14;

  // Services
  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;

  // Training types options from the API response
  List<Map<String, String>> _trainingTypeOptions = [];
  String _questionText = 'What\'s your Preferred Training Types?';

  @override
  void initState() {
    super.initState();
    _loadTrainingTypesQuestion();
  }

  Future<void> _loadTrainingTypesQuestion() async {
    try {
      setState(() {
        _isLoadingOptions = true;
        _error = null;
      });

      final question = await _questionsService.getPreferredTrainingTypesQuestion();
      
      if (question != null && question.options != null) {
        setState(() {
          _questionText = question.enText;
          _trainingTypeOptions = question.options!.map((option) => {
            'value': option.en,
            'label': option.en,
          }).toList();
          _isLoadingOptions = false;
        });
      } else {
        setState(() {
          _error = 'No training types options available';
          _isLoadingOptions = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load training types options: ${e.toString()}';
        _isLoadingOptions = false;
      });
    }
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
        
        // Training Types Options - Make scrollable
        Expanded(
          child: _isLoadingOptions
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  ),
                )
              : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          SizedBox(height: 16),
                          Text(
                            _error!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.red,
                              fontSize: responsive.sp(16),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadTrainingTypesQuestion,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
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
              width: responsive.w(24),
              height: responsive.h(24),
              padding: EdgeInsets.all(responsive.w(4)),
              decoration: ShapeDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: isSelected 
                        ? AppColors.primaryGreen 
                        : const Color(0xFF848484),
                  ),
                  borderRadius: BorderRadius.circular(6), // Square checkbox
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: responsive.w(16),
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
    return QuestionContinueButton(
      isEnabled: _selectedTrainingTypes.isNotEmpty,
      isLoading: _isLoading,
      onPressed: _handleContinue,
    );
  }

  void _toggleTrainingType(String trainingType) {
    setState(() {
      if (_selectedTrainingTypes.contains(trainingType)) {
        _selectedTrainingTypes.remove(trainingType);
        log('Removed: $trainingType. Current selections: $_selectedTrainingTypes');
      } else {
        _selectedTrainingTypes.add(trainingType);
        log('Added: $trainingType. Current selections: $_selectedTrainingTypes');
      }
    });
  }

  void _handleContinue() async {
    if (_selectedTrainingTypes.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the question ID from the service
      final question = await _questionsService.getPreferredTrainingTypesQuestion();
      if (question != null) {
        // Debug: Log what we're about to submit
        log('Training Types - Selected: $_selectedTrainingTypes');
        log('Training Types - Count: ${_selectedTrainingTypes.length}');
        
        // Add the answer to the answers service (as array for multi-select)
        _answersService.addMultiSelectAnswer(question.id, _selectedTrainingTypes);
        
        // Debug: Log what's in the answers service
        log('Answers Service - All answers: ${_answersService.answers}');
        
        // Submit answers to API
        await _answersService.submitAnswers();
      }
      
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
