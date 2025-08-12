import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../constants/app_assets.dart';
import '../utils/responsive_helper.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData? prefixIcon;
  final String? prefixIconAsset;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.prefixIconAsset,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.grayLight.withValues(alpha: 0.15),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        obscureText: widget.isPassword ? _obscurePassword : false,
        style: TextStyle(
          color: AppColors.darkGray,
          fontSize: responsive.sp(12),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: AppColors.grayMedium.withValues(alpha: 0.7),
            fontSize: responsive.sp(12),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
                     prefixIcon: _buildPrefixIcon(responsive),
                     suffixIcon: widget.isPassword
               ? IconButton(
                   onPressed: () {
                     setState(() {
                       _obscurePassword = !_obscurePassword;
                     });
                   },
                   icon: _obscurePassword
                       ? SvgPicture.asset(
                           AppIcons.eyeSlash,
                           width: responsive.sp(16),
                           height: responsive.sp(16),
                           colorFilter: ColorFilter.mode(
                             AppColors.grayMedium,
                             BlendMode.srcIn,
                           ),
                         )
                       : Icon(
                           Icons.visibility,
                           size: responsive.sp(16),
                           color: AppColors.grayMedium,
                         ),
                 )
               : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: responsive.wp(5),
            vertical: responsive.hp(1.8),
          ),
                 ),
       ),
     );
   }

   Widget? _buildPrefixIcon(ResponsiveHelper responsive) {
     if (widget.prefixIconAsset != null) {
       return Padding(
         padding: EdgeInsets.symmetric(
           horizontal: responsive.wp(4),
           vertical: responsive.hp(1.5),
         ),
         child: widget.prefixIconAsset!.endsWith('.svg')
             ? SvgPicture.asset(
                 widget.prefixIconAsset!,
                 width: responsive.sp(16),
                 height: responsive.sp(16),
                 colorFilter: ColorFilter.mode(
                   AppColors.primaryGreen,
                   BlendMode.srcIn,
                 ),
               )
             : Image.asset(
                 widget.prefixIconAsset!,
                 width: responsive.sp(16),
                 height: responsive.sp(16),
                 color: AppColors.primaryGreen,
               ),
       );
     } else if (widget.prefixIcon != null) {
       return Padding(
         padding: EdgeInsets.symmetric(
           horizontal: responsive.wp(4),
           vertical: responsive.hp(1.5),
         ),
         child: Icon(
           widget.prefixIcon,
           size: responsive.sp(16),
           color: AppColors.primaryGreen,
         ),
       );
     }
     return null;
   }
}
