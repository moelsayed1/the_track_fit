import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';

class MealCard extends StatelessWidget {
  final String mealType;
  final String description;
  final int calories;
  final String imagePath;
  final VoidCallback? onSwap;

  const MealCard({
    super.key,
    required this.mealType,
    required this.description,
    required this.calories,
    required this.imagePath,
    this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      //margin: EdgeInsets.only(bottom: 4.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        
      ),
      child: Row(
        children: [
          // Meal image
          Container(
            width: 94.w,
            height: 108.h,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.r),
                  bottomLeft: Radius.circular(15.r),
                ),
              ),
              image: DecorationImage(
                image: imagePath.startsWith('http') 
                    ? NetworkImage(imagePath) 
                    : AssetImage(imagePath) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            
          ),
          
          SizedBox(width: 16.w),
          
          // Meal details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType,
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: const Color(0xFF6C757D),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/fire.svg',
                      width: 18.w,
                      height: 18.h,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      '$calories kcal',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Swap icon
          GestureDetector(
            onTap: onSwap,
            child: SvgPicture.asset(
              'assets/images/swap.svg',
              width: 20.w,
              height: 20.h,
            ),
          ),
        ],
      ),
    );
  }
}
