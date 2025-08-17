import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? illustration;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.illustration,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Illustration area
        if (illustration != null)
          Container(
            width: responsive.wp(66.7), // 250px equivalent
            height: responsive.wp(66.7),
            margin: EdgeInsets.only(bottom: responsive.h(43)),
            child: illustration,
          ),

        // Title and subtitle
        SizedBox(
          width: responsive.wp(68.8), // 258px equivalent
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.darkGray,
                  fontSize: responsive.sp(20),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: responsive.hp(1)),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grayMedium,
                  fontSize: responsive.sp(12),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
