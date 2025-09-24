import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import '../../data/services/subscription_service.dart';
import '../../domain/models/subscription_response.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  SubscriptionResponse? _subscriptionResponse;
  bool _isLoading = true;
  String? _error;
  
  // Services
  final SubscriptionService _subscriptionService = SubscriptionService.instance;

  @override
  void initState() {
    super.initState();
    _loadSubscription();
  }

  Future<void> _loadSubscription() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final subscriptionResponse = await _subscriptionService.getCurrentSubscription();
      
      setState(() {
        _subscriptionResponse = subscriptionResponse;
        _isLoading = false;
      });
      
      log('Loaded subscription: ${subscriptionResponse.hasActiveSubscription}');
    } catch (e) {
      setState(() {
        _error = 'Failed to load subscription: ${e.toString()}';
        _isLoading = false;
      });
      log('Error loading subscription: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            // Header at the top
            Container(
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
            
            // Main Content
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _error != null
                      ? _buildErrorState()
                      : _subscriptionResponse?.hasActiveSubscription == true
                          ? _buildActiveSubscriptionContent()
                          : _buildNoSubscriptionContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          
          // Shimmer for subscription card
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: double.infinity,
                height: 120.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Shimmer for plan includes section
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shimmer for "Plan Includes" title
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 120.w,
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                // Shimmer for features container
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red,
              fontSize: 16.sp,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _loadSubscription,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSubscriptionContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20.h), // Small spacing from header
          // No subscription icon
          Container(
            width: 120.w,
            height: 120.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.subscriptions,
              size: 60.sp,
              color: const Color(0xFF848484),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'No Active Subscription',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You don\'t have an active subscription yet.\nChoose a plan to get started!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF848484),
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 32.h),
          // Browse Plans button
          SizedBox(
            width: 200.w,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to plans screen
                context.push(AppRouter.planSubscription);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Text(
                'Browse Packages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSubscriptionContent() {
    final subscription = _subscriptionResponse!.data!;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.h), // Small spacing from header
          
          // Subscription Plan Card
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
                                subscription.enName,
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
                                    subscription.formattedPrice,
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
                                    '/${subscription.durationMonths} months',
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
                          subscription.isSubscriptionActive ? 'Plan Active' : 'Plan Inactive',
                          style: TextStyle(
                            color: subscription.isSubscriptionActive 
                                ? const Color(0xFF28A228) 
                                : const Color(0xFFEA4335),
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
                    'Your Plan is available till ${subscription.availableTill}',
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
                      children: subscription.features.map((feature) => Column(
                        children: [
                          _buildFeatureItem(feature),
                          if (feature != subscription.features.last) SizedBox(height: 16.h),
                        ],
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 100.h), // Bottom spacing
        ],
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
        Expanded(
          child: Text(
            feature,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ),
      ],
    );
  }
}