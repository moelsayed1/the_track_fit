import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/router/app_router.dart';

class PlanSubscriptionScreen extends StatefulWidget {
  const PlanSubscriptionScreen({super.key});

  @override
  State<PlanSubscriptionScreen> createState() => _PlanSubscriptionScreenState();
}

class _PlanSubscriptionScreenState extends State<PlanSubscriptionScreen> {
  int? _selectedPlanIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: Column(
        children: [
          // Close button at the top
          Padding(
            padding: EdgeInsets.only( right: 15.w),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  context.push(AppRouter.homeFeature);
                },
                child: Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 12.h),
                  _buildHeader(),
                  SizedBox(height: 30.h),
                  _buildPlanCard(
                    index: 0,
                    title: 'Pro Plan',
                    price: '30 \$',
                    isMostPopular: true,
                  ),
                  SizedBox(height: 16.h),
                  _buildPlanCard(
                    index: 1,
                    title: 'Pro Plan',
                    price: '30 \$',
                    isMostPopular: false,
                  ),
                  SizedBox(height: 20.h), 
                ],
              ),
            ),
          ),
          
          // Buy Now button at the bottom
          if (_selectedPlanIndex != null)
            _buildBuyNowButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/images/plan.svg',
          height: 200.h,
        ),
        SizedBox(height: 20.h),
        Text(
          'Unlock Your Fit The Track',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the plan that fits your fitness journey.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF848484),
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanCard({
    required int index,
    required String title,
    required String price,
    required bool isMostPopular,
  }) {
    bool isSelected = _selectedPlanIndex != null && _selectedPlanIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlanIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF28A228) : const Color(0x26848484),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x191E1E1E),
              blurRadius: 4,
              offset: Offset(0, 0),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (isMostPopular)
                          Container(
                            margin: EdgeInsets.only(left: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0x26FBBC05),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Color(0xFFFBBC05), size: 10.sp),
                                const SizedBox(width: 4),
                                Text(
                                  'Most Popular',
                                  style: TextStyle(
                                    color: Color(0xFFFBBC05),
                                    fontSize: 10.sp,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          price,
                          style: TextStyle(
                            color: Color(0xFF1E1E1E),
                            fontSize: 18.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '/month',
                          style: TextStyle(
                            color: Color(0xBF1E1E1E),
                            fontSize: 10.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildSelectButton(isSelected),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0x26848484), thickness: 1),
            const SizedBox(height: 16),
            _buildFeatureRow(text: 'AI feedback'),
            const SizedBox(height: 13),
            _buildFeatureRow(text: 'Advanced analytics'),
            const SizedBox(height: 13),
            _buildFeatureRow(text: 'Save progress'),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectButton(bool isSelected) {
    if (isSelected) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, 0.50),
            end: Alignment(1.00, 0.50),
            colors: [Color(0xFF28A228), Color(0xD85CD65C)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          children: [
            Icon(Icons.check, color: Colors.white, size: 14),
            SizedBox(width: 4),
            Text(
              'Selected',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF28A228), width: 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          'Select',
          style: TextStyle(
            color: Color(0xFF28A228),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  Widget _buildFeatureRow({required String text}) {
    return Row(
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF5CB85C), size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildBuyNowButton() {
    // Get the selected plan details
    final selectedPlan = _getSelectedPlan();
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: ElevatedButton(
        onPressed: () {
          // Pass the selected plan data to checkout
          context.push(AppRouter.checkoutPlan, extra: selectedPlan);
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Center(
            child: Text(
              'Buy Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getSelectedPlan() {
    if (_selectedPlanIndex == 0) {
      return {
        'title': 'Pro Plan',
        'price': '30\$',
        'isMostPopular': true,
        'features': ['AI feedback', 'Advanced analytics', 'Save progress'],
      };
    } else if (_selectedPlanIndex == 1) {
      return {
        'title': 'Pro Plan',
        'price': '30\$',
        'isMostPopular': false,
        'features': ['AI feedback', 'Advanced analytics', 'Save progress'],
      };
    }
    return {};
  }
}