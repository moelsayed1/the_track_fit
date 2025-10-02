import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import '../../data/services/coupon_service.dart';
import '../../data/services/subscription_service.dart';
import '../../data/services/user_data_service.dart';
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

  // Payment proof
  String? paymentProofPath;

  // Form fields for subscription
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Loading state
  bool _isSubmitting = false;

  // Services
  final CouponService _couponService = CouponService.instance;
  final SubscriptionService _subscriptionService = SubscriptionService.instance;
  final UserDataService _userDataService = UserDataService.instance;

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

    // Populate form fields with user data
    _populateUserData();
  }

  @override
  void dispose() {
    _couponController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _populateUserData() {
    try {
      final userData = _userDataService.getSubscriptionUserData(context);

      // Populate form fields with user data
      if (userData['name']?.isNotEmpty == true) {
        _nameController.text = userData['name'];
      }
      if (userData['email']?.isNotEmpty == true) {
        _emailController.text = userData['email'];
      }
      if (userData['phone']?.isNotEmpty == true) {
        _phoneController.text = userData['phone'];
      }

      log('CheckoutPlanScreen: Populated form fields with user data');
    } catch (e) {
      log('CheckoutPlanScreen: Error populating user data: $e');
    }
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
        child: Directionality(
          textDirection: Localizations.localeOf(context).languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
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

                      // User information section
                      _buildUserInfoSection(),
                      SizedBox(height: 24.h),

                      // Coupon section
                      _buildCouponSection(),
                      SizedBox(height: 24.h),

                      // Price breakdown
                      _buildPriceBreakdown(),
                      SizedBox(height: 24.h),

                      // Payment methods
                      _buildPaymentMethods(),
                      // SizedBox(height: 100.h), // Space for bottom button
                    ],
                  ),
                ),
              ),

              // Pay button at bottom
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: const BoxDecoration(color: Color(0x26848484)),
      child: Builder(
        builder: (context) {
          if (isArabic) {
            // Arabic: pay , button , arrow
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title (Pay)
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      SizedBox(width: 8.w),
                      Text(
                        'الدفع',
                        style: TextStyle(
                          color: const Color(0xFF1E1E1E),
                          fontSize: 18.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // Change Plan button
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF28A228),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Text(
                          'تغيير الباقة',
                          style: TextStyle(
                            color: const Color(0xFF28A228),
                            fontSize: 12.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),

                    // Arrow
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Transform.rotate(
                          angle: isArabic
                              ? 0
                              : 3.14159, // Rotate 180 degrees for Arabic
                          child: SvgPicture.asset(
                            'assets/logos/arrow_left.svg',
                            width: 24.w,
                            height: 24.h,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            // English: arrow , button , pay
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Transform.rotate(
                          angle: 0,
                          child: SvgPicture.asset(
                            'assets/logos/arrow_left.svg',
                            width: 24.w,
                            height: 24.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 6.h,
                        ),
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

                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    children: [
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
                ),

                // Title (Pay)
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildYourPlanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'باقتك هي'
              : 'Your Plan is',
          style: TextStyle(
            color: const Color(0xFF848484),
            fontSize: 12.sp,
            fontFamily: Localizations.localeOf(context).languageCode == 'ar'
                ? 'Cairo'
                : 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 16.h),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF28A228), width: 1),
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
                          _planData['title'] ??
                              (Localizations.localeOf(context).languageCode ==
                                      'ar'
                                  ? 'باقة برو'
                                  : 'Pro Plan'),
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: 18.sp,
                            fontFamily:
                                Localizations.localeOf(context).languageCode ==
                                    'ar'
                                ? 'Cairo'
                                : 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
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
                                _planData['isMostPopular'] == true
                                    ? 'Most Popular'
                                    : '',
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
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? '/شهر'
                              : '/month',
                          style: TextStyle(
                            color: const Color(0xBF1E1E1E),
                            fontSize: 10.sp,
                            fontFamily:
                                Localizations.localeOf(context).languageCode ==
                                    'ar'
                                ? 'Cairo'
                                : 'Poppins',
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
                child: Icon(Icons.check, color: Colors.white, size: 14.sp),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'معلوماتك'
              : 'Your Information',
          style: TextStyle(
            color: const Color(0xFF1E1E1E),
            fontSize: 16.sp,
            fontFamily: Localizations.localeOf(context).languageCode == 'ar'
                ? 'Cairo'
                : 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),

        // Name Field
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/person_card.svg',
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'الاسم الكامل'
                        : 'Full Name',
                    hintStyle: TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 14.sp,
                      fontFamily:
                          Localizations.localeOf(context).languageCode == 'ar'
                          ? 'Cairo'
                          : 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 14.sp,
                    fontFamily:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'Cairo'
                        : 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Email Field
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/email_icon.svg',
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'عنوان البريد الإلكتروني'
                        : 'Email Address',
                    hintStyle: TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 14.sp,
                      fontFamily:
                          Localizations.localeOf(context).languageCode == 'ar'
                          ? 'Cairo'
                          : 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 14.sp,
                    fontFamily:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'Cairo'
                        : 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Phone Field
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: Color(0xFFE0E0E0)),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/phone_icon.svg',
                width: 20.w,
                height: 20.h,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'رقم الهاتف'
                        : 'Phone Number',
                    hintStyle: TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 14.sp,
                      fontFamily:
                          Localizations.localeOf(context).languageCode == 'ar'
                          ? 'Cairo'
                          : 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 14.sp,
                    fontFamily:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'Cairo'
                        : 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
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
                Localizations.localeOf(context).languageCode == 'ar'
                    ? 'هل لديك كود خصم؟'
                    : 'Got a Coupon code ?',
                style: TextStyle(
                  color: const Color(0xFF1E1E1E),
                  fontSize: 16.sp,
                  fontFamily:
                      Localizations.localeOf(context).languageCode == 'ar'
                      ? 'Cairo'
                      : 'Poppins',
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
                  _showCouponInput
                      ? (Localizations.localeOf(context).languageCode == 'ar'
                            ? 'إلغاء'
                            : 'Cancel')
                      : (Localizations.localeOf(context).languageCode == 'ar'
                            ? 'تطبيق الكوبون'
                            : 'Apply Coupon'),
                  style: TextStyle(
                    color: const Color(0xFF28A228),
                    fontSize: 12.sp,
                    fontFamily:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'Cairo'
                        : 'Poppins',
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
                border: Border.all(color: const Color(0xFF28A228), width: 1),
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
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'تم تطبيق الكوبون بنجاح!'
                              : 'Coupon Applied Successfully!',
                          style: TextStyle(
                            color: const Color(0xFF28A228),
                            fontSize: 14.sp,
                            fontFamily:
                                Localizations.localeOf(context).languageCode ==
                                    'ar'
                                ? 'Cairo'
                                : 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'الخصم: ${_appliedCoupon!.formattedDiscountAmount}'
                              : 'Discount: ${_appliedCoupon!.formattedDiscountAmount}',
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: 12.sp,
                            fontFamily:
                                Localizations.localeOf(context).languageCode ==
                                    'ar'
                                ? 'Cairo'
                                : 'Poppins',
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
                border: Border.all(color: const Color(0xFFEA4335), width: 1),
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
                border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
              ),
              child: TextField(
                controller: _couponController,
                decoration: InputDecoration(
                  hintText: Localizations.localeOf(context).languageCode == 'ar'
                      ? 'كود الخصم'
                      : 'coupon',
                  hintStyle: TextStyle(
                    color: const Color(0xFF848484),
                    fontSize: 14.sp,
                    fontFamily:
                        Localizations.localeOf(context).languageCode == 'ar'
                        ? 'Cairo'
                        : 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(
                  color: const Color(0xFF1E1E1E),
                  fontSize: 14.sp,
                  fontFamily:
                      Localizations.localeOf(context).languageCode == 'ar'
                      ? 'Cairo'
                      : 'Poppins',
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? 'تطبيق'
                                : 'Apply',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily:
                                  Localizations.localeOf(
                                        context,
                                      ).languageCode ==
                                      'ar'
                                  ? 'Cairo'
                                  : 'Poppins',
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
        border: Border.all(color: const Color(0x26848484), width: 1),
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
          _buildPriceRow(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'سعر الباقة'
                : 'Plan Price',
            originalPrice,
          ),
          _buildDivider(),
          if (_appliedCoupon != null) ...[
            _buildPriceRow(
              Localizations.localeOf(context).languageCode == 'ar'
                  ? 'خصم الكوبون'
                  : 'Coupon Discount',
              '-$discountAmount',
              isDiscount: true,
            ),
            _buildDivider(),
          ],
          _buildPriceRow(
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'المجموع'
                : 'Total',
            finalPrice,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(
    String label,
    String amount, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal
                  ? const Color(0xFF1E1E1E)
                  : const Color(0xFF1E1E1E),
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
    return Container(height: 1, color: const Color(0x26848484));
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Localizations.localeOf(context).languageCode == 'ar'
              ? 'اختر طريقة الدفع'
              : 'Choose Payment Method',
          style: TextStyle(
            color: const Color(0xFF1E1E1E),
            fontSize: 14.sp,
            fontFamily: Localizations.localeOf(context).languageCode == 'ar'
                ? 'Cairo'
                : 'Poppins',
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
                  'Vodafon Cash',
                  'assets/images/vodafon_cash.png',
                  'vodafone_cash',
                ),
              ),
              SizedBox(width: 8.w),
              // Expanded(
              //   child: _buildPaymentOption(
              //     'Card',
              //     'assets/images/card.png',
              //     'card',
              //   ),
              // ),
              // SizedBox(width: 8.w),
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

        // Payment proof upload when Vodafone Cash or Instapay is selected
        if (_selectedPaymentMethod == 'vodafone_cash' ||
            _selectedPaymentMethod == 'instapay') ...[
          SizedBox(height: 16.h),
          _buildPaymentProofSection(),
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

  Widget _buildCardInputField({required String hint, required String icon}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
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
                  width: 45.w,
                  height: 45.h,
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

  Widget _buildPaymentProofSection() {
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
            Localizations.localeOf(context).languageCode == 'ar'
                ? 'إثبات الدفع'
                : 'Payment Proof',
            style: TextStyle(
              color: const Color(0xFF1E1E1E),
              fontSize: 16.sp,
              fontFamily: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'Cairo'
                  : 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _selectedPaymentMethod == 'vodafone_cash'
                ? (Localizations.localeOf(context).languageCode == 'ar'
                      ? 'يرجى تحميل لقطة شاشة لدفعك عبر فودافون كاش'
                      : 'Please upload a screenshot of your Vodafone Cash payment')
                : (Localizations.localeOf(context).languageCode == 'ar'
                      ? 'يرجى تحميل لقطة شاشة لدفعك عبر إنستاباي'
                      : 'Please upload a screenshot of your Instapay payment'),
            style: TextStyle(
              color: const Color(0xFF848484),
              fontSize: 12.sp,
              fontFamily: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'Cairo'
                  : 'Poppins',
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16.h),

          GestureDetector(
            onTap: _pickPaymentProofImage,
            child: Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: paymentProofPath != null
                    ? Color(0xFFF0F8F0)
                    : Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: paymentProofPath != null
                      ? Color(0xFF28A228)
                      : Color(0xFFE0E0E0),
                  width: 2,
                ),
              ),
              child: paymentProofPath != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.file(
                            File(paymentProofPath!),
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                paymentProofPath = null;
                              });
                            },
                            child: Container(
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: Color(0xFF848484),
                          size: 32.sp,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          Localizations.localeOf(context).languageCode == 'ar'
                              ? 'اضغط لتحميل إثبات الدفع'
                              : 'Tap to upload payment proof',
                          style: TextStyle(
                            color: Color(0xFF848484),
                            fontSize: 14.sp,
                            fontFamily:
                                Localizations.localeOf(context).languageCode ==
                                    'ar'
                                ? 'Cairo'
                                : 'Poppins',
                            fontWeight: FontWeight.w400,
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

  Future<void> _pickPaymentProofImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        // Copy the image to a permanent location to avoid file path issues
        final Directory tempDir = Directory.systemTemp;
        final String fileName =
            'payment_proof_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String permanentPath = '${tempDir.path}/$fileName';

        // Copy the file to permanent location
        final File permanentFile = await File(image.path).copy(permanentPath);

        setState(() {
          paymentProofPath = permanentFile.path;
        });

        log('Payment proof saved to permanent path: $paymentProofPath');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(bottom: 100.h, left: 16.w, right: 16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  Widget _buildPayButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      // decoration: const BoxDecoration(
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Color(0x1E000000),
      //       blurRadius: 4,
      //       offset: Offset(4, 0),
      //     ),
      //   ],
      // ),
      child: ElevatedButton(
        onPressed: _selectedPaymentMethod != null && !_isSubmitting
            ? () async {
                await _submitSubscription();
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
          child: _isSubmitting
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'جاري المعالجة...'
                          : 'Processing...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily:
                            Localizations.localeOf(context).languageCode == 'ar'
                            ? 'Cairo'
                            : 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? 'ادفع'
                          : 'Pay',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily:
                            Localizations.localeOf(context).languageCode == 'ar'
                            ? 'Cairo'
                            : 'Poppins',
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

  Future<void> _submitSubscription() async {
    // Validate form fields
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your name');
      return;
    }
    if (_emailController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your email');
      return;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showErrorSnackBar('Please enter your phone number');
      return;
    }
    if (_selectedPaymentMethod == null) {
      _showErrorSnackBar('Please select a payment method');
      return;
    }
    if ((_selectedPaymentMethod == 'vodafone_cash' ||
            _selectedPaymentMethod == 'instapay') &&
        paymentProofPath == null) {
      _showErrorSnackBar('Please upload payment proof to continue');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Calculate total price
      double total = 0.0;
      if (_appliedCoupon != null) {
        // Use final price from coupon
        total = _appliedCoupon!.finalPrice.toDouble();
      } else {
        // Parse price from plan data
        String priceStr = _planData['price'] ?? '30\$';
        priceStr = priceStr.replaceAll('\$', '').replaceAll('EGP', '').trim();
        total = double.tryParse(priceStr) ?? 30.0;
      }

      // Get package ID
      int packageId = _planData['id'] ?? 1;

      // Get complete user data including all profile and answers
      final completeUserData = _userDataService.getCompleteUserData(context);

      // Submit subscription
      final result = await _subscriptionService.submitSubscription(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        packageId: packageId,
        paymentType: _selectedPaymentMethod!,
        total: total,
        paymentProofPath: paymentProofPath,
        couponCode: _couponController.text.trim().isNotEmpty
            ? _couponController.text.trim()
            : null,
        userData: completeUserData,
      );

      if (result['success']) {
        // Show success message with subscription details
        final subscriptionData = result['data'];
        final message =
            result['message'] ?? 'Subscription created successfully';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF28A228),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 100.h, left: 16.w, right: 16.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );

        // Log subscription details
        if (subscriptionData != null) {
          log('Subscription created:');
          log('ID: ${subscriptionData['id']}');
          log('Status: ${subscriptionData['status']}');
          log('Amount: ${subscriptionData['amount']}');
          log('Payment Type: ${subscriptionData['payment_type']}');
          log('Starts At: ${subscriptionData['starts_at']}');
          log('Ends At: ${subscriptionData['ends_at']}');
        }

        // Navigate to success screen
        if (mounted) {
          context.push(AppRouter.subscribtionDone);
        }
      } else {
        // Show error message
        _showErrorSnackBar(
          result['message'] ?? 'Failed to submit subscription',
        );
      }
    } catch (e) {
      log('Error submitting subscription: $e');
      _showErrorSnackBar('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}
