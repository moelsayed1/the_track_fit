import 'package:flutter/material.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';
import 'package:the_track_fit/core/constants/app_text_styles.dart';

/// Common continue button widget for all question screens
/// 
/// Usage example:
/// ```dart
/// QuestionContinueButton(
///   isEnabled: _selectedValue != null,
///   isLoading: _isLoading,
///   onPressed: _handleContinue,
///   text: 'Continue', // Optional, defaults to 'Continue'
/// )
/// ```
class QuestionContinueButton extends StatelessWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onPressed;
  final String text;
  final double? width;
  final double? height;

  const QuestionContinueButton({
    super.key,
    required this.isEnabled,
    this.isLoading = false,
    this.onPressed,
    this.text = 'Continue',
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? responsive.h(50),
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
            onTap: isEnabled ? onPressed : null,
            child: Container(
              width: double.infinity,
              height: height ?? responsive.h(50),
              alignment: Alignment.center,
              child: isLoading
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
                      text,
                      style: AppTextStyles.buttonPrimary.copyWith(
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
}
