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

class EquipmentQuestionBody extends StatefulWidget {
  const EquipmentQuestionBody({super.key});

  @override
  State<EquipmentQuestionBody> createState() => _EquipmentQuestionBodyState();
}

class _EquipmentQuestionBodyState extends State<EquipmentQuestionBody> {
  final List<String> _selectedEquipment = [];
  bool _isLoading = false;
  bool _isLoadingOptions = true;
  String? _error;
  final int _currentStep = 10; // This is question 10 of 14
  final int _totalSteps = 14;

  // Services
  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;

  // Equipment question from the API response
  Question? _equipmentQuestion;

  @override
  void initState() {
    super.initState();
    _loadEquipmentQuestion();
  }

  Future<void> _loadEquipmentQuestion() async {
    try {
      setState(() {
        _isLoadingOptions = true;
        _error = null;
      });

      final question = await _questionsService.getAvailableEquipmentQuestion();
      
      if (question != null) {
        setState(() {
          _equipmentQuestion = question;
          _isLoadingOptions = false;
        });
      } else {
        setState(() {
          _error = 'No equipment options available';
          _isLoadingOptions = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load equipment options: ${e.toString()}';
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
            _equipmentQuestion?.localizedText ?? 'What\'s your Available Equipment?',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
            textAlign: TextAlign.start,
          ),
        ),
        
        SizedBox(height: responsive.hp(2)),
        
        // Equipment Options - Make scrollable
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
                            onPressed: _loadEquipmentQuestion,
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
                      child: _buildEquipmentOptions(responsive),
                    ),
        ),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(2)),
        ],
      ),
    );
  }

  Widget _buildEquipmentOptions(ResponsiveHelper responsive) {
    if (_equipmentQuestion?.options == null || _equipmentQuestion!.options!.isEmpty) {
      return Center(
        child: LocalizedText(
          'No equipment options available',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.black,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.h(8)),
      child: Column(
        children: _equipmentQuestion!.options!.map((option) {
          final isSelected = _selectedEquipment.contains(option.en);
          return Column(
            children: [
              _buildEquipmentOption(
                responsive,
                value: option.en,
                label: option.localizedText,
                isSelected: isSelected,
                onTap: () => _toggleEquipment(option.en),
              ),
              if (option != _equipmentQuestion!.options!.last)
                SizedBox(height: responsive.h(16)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEquipmentOption(
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
      isEnabled: _selectedEquipment.isNotEmpty,
      isLoading: _isLoading,
      onPressed: _handleContinue,
    );
  }

  void _toggleEquipment(String equipment) {
    setState(() {
      if (_selectedEquipment.contains(equipment)) {
        _selectedEquipment.remove(equipment);
        log('Removed: $equipment. Current selections: $_selectedEquipment');
      } else {
        _selectedEquipment.add(equipment);
        log('Added: $equipment. Current selections: $_selectedEquipment');
      }
    });
  }

  void _handleContinue() async {
    if (_selectedEquipment.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the question ID from the service
      final question = await _questionsService.getAvailableEquipmentQuestion();
      if (question != null) {
        // Debug: Log what we're about to submit
        log('Equipment - Selected: $_selectedEquipment');
        log('Equipment - Count: ${_selectedEquipment.length}');
        
        // Add the answer to the answers service (as array for multi-select)
        _answersService.addMultiSelectAnswer(question.id, _selectedEquipment);
        
        // Debug: Log what's in the answers service
        log('Answers Service - All answers: ${_answersService.answers}');
        
        // Submit answers to API
        await _answersService.submitAnswers();
      }
      
      if (mounted) {
        // Navigate to next question screen
        context.push(AppRouter.dietSystemQuestion);
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
