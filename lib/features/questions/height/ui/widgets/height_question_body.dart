import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_text_styles.dart';
import '../../../../../core/utils/responsive_helper.dart';
import '../../../../../core/widgets/question_header.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/router/app_router.dart';

class HeightQuestionBody extends StatefulWidget {
  const HeightQuestionBody({super.key});

  @override
  State<HeightQuestionBody> createState() => _HeightQuestionBodyState();
}

class _HeightQuestionBodyState extends State<HeightQuestionBody> {
  int _selectedHeight = 185; // Default height in cm - now mutable
  bool _isLoading = false;
  final int _currentStep = 3; // This is question 3 of 6
  final int _totalSteps = 4;
  
      final int _minHeight = 150; // Minimum height in cm
  final int _maxHeight = 220; // Maximum height in cm
  
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
            'What\'s your Height ?',
            style: AppTextStyles.heading2.copyWith(
              fontSize: responsive.sp(24),
              fontWeight: FontWeight.w600,
              color: AppColors.black,
            ),
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
    return SizedBox(
      width: double.infinity,
      height: responsive.h(50),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, 0.50),
            end: Alignment(1.00, 0.50),
            colors: [Color(0xFF28A228), Color(0xD85CD65C)],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1928A228),
              blurRadius: 25,
              offset: const Offset(0, 10),
              spreadRadius: -25,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: _handleContinue,
            child: Container(
              width: double.infinity,
              height: responsive.h(56),
              alignment: Alignment.center,
              child: _isLoading
                  ? SizedBox(
                      width: responsive.w(24),
                      height: responsive.h(24),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Continue',
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
      ),
    );
  }

  void _handleContinue() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implement height selection logic
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Height selected: $_selectedHeight cm'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        
        // Navigate to next question screen
        context.push(AppRouter.weightQuestion);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
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
