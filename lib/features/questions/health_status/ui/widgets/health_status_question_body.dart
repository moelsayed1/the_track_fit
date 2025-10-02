import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:the_track_fit/features/questions/data/services/answers_service.dart';
import 'package:the_track_fit/features/questions/data/services/questions_service.dart';
import 'package:the_track_fit/features/questions/domain/models/question.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import '../../../../../core/widgets/question_continue_button.dart';
import '../../../../../core/widgets/localized_text.dart';
import '../../../../../core/extensions/localization_extensions.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class HealthStatusQuestionBody extends StatefulWidget {
  const HealthStatusQuestionBody({super.key});

  @override
  State<HealthStatusQuestionBody> createState() => _HealthStatusQuestionBodyState();
}

class _HealthStatusQuestionBodyState extends State<HealthStatusQuestionBody> {
  final List<String> _selectedHealthIssues = [];
  bool _isLoading = false;
  bool _isLoadingOptions = true;
  String? _error;
  final int _currentStep = 12; // This is question 12 of 14
  final int _totalSteps = 14;

  // Services
  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;

  // Health status question from the API response
  Question? _healthStatusQuestion;

  @override
  void initState() {
    super.initState();
    _loadHealthStatusQuestion();
  }

  Future<void> _loadHealthStatusQuestion() async {
    try {
      setState(() {
        _isLoadingOptions = true;
        _error = null;
      });

      final question = await _questionsService.getHealthStatusQuestion();
      
      if (question != null) {
        setState(() {
          _healthStatusQuestion = question;
          _isLoadingOptions = false;
        });
      } else {
        setState(() {
          _error = 'No health status options available';
          _isLoadingOptions = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load health status options: ${e.toString()}';
        _isLoadingOptions = false;
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
            _healthStatusQuestion?.localizedText ?? 'What\'s your Health Status?',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.start,
          ),
        ),
        
        SizedBox(height: responsive.hp(2)),
        
        // Health Status Options - Make scrollable
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
                          LocalizedText(
                            _error!,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.red,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadHealthStatusQuestion,
                            child: LocalizedText(
                              'Retry',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: _buildHealthStatusOptions(responsive),
                    ),
        ),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(2)),
        ],
      ),
    );
  }

  Widget _buildHealthStatusOptions(ResponsiveHelper responsive) {
    if (_healthStatusQuestion?.options == null || _healthStatusQuestion!.options!.isEmpty) {
      return Center(
        child: LocalizedText(
          'No health status options available',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.h(8)),
      child: Column(
        children: _healthStatusQuestion!.options!.map((option) {
          final isSelected = _selectedHealthIssues.contains(option.en);
          return Column(
            children: [
              _buildHealthStatusOption(
                responsive,
                value: option.en,
                label: option.localizedText,
                isSelected: isSelected,
                onTap: () => _toggleHealthIssue(option.en),
              ),
              if (option != _healthStatusQuestion!.options!.last)
                SizedBox(height: responsive.h(16)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHealthStatusOption(
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
      isEnabled: _selectedHealthIssues.isNotEmpty,
      isLoading: _isLoading,
      onPressed: _handleContinue,
    );
  }

  void _toggleHealthIssue(String healthIssue) {
    setState(() {
      if (_selectedHealthIssues.contains(healthIssue)) {
        _selectedHealthIssues.remove(healthIssue);
        log('Removed: $healthIssue. Current selections: $_selectedHealthIssues');
      } else {
        _selectedHealthIssues.add(healthIssue);
        log('Added: $healthIssue. Current selections: $_selectedHealthIssues');
      }
    });
  }

  void _handleContinue() async {
    if (_selectedHealthIssues.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the question ID from the service
      final question = await _questionsService.getHealthStatusQuestion();
      if (question != null) {
        // Debug: Log what we're about to submit
        log('Health Status - Selected: $_selectedHealthIssues');
        log('Health Status - Count: ${_selectedHealthIssues.length}');
        
        // Add the answer to the answers service (as array for multi-select)
        _answersService.addMultiSelectAnswer(question.id, _selectedHealthIssues);
        
        // Debug: Log what's in the answers service
        log('Answers Service - All answers: ${_answersService.answers}');
        
        // Submit answers to API
        await _answersService.submitAnswers();
      }
      
      if (mounted) {
        // Navigate to next question screen
        context.push(AppRouter.specialDietQuestion);
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
