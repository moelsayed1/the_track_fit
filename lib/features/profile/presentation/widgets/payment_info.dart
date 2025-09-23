import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PaymentInfo extends StatelessWidget {
  const PaymentInfo({super.key});

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
                  
                  // Payment Method Card
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16.w),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Credit Card Icon and Number
                          Row(
                            children: [
                              Container(
                                width: 24.w,
                                height: 24.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/card.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '**** **** **** 4102',
                                style: TextStyle(
                                  color: const Color(0xFF848484),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          
                          // Next Payment Date
                          Text(
                            'Next Payment : Aug 15, 2025',
                            style: TextStyle(
                              color: const Color(0xFF848484),
                              fontSize: 10.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          
                          // Update Payment Method Button
                          GestureDetector(
                            onTap: () {
                              context.push('/update-payment-method');
                            },
                            child: Text(
                              'Update Payment Method',
                              style: TextStyle(
                                color: const Color(0xFF28A228),
                                fontSize: 12.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Security Message
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/images/lock_icon.svg',
                          width: 20.w,
                          height: 20.h,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Your info is securely stored.',
                          style: TextStyle(
                            color: const Color(0xFF848484),
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
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
                      'Payment Info',
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
}