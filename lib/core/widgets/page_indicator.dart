import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';

class PageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final double? spacing;

  const PageIndicator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final indicatorSpacing = spacing ?? responsive.wp(1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          width: index == currentPage ? responsive.wp(5.3) : responsive.wp(1.6),
          height: responsive.wp(1.6),
          margin: EdgeInsets.only(
            right: index < totalPages - 1 ? indicatorSpacing : 0,
          ),
          decoration: ShapeDecoration(
            color: index == currentPage
                ? AppColors.primaryGreen
                : AppColors.grayLight,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
