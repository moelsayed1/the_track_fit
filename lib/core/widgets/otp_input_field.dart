import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../utils/responsive_helper.dart';

class OtpInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isActive;
  final bool isFilled;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const OtpInputField({
    super.key,
    required this.controller,
    this.isActive = false,
    this.isFilled = false,
    this.onTap,
    this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    return Container(
      width: responsive.w(70),
      height: responsive.h(56),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.w(20),
        vertical: responsive.h(16),
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
            inputFormatters: [
              LengthLimitingTextInputFormatter(1),
              FilteringTextInputFormatter.digitsOnly,
            ],
                         style: AppTextStyles.bodyLarge.copyWith(
               fontSize: responsive.sp(16),
               fontWeight: FontWeight.w500,
               color: isActive 
                 ? AppColors.primaryGreen 
                 : (isFilled ? AppColors.gray : AppColors.gray),
               height: 1.0, // Ensure single line height
             ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true, // Makes the field more compact
              counterText: '', // Removes character counter
            ),
          ),
        ),
    );
  }
}
