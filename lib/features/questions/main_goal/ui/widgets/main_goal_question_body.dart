import 'package:flutter/material.dart';
import 'package:the_track_fit/features/questions/data/services/answers_service.dart';
import 'package:the_track_fit/features/questions/data/services/questions_service.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class MainGoalQuestionBody extends StatefulWidget {
  const MainGoalQuestionBody({super.key});

  @override
  State<MainGoalQuestionBody> createState() => _MainGoalQuestionBodyState();
}

class _MainGoalQuestionBodyState extends State<MainGoalQuestionBody> {
  String? _selectedGoal;
  bool _isLoading = false;
  bool _isLoadingOptions = true;
  String? _error;
  final int _currentStep = 7; // This is question 7 of 14
  final int _totalSteps = 14;

  // Services
  final QuestionsService _questionsService = QuestionsService.instance;
  final AnswersService _answersService = AnswersService.instance;

  // Main goal options from the API response
  List<String> _goalOptions = [];
  String _questionText = 'What\'s your Main Goal?';

  @override
  void initState() {
    super.initState();
    _loadMainGoalOptions();
  }

  Future<void> _loadMainGoalOptions() async {
    try {
      setState(() {
        _isLoadingOptions = true;
        _error = null;
      });

      final question = await _questionsService.getMainGoalQuestion();
      
      if (question != null && question.options != null) {
        setState(() {
          _questionText = question.enText;
          _goalOptions = question.options!.map((option) => option.en).toList();
          _isLoadingOptions = false;
        });
      } else {
        setState(() {
          _error = 'No main goal options available';
          _isLoadingOptions = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load main goal options: ${e.toString()}';
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
        
        // Goal Options - Make scrollable
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
                            onPressed: _loadMainGoalOptions,
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: _buildGoalOptions(responsive),
                    ),
        ),
        
        // Continue Button
        _buildContinueButton(responsive),
        
        SizedBox(height: responsive.hp(4)),
      ],
    );
  }

  Widget _buildGoalOptions(ResponsiveHelper responsive) {
    if (_goalOptions.isEmpty) {
      return Center(
        child: Text(
          'No main goal options available',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.black,
            fontSize: responsive.sp(16),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.h(8)),
      child: Column(
        children: _goalOptions.map((option) {
          final isSelected = _selectedGoal == option;
          return Column(
            children: [
              _buildGoalOption(
                responsive,
                value: option,
                label: option,
                isSelected: isSelected,
                onTap: () => _selectGoal(option),
              ),
              if (option != _goalOptions.last)
                SizedBox(height: responsive.h(16)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGoalOption(
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
                  borderRadius: BorderRadius.circular(16), // Circular radio button
                ),
              ),
              child: isSelected
                  ? Container(
                      width: responsive.w(9),
                      height: responsive.h(9),
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(),
                      ),
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
    final isEnabled = _selectedGoal != null;
    
    return SizedBox(
      width: double.infinity,
      height: responsive.h(50),
      child: Container(
        decoration: BoxDecoration(
          gradient: isEnabled 
              ? const LinearGradient(
                  begin: Alignment(0.00, 0.50),
                  end: Alignment(1.00, 0.50),
                  colors: [Color(0xFF28A228), Color(0xD85CD65C)],
                )
              : null,
          color: isEnabled ? null : const Color(0xFFBDBDBD),
          borderRadius: BorderRadius.circular(30),
          boxShadow: isEnabled ? [
            BoxShadow(
              color: const Color(0x1928A228),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: -25,
            ),
          ] : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: isEnabled ? _handleContinue : null,
            child: Container(
              width: double.infinity,
              height: responsive.h(56),
              alignment: Alignment.center,
              child: _isLoading
                  ? SizedBox(
                      width: responsive.w(24),
                      height: responsive.h(24),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isEnabled ? Colors.white : Colors.grey[600]!,
                        ),
                      ),
                    )
                  : Text(
                      'Continue',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: responsive.sp(16),
                        fontWeight: FontWeight.w500,
                        color: isEnabled ? Colors.white : Colors.grey[600]!,
                        height: 1.50,
                        letterSpacing: 0.50,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _selectGoal(String goal) {
    setState(() {
      _selectedGoal = goal;
    });
  }

  void _handleContinue() async {
    if (_selectedGoal == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Get the question ID from the service
      final question = await _questionsService.getMainGoalQuestion();
      if (question != null) {
        // Add the answer to the answers service (as single value for radio button)
        _answersService.addAnswer(question.id, _selectedGoal!);
        
        // Submit answers to API
        await _answersService.submitAnswers();
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Main goal selected: $_selectedGoal'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        
        // Navigate to next question screen
        context.push(AppRouter.activityLevelQuestion);
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
