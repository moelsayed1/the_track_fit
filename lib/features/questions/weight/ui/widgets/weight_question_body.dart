import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/constants/app_text_styles.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/widgets/question_header.dart';

class WeightQuestionBody extends StatefulWidget {
  const WeightQuestionBody({super.key});

  @override
  State<WeightQuestionBody> createState() => _WeightQuestionBodyState();
}

class _WeightQuestionBodyState extends State<WeightQuestionBody> {
  final TextEditingController _weightController = TextEditingController();
  final FocusNode _weightFocusNode = FocusNode();
  bool _isInputFilled = false;

  @override
  void initState() {
    super.initState();
    _weightController.addListener(_onWeightChanged);
    _weightFocusNode.addListener(_onFocusChanged);
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



  void _onContinuePressed() {
    if (_weightController.text.isNotEmpty) {
      // Navigate to home after weight selection
      context.push(AppRouter.home);
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
          SizedBox(height: responsive.h(20)),
          
          // Question Header
          QuestionHeader(
            title: "Let's Set Up Your Plan",
            currentStep: 4,
            totalSteps: 4,
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
        "What's your Current\n Weight ?",
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
    return Container(
      width: double.infinity,
      height: responsive.h(56),
      decoration: BoxDecoration(
        color: _isInputFilled ? null : const Color(0xFFBDBDBD), // Grey when disabled
        gradient: _isInputFilled ? const LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Color(0xFF28A228), Color(0xD85CD65C)],
        ) : null,
        borderRadius: BorderRadius.circular(30),
        boxShadow: _isInputFilled ? [
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
          onTap: _isInputFilled ? _onContinuePressed : null,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: Text(
              "Continue",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: responsive.sp(16),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.50,
                letterSpacing: 0.50,
              ),
            ),
          ),
        ),
      ),
    );
  }

}
