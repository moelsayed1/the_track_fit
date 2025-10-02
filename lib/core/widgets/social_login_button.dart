import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../bloc/language/language_bloc.dart';

class SocialLoginButton extends StatelessWidget {
  final String text;
  final String? iconPath;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final Widget? icon;
  final VoidCallback onPressed;
  final bool isLoading;

  const SocialLoginButton({
    super.key,
    required this.text,
    this.iconPath,
    this.icon,
    this.width,
    this.height,
    required this.onPressed,
    this.margin,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    final buttonWidth = width ?? responsive.screenWidth - (responsive.wp(8) * 2);
    final buttonHeight = height ?? responsive.hp(6);

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, languageState) {
        final currentLanguage = languageState is LanguageLoaded 
            ? languageState.currentLanguage 
            : 'ar';
        final fontFamily = currentLanguage == 'ar' ? 'Cairo' : 'Poppins';

        return Container(
          width: buttonWidth,
          height: buttonHeight,
          margin: margin,
          decoration: ShapeDecoration(
            color: AppColors.grayLight.withValues(alpha: 0.15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isLoading) ...[
                    SizedBox(
                      width: responsive.sp(20),
                      height: responsive.sp(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkGray),
                      ),
                    ),
                    SizedBox(width: responsive.wp(2)),
                  ] else if (icon != null || iconPath != null) ...[
                    if (icon != null)
                      icon!
                    else if (iconPath != null)
                      iconPath!.endsWith('.svg')
                          ? SvgPicture.asset(
                              iconPath!,
                              width: responsive.sp(20),
                              height: responsive.sp(20),
                            )
                          : Image.asset(
                              iconPath!,
                              width: responsive.sp(20),
                              height: responsive.sp(20),
                            ),
                    SizedBox(width: responsive.wp(2)),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: AppColors.darkGray,
                      fontSize: responsive.sp(16),
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
