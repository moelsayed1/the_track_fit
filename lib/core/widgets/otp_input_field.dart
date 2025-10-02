import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../extensions/localization_extensions.dart';

class OtpInputFormatter extends TextInputFormatter {
  final VoidCallback? onBackspace;
  final int index;

  OtpInputFormatter({this.onBackspace, required this.index});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty and old value had a character, trigger backspace
    if (newValue.text.isEmpty && oldValue.text.isNotEmpty) {
      if (onBackspace != null) {
        onBackspace!();
      }
    }
    return newValue;
  }
}

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isActive;
  final bool isFilled;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onBackspace;
  final int index;

  const OtpInputField({
    super.key,
    required this.controller,
    required this.index,
    this.isActive = false,
    this.isFilled = false,
    this.onTap,
    this.focusNode,
    this.onChanged,
    this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isArabic = context.isArabic;
    
    return Container(
      width: responsive.w(40),
      height: responsive.h(48),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.w(6),
        vertical: responsive.h(6),
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
                     side: BorderSide(
             width: 1.5,
             color: isActive 
               ? Color(0xff28A228) 
               : (isFilled ? AppColors.gray : AppColors.grayLight.withValues(alpha: 0.15)),
           ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          onTap: onTap,
          onChanged: onChanged,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          showCursor: true,
          cursorColor: AppColors.primaryGreen,

          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
            OtpInputFormatter(
              index: index,
              onBackspace: onBackspace,
            ),
          ],
          style: TextStyle(
            fontSize: responsive.sp(20),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827), // Dark gray for better visibility
            height: 1.0,
            fontFamily: isArabic ? 'Cairo' : 'Poppins',
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
            counterText: '',
            hintText: '',
          ),
        ),
      ),
    );
  }
}
