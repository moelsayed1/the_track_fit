import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';

class Subscription extends StatelessWidget {
  const Subscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 65.h),
                  
                  // Pro Plan Card
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignOutside,
                            color: const Color(0xFF28A228),
                          ),
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        shadows: [
                          BoxShadow(
                            color: const Color(0x191E1E1E),
                            blurRadius: 4.r,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Left side - Plan name and price
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pro Plan',
                                        style: TextStyle(
                                          color: AppColors.primaryGreen,
                                          fontSize: 18.sp,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                          height: 0.89,
                                        ),
                                      ),
                                      SizedBox(height: 12.h),
                                      Row(
                                        children: [
                                          Text(
                                            '30\$',
                                            style: TextStyle(
                                              color: const Color(0xFF1E1E1E),
                                              fontSize: 18.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                              height: 0.89,
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '/month',
                                            style: TextStyle(
                                              color: const Color(0xBF1E1E1E),
                                              fontSize: 10.sp,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              height: 1.60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Right side - Plan status
                                Text(
                                  'Plan Active',
                                  style: TextStyle(
                                    color: const Color(0xFF28A228),
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    height: 1.14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'Your Plan is available till 27/5',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Plan Includes Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Plan Includes',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            height: 1.14,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                color: const Color(0x26848484),
                              ),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            shadows: [
                              BoxShadow(
                                color: const Color(0x19000000),
                                blurRadius: 4.r,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              children: [
                                _buildFeatureItem('AI feedback'),
                                SizedBox(height: 16.h),
                                _buildFeatureItem('Advanced analytics'),
                                SizedBox(height: 16.h),
                                _buildFeatureItem('Save progress'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 100.h), // Bottom spacing
                ],
              ),
            ),
            
            // Header at the top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(color: const Color(0x26848484)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: SvgPicture.asset(
                        'assets/logos/arrow_left.svg',
                        width: 24.w,
                        height: 24.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF1E1E1E),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Subscription',
                      style: TextStyle(
                        color: const Color(0xFF1E1E1E),
                        fontSize: 18.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0.89,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.h,
          decoration: BoxDecoration(
            color: const Color(0xFF28A228),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            size: 14.sp,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          feature,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 1,
          ),
        ),
      ],
    );
  }
}