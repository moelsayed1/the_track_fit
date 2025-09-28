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
  final TextStyle? style;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.width,
    this.height,
    this.margin,
    this.isLoading = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    final buttonWidth =
        width ?? responsive.screenWidth - (responsive.wp(5) * 2);
    final buttonHeight = height ?? responsive.hp(6);

    return Container(
      margin: margin,
      width: buttonWidth.isFinite ? buttonWidth : null,
      height: buttonHeight,
      child: ElevatedButton(
        style: ButtonStyle(
          fixedSize: WidgetStateProperty.all(Size(buttonWidth, buttonHeight)),
          padding: WidgetStateProperty.all(EdgeInsets.zero),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: type == ButtonType.outline
                  ? const BorderSide(color: AppColors.primaryGreen, width: 1.5)
                  : BorderSide.none,
            ),
          ),
          backgroundColor: type == ButtonType.primary
              ? WidgetStateProperty.all(AppColors.primaryGreen)
              : WidgetStateProperty.all(Colors.transparent),
          elevation: WidgetStateProperty.all(
            type == ButtonType.primary ? 3 : 0,
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
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
            : Text(
                text,
                textAlign: TextAlign.center,
                style:
                    style ??
                    (type == ButtonType.primary
                        ? AppTextStyles.buttonPrimary
                        : AppTextStyles.buttonSecondary),
              ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final bool isLoading;
  final TextStyle? style;
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width,
    this.height,
    this.margin,
    this.isLoading = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: CustomButton(
        text: text,
        style: style,
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
