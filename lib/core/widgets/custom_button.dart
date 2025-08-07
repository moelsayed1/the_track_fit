import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

import '../utils/responsive_helper.dart';

enum ButtonType { primary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.margin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    
    final buttonWidth = width ?? responsive.screenWidth - (responsive.wp(8) * 2);
    final buttonHeight = height ?? responsive.hp(7);

    return Container(
      width: buttonWidth,
      height: buttonHeight,
      margin: margin,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: type == ButtonType.primary ? 2 : 0,
            child: Container(
              width: buttonWidth,
              padding: EdgeInsets.symmetric(
                horizontal: responsive.wp(4),
                vertical: responsive.hp(1.7),
              ),
              decoration: _getButtonDecoration(responsive),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isLoading)
                    SizedBox(
                      width: responsive.wp(4),
                      height: responsive.wp(4),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          type == ButtonType.primary
                              ? AppColors.white
                              : AppColors.primaryGreen,
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: Text(
                        text,
                        textAlign: TextAlign.center,
                        style: type == ButtonType.primary
                            ? AppTextStyles.buttonPrimary
                            : AppTextStyles.buttonSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ShapeDecoration _getButtonDecoration(ResponsiveHelper responsive) {
    if (type == ButtonType.primary) {
      return ShapeDecoration(
        gradient: AppColors.primaryGradient,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.shadowGreen,
            blurRadius: 25,
            offset: Offset(0, 10),
            spreadRadius: -25,
          ),
        ],
      );
    } else {
      return ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1.50,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: AppColors.primaryGreen,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
      );
    }
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.margin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: CustomButton(
        text: text,
        type: ButtonType.primary,
        width: width,
        height: height,
        margin: margin,
        isLoading: isLoading,
      ),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool isLoading;

  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.margin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: CustomButton(
        text: text,
        type: ButtonType.outline,
        width: width,
        height: height,
        margin: margin,
        isLoading: isLoading,
      ),
    );
  }
}
