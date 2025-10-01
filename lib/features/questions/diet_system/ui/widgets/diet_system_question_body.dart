import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:the_track_fit/features/questions/data/services/answers_service.dart';
import 'package:the_track_fit/features/questions/data/services/questions_service.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import '../../../../../core/widgets/question_continue_button.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class DietSystemQuestionBody extends StatefulWidget {
  const DietSystemQuestionBody({super.key});

  @override
  State<DietSystemQuestionBody> createState() => _DietSystemQuestionBodyState();
}

class _DietSystemQuestionBodyState extends State<DietSystemQuestionBody> {
  final List<String> _selectedDietSystems = [];
  bool _isLoading = false;
  bool _isLoadingOptions = true;
  String? _error;
  final int _currentStep = 11; // This is question 11 of 14
  final int _totalSteps = 14;

  // Services
  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;

  // Diet system options from the API response
  List<Map<String, String>> _dietSystemOptions = [];
  String _questionText = '';

  @override
  void initState() {
    super.initState();
    _loadDietSystemQuestion();
  }

  Future<void> _loadDietSystemQuestion() async {
    try {
      setState(() {
        _isLoadingOptions = true;
        _error = null;
      });

      final question = await _questionsService.getCurrentDietSystemQuestion();
      
      if (question != null && question.options != null) {
        setState(() {
          _questionText = question.localizedText;
          _dietSystemOptions = question.options!.map((option) => {
            'value': option.localizedText,
            'label': option.localizedText,
          }).toList();
          _isLoadingOptions = false;
        });
      } else {
        setState(() {
          _error = AppLocalizations.of(context)!.noDietSystemOptionsAvailable;
          _isLoadingOptions = false;
        });
      }
    } catch (e) {
        setState(() {
          _error = '${AppLocalizations.of(context)!.failedToLoadDietSystemOptions}: ${e.toString()}';
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
          title: AppLocalizations.of(context)!.letsSetUpYourPlan,
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
        
        // Diet System Options - Make scrollable
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
                            onPressed: _loadDietSystemQuestion,
                            child: Text(AppLocalizations.of(context)!.retry),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: _buildDietSystemOptions(responsive),
                    ),
        ),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(4)),
      ],
    );
  }

  Widget _buildDietSystemOptions(ResponsiveHelper responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.h(8)),
      child: Column(
        children: _dietSystemOptions.map((option) {
          final isSelected = _selectedDietSystems.contains(option['value']);
          return Column(
            children: [
              _buildDietSystemOption(
                responsive,
                value: option['value']!,
                label: option['label']!,
                isSelected: isSelected,
                onTap: () => _toggleDietSystem(option['value']!),
              ),
              if (option != _dietSystemOptions.last)
                SizedBox(height: responsive.h(16)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDietSystemOption(
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
                    width: 1,
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
      isEnabled: _selectedDietSystems.isNotEmpty,
      isLoading: _isLoading,
      onPressed: _handleContinue,
    );
  }

  void _toggleDietSystem(String dietSystem) {
    setState(() {
      if (_selectedDietSystems.contains(dietSystem)) {
        _selectedDietSystems.remove(dietSystem);
        log('Removed: $dietSystem. Current selections: $_selectedDietSystems');
      } else {
        _selectedDietSystems.add(dietSystem);
        log('Added: $dietSystem. Current selections: $_selectedDietSystems');
      }
    });
  }

  void _handleContinue() async {
    if (_selectedDietSystems.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the question ID from the service
      final question = await _questionsService.getCurrentDietSystemQuestion();
      if (question != null) {
        // Debug: Log what we're about to submit
        log('Diet System - Selected: $_selectedDietSystems');
        log('Diet System - Count: ${_selectedDietSystems.length}');
        
        // Add the answer to the answers service (as array for multi-select)
        _answersService.addMultiSelectAnswer(question.id, _selectedDietSystems);
        
        // Debug: Log what's in the answers service
        log('Answers Service - All answers: ${_answersService.answers}');
        
        // Submit answers to API
        await _answersService.submitAnswers();
      }
      
      if (mounted) {
        // Navigate to next question screen
        context.push(AppRouter.healthStatusQuestion);
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
