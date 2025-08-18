import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';

class PromotionalOfferBody extends StatelessWidget {
  const PromotionalOfferBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 812.h,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Color(0xFF28A228), Color(0xD85CD65C)],
        ),
      ),
      child: Stack(
        children: [
          // Top status bar area
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 375.w,
              height: 44.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: Stack(
                children: [
                  Positioned(
                    left: 16.w,
                    top: 14.h,
                    child: Container(
                      width: 54.w,
                      height: 21.h,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.r)),
                        ),
                      ),
                      child: Stack(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Close button (X)
          Positioned(
            right: 16.w,
            top: 60.h,
            child: GestureDetector(
              onTap: () => context.push(AppRouter.home),
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Color(0xFF28A228),
                  size: 20.sp,
                ),
              ),
            ),
          ),
          
          // Main content
          Positioned(
            left: 16.w,
            top: 120.h,
            child: SizedBox(
              width: 343.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Alarm GIF
                  SizedBox(
                    width: 200.w,
                    height: 200.h,
                    child: Image.asset(
                      'assets/images/alarm.gif',
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Limited Time Offer text
                  SizedBox(
                    width: 266.w,
                    child: Text(
                      'Limited Time Offer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Cancel anytime text
                  Text(
                    'Cancel anytime No hidden fees',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // 50% OFF text
                  SizedBox(
                    width: 266.w,
                    child: Text(
                      '50% OFF',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFDC416),
                        fontSize: 48.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Pricing section
                  SizedBox(
                    width: 186.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Original price
                        SizedBox(
                          width: 186.w,
                          child: Text(
                            ' \$10.99/month ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.white,
                              decorationThickness: 1,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 4.h),
                        
                        // Discounted price
                        SizedBox(
                          width: 186.w,
                          child: Text(
                            'Just \$5.99/month ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFFDC416),
                              fontSize: 18.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Countdown timer section
                  SizedBox(
                    width: 154.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 154.w,
                          child: Text(
                            'Your Offer ends in',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 4.h),
                        
                        SizedBox(
                          width: 154.w,
                          child: Text(
                            '04:15:10',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 40.h),
                  
                  // CTA Button
                  SizedBox(
                    width: 343.w,
                    height: 50.h,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () => context.push(AppRouter.home),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color(0xFF28A228),
                          elevation: 8,
                          shadowColor: Color(0x3F28A228),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            side: BorderSide(
                              width: 1.50,
                              color: Color(0xFF28A228),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        ),
                        child: Center(
                          child: Text(
                            'Go Premium now',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF28A228),
                              fontSize: 16.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                              letterSpacing: 0.50,
                            ),
                          ),
                        ),
                      ),
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
}
