import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import '../../data/services/coupon_service.dart';
import '../../domain/models/coupon_response.dart';

class CheckoutPlanScreen extends StatefulWidget {
  const CheckoutPlanScreen({super.key});

  @override
  State<CheckoutPlanScreen> createState() => _CheckoutPlanScreenState();
}

class _CheckoutPlanScreenState extends State<CheckoutPlanScreen> {
  String? _selectedPaymentMethod;
  bool _showCouponInput = false;
  final TextEditingController _couponController = TextEditingController();
  
  // Plan data received from previous screen
  late Map<String, dynamic> _planData;
  
  // Coupon-related state
  CouponData? _appliedCoupon;
  bool _isApplyingCoupon = false;
  String? _couponError;
  
  // Services
  final CouponService _couponService = CouponService.instance;

  @override
  void initState() {
    super.initState();
    // Initialize with default values in case no data is passed
    _planData = {
      'title': 'Pro Plan',
      'price': '30\$',
      'isMostPopular': true,
      'features': ['AI feedback', 'Advanced analytics', 'Save progress'],
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get the plan data passed from the previous screen via GoRouter
    final args = GoRouterState.of(context).extra;
    if (args != null && args is Map<String, dynamic>) {
      _planData = args;
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<void> _applyCoupon() async {
    final couponCode = _couponController.text.trim();
    if (couponCode.isEmpty) return;

    setState(() {
      _isApplyingCoupon = true;
      _couponError = null;
    });

    try {
      final response = await _couponService.applyCoupon(
        code: couponCode,
        packageId: _planData['id'] ?? 1, // Use plan ID from the data
      );

      if (response.isSuccess) {
        setState(() {
          _appliedCoupon = response.data;
          _couponError = null;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Coupon applied successfully!'),
            backgroundColor: const Color(0xFF28A228),
          ),
        );
      } else if (response.isInvalidOrExpired) {
        setState(() {
          _couponError = 'This coupon is invalid or expired';
          _appliedCoupon = null;
        });
      } else if (response.isUsageLimitReached) {
        setState(() {
          _couponError = 'Coupon usage limit reached';
          _appliedCoupon = null;
        });
      } else if (response.isValidationError) {
        setState(() {
          _couponError = 'Please enter a valid coupon code';
          _appliedCoupon = null;
        });
      } else {
        setState(() {
          _couponError = response.message;
          _appliedCoupon = null;
        });
      }
    } catch (e) {
      setState(() {
        _couponError = 'Failed to apply coupon. Please try again.';
        _appliedCoupon = null;
      });
      log('Error applying coupon: $e');
    } finally {
      setState(() {
        _isApplyingCoupon = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and Change Plan button
            _buildHeader(),
            
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    
                    // Your Plan section
                    _buildYourPlanSection(),
                    SizedBox(height: 24.h),
                    
                    // Coupon section
                    _buildCouponSection(),
                    SizedBox(height: 24.h),
                    
                    // Price breakdown
                    _buildPriceBreakdown(),
                    SizedBox(height: 24.h),
                    
                    // Payment methods
                    _buildPaymentMethods(),
                    SizedBox(height: 100.h), // Space for bottom button
                  ],
                ),
              ),
            ),
            
            // Pay button at bottom
            _buildPayButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: const BoxDecoration(
        color: Color(0x26848484),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button and title
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: SvgPicture.asset(
                  'assets/logos/arrow_left.svg',
                  width: 24.w,
                  height: 24.h,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Checkout',
                style: TextStyle(
                  color: const Color(0xFF1E1E1E),
                  fontSize: 18.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          
                     // Change Plan button
           GestureDetector(
             onTap: () => context.pop(),
             child: Container(
               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
               decoration: BoxDecoration(
                 border: Border.all(
                   color: const Color(0xFF28A228),
                   width: 1,
                 ),
                 borderRadius: BorderRadius.circular(30.r),
               ),
               child: Text(
                 'Change Plan',
                 style: TextStyle(
                   color: const Color(0xFF28A228),
                   fontSize: 12.sp,
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

  Widget _buildYourPlanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Plan is',
          style: TextStyle(
            color: const Color(0xFF848484),
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 16.h),
        
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFF28A228),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0x191E1E1E),
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _planData['title'] ?? 'Pro Plan',
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: 18.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0x26FBBC05),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: const Color(0xFFFBBC05),
                                size: 10.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _planData['isMostPopular'] == true ? 'Most Popular' : '',
                                style: TextStyle(
                                  color: const Color(0xFFFBBC05),
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
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Text(
                          _planData['price'] ?? '30\$',
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: 18.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
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
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Selected indicator
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment(0.00, 0.50),
                    end: Alignment(1.00, 0.50),
                    colors: [Color(0xFF28A228), Color(0xD85CD65C)],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCouponSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1E000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Got a Coupon code ?',
                style: TextStyle(
                  color: const Color(0xFF1E1E1E),
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showCouponInput = !_showCouponInput;
                    if (!_showCouponInput) {
                      _couponController.clear();
                      _appliedCoupon = null;
                      _couponError = null;
                    }
                  });
                },
                child: Text(
                  _showCouponInput ? 'Cancel' : 'Apply Coupon',
                  style: TextStyle(
                    color: const Color(0xFF28A228),
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          
          // Show applied coupon info
          if (_appliedCoupon != null) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F8F0),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFF28A228),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFF28A228),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coupon Applied Successfully!',
                          style: TextStyle(
                            color: const Color(0xFF28A228),
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Discount: ${_appliedCoupon!.formattedDiscountAmount}',
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _appliedCoupon = null;
                        _couponController.clear();
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: const Color(0xFF848484),
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          // Show coupon error
          if (_couponError != null) ...[
            SizedBox(height: 12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0F0),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: const Color(0xFFEA4335),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: const Color(0xFFEA4335),
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      _couponError!,
                      style: TextStyle(
                        color: const Color(0xFFEA4335),
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          if (_showCouponInput) ...[
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(
                  color: const Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _couponController,
                decoration: InputDecoration(
                  hintText: 'coupon',
                  hintStyle: TextStyle(
                    color: const Color(0xFF848484),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  color: const Color(0xFF1E1E1E),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _couponController,
              builder: (context, value, child) {
                final hasText = value.text.trim().isNotEmpty;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: hasText && !_isApplyingCoupon
                        ? _applyCoupon
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasText && !_isApplyingCoupon
                          ? const Color(0xFF28A228)
                          : const Color(0xFFCCCCCC),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: _isApplyingCoupon
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Apply',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    // Calculate prices
    final originalPrice = _planData['price'] ?? '30\$';
    final discountAmount = _appliedCoupon?.formattedDiscountAmount ?? '0 EGP';
    final finalPrice = _appliedCoupon?.formattedFinalPrice ?? originalPrice;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0x26848484),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1E000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow('Plan Price', originalPrice),
          _buildDivider(),
          if (_appliedCoupon != null) ...[
            _buildPriceRow('Coupon Discount', '-$discountAmount', isDiscount: true),
            _buildDivider(),
          ],
          _buildPriceRow('Total', finalPrice, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? const Color(0xFF1E1E1E) : const Color(0xFF1E1E1E),
              fontSize: isTotal ? 16.sp : 16.sp,
              fontFamily: 'Poppins',
              fontWeight: isTotal ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              color: isDiscount 
                  ? const Color(0xFF28A228) 
                  : isTotal 
                      ? const Color(0xFF1E1E1E)
                      : const Color(0xFF1E1E1E),
              fontSize: isTotal ? 18.sp : 18.sp,
              fontFamily: 'Poppins',
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: const Color(0x26848484),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Payment Method',
          style: TextStyle(
            color: const Color(0xFF1E1E1E),
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8.h),
        
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0x1E000000),
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildPaymentOption(
                  'PayPal',
                  'assets/images/paypal.png',
                  'paypal',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildPaymentOption(
                  'Card',
                  'assets/images/card.png',
                  'card',
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildPaymentOption(
                  'Instapay',
                  'assets/images/instapay.png',
                  'instapay',
                ),
              ),
            ],
          ),
        ),
        
        // Card details form when Card is selected
        if (_selectedPaymentMethod == 'card') ...[
          SizedBox(height: 16.h),
          _buildCardDetailsForm(),
        ],
      ],
    );
  }

  Widget _buildCardDetailsForm() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1E000000),
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Details',
            style: TextStyle(
              color: const Color(0xFF1E1E1E),
              fontSize: 16.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          
          // Card Number field
          _buildCardInputField(
            hint: 'Card Number',
            icon: 'assets/images/person_card.svg',
          ),
          SizedBox(height: 16.h),
          
          // Expiration and CVV row
          Row(
            children: [
              Expanded(
                child: _buildCardInputField(
                  hint: 'Expiration',
                  icon: 'assets/images/person_card.svg',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildCardInputField(
                  hint: 'CVV',
                  icon: 'assets/images/person_card.svg',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardInputField({
    required String hint,
    required String icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF848484),
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(12.w),
            child: SvgPicture.asset(
              icon,
              width: 20.w,
              height: 20.h,
              colorFilter: const ColorFilter.mode(
                Color(0xFF28A228),
                BlendMode.srcIn,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        style: TextStyle(
          color: const Color(0xFF1E1E1E),
          fontSize: 14.sp,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String label, String iconPath, String value) {
    bool isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF28A228) 
                : const Color(0x26848484),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Stack(
          children: [
            // Radio button in top right corner
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected 
                      ? const Color(0xFF28A228) 
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected 
                        ? const Color(0xFF28A228) 
                        : const Color(0xFF848484),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  iconPath,
                  width: 32.w,
                  height: 32.h,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.payment,
                        size: 20.sp,
                        color: const Color(0xFF848484),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12.h),
                Text(
                  label,
                  style: TextStyle(
                    color: const Color(0xFF1E1E1E),
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 4,
            offset: Offset(4, 0),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _selectedPaymentMethod != null
            ? () {
                context.push(AppRouter.subscribtionDone);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(0.00, 0.50),
              end: Alignment(1.00, 0.50),
              colors: [Color(0xFF28A228), Color(0xD85CD65C)],
            ),
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0x2628A228),
                blurRadius: 4,
                offset: const Offset(4, 0),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Pay',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
                             Text(
                 ' ${_appliedCoupon?.formattedFinalPrice ?? _planData['price'] ?? '30\$'}',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 16.sp,
                   fontFamily: 'Poppins',
                   fontWeight: FontWeight.w600,
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}