import 'package:flutter/material.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/utils/responsive_helper.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onClear;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveHelper = ResponsiveHelper(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // --- Chip الأساسي ---
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: responsiveHelper.w(16),
            vertical: responsiveHelper.h(8),
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.lightGreen // خلفية فاتحة من Figma
                : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? AppColors.primaryGreen
                  : const Color(0xFF1E1E1E),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(responsiveHelper.w(30)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: const Color(0xFF1E1E1E),
              fontSize: responsiveHelper.sp(12),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // --- Close Icon ---
        if (isSelected && onClear != null)
          Positioned(
            top: -responsiveHelper.h(6),
            right: -responsiveHelper.w(6),
            child: GestureDetector(
              onTap: onClear,
              child: Container(
                width: responsiveHelper.w(20),
                height: responsiveHelper.h(20),
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
