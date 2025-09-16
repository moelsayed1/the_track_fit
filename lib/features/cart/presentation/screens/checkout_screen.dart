import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/widgets/shimmer_loading.dart';
import 'package:the_track_fit/features/cart/domain/models/cart_item.dart';
import 'package:the_track_fit/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:the_track_fit/features/cart/presentation/cubit/checkout_cubit.dart';
import 'package:the_track_fit/features/cart/domain/models/shipping_government.dart';
import 'package:the_track_fit/features/cart/domain/models/checkout_request.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:the_track_fit/core/widgets/app_scaffold.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();

}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool isCartActive = true;
  bool isHeartActive = false;
  bool showCouponInput = false;
  String? _selectedPaymentMethod;
  final TextEditingController _couponController = TextEditingController();
  
  // Info section controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  // Address section
  final TextEditingController _addressController = TextEditingController();
  String? selectedGovernorate;
  bool isGovernorateDropdownOpen = false;
  List<ShippingGovernment> shippingGovernments = [];
  double shippingCost = 0.0;
  
  // Phone country code
  String selectedCountryCode = '+20'; // Default to Egypt
  bool isCountryCodeDropdownOpen = false;
  
  // Payment proof
  String? paymentProofPath;
  
  // Country codes list
  final List<Map<String, String>> countryCodes = [
    {'code': '+20', 'country': 'Egypt', 'flag': '🇪🇬'},
    {'code': '+966', 'country': 'Saudi Arabia', 'flag': '🇸🇦'},
    {'code': '+971', 'country': 'UAE', 'flag': '🇦🇪'},
    {'code': '+965', 'country': 'Kuwait', 'flag': '🇰🇼'},
    {'code': '+974', 'country': 'Qatar', 'flag': '🇶🇦'},
    {'code': '+973', 'country': 'Bahrain', 'flag': '🇧🇭'},
    {'code': '+968', 'country': 'Oman', 'flag': '🇴🇲'},
    {'code': '+962', 'country': 'Jordan', 'flag': '🇯🇴'},
    {'code': '+961', 'country': 'Lebanon', 'flag': '🇱🇧'},
    {'code': '+963', 'country': 'Syria', 'flag': '🇸🇾'},
    {'code': '+964', 'country': 'Iraq', 'flag': '🇮🇶'},
    {'code': '+212', 'country': 'Morocco', 'flag': '🇲🇦'},
    {'code': '+213', 'country': 'Algeria', 'flag': '🇩🇿'},
    {'code': '+216', 'country': 'Tunisia', 'flag': '🇹🇳'},
    {'code': '+218', 'country': 'Libya', 'flag': '🇱🇾'},
    {'code': '+249', 'country': 'Sudan', 'flag': '🇸🇩'},
    {'code': '+1', 'country': 'USA/Canada', 'flag': '🇺🇸'},
    {'code': '+44', 'country': 'UK', 'flag': '🇬🇧'},
    {'code': '+33', 'country': 'France', 'flag': '🇫🇷'},
    {'code': '+49', 'country': 'Germany', 'flag': '🇩🇪'},
    {'code': '+39', 'country': 'Italy', 'flag': '🇮🇹'},
    {'code': '+34', 'country': 'Spain', 'flag': '🇪🇸'},
  ];
  
  // Egyptian Governorates List
  final List<String> egyptianGovernorates = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Dakahlia',
    'Red Sea',
    'Beheira',
    'Fayyum',
    'Gharbia',
    'Ismailia',
    'Menofia',
    'Minya',
    'Qalyubia',
    'New Valley',
    'North Sinai',
    'Port Said',
    'Qena',
    'South Sinai',
    'Sohag',
    'Suez',
    'Aswan',
    'Asyut',
    'Beni Suef',
    'Damietta',
    'Kafr el-Sheikh',
    'Luxor',
    'Matrouh',
    'Monufia',
    'Sharqia',
    'Sohag',
  ];
  
  @override
  void initState() {
    super.initState();
    // Load cart items when checkout screen initializes
    context.read<CartCubit>().loadCartItems();
    // Load shipping governments
    context.read<CheckoutCubit>().loadShippingGovernments();
  }

  @override
  void dispose() {
    _couponController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        List<CartItem> cartItems = [];
        
        if (cartState is CartLoaded) {
          cartItems = cartState.cartItems;
        }
        
        return BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, checkoutState) {
            // Update shipping governments when loaded
            if (checkoutState is ShippingGovernmentsLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  shippingGovernments = checkoutState.governments;
                });
              });
        }
        
        return AppScaffold(
          backgroundColor: const Color(0xFFF6FFF6),
          body: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: const Color(0x26848484),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side - Back button and title
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.pop(),
                            icon: SvgPicture.asset(
                              'assets/logos/arrow_left.svg',
                              width: 24.w,
                              height: 24.h,
                            ),
                          ),
                          Text(
                            'Checkout',
                            style: TextStyle(
                              color: Color(0xFF1E1E1E),
                              fontSize: 18.sp,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              height: 0.89,
                            ),
                          ),
                        ],
                      ),
                      // Right side - Cart and heart icons
                      Row(
                        children: [
                          // Cart Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isCartActive = true;
                                isHeartActive = false;
                              });
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: ShapeDecoration(
                                color: isCartActive
                                    ? const Color(0xFF28A228)
                                    : const Color(0x3328A228),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFF28A228),
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/logos/cart_icon.svg',
                                  width: 20.w,
                                  height: 20.h,
                                  colorFilter: ColorFilter.mode(
                                    isCartActive ? Colors.white : const Color(0xFF28A228),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Heart Button
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isHeartActive = true;
                                isCartActive = false;
                              });
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: ShapeDecoration(
                                color: isHeartActive
                                    ? const Color(0xFF28A228)
                                    : const Color(0x3328A228),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    color: Color(0xFF28A228),
                                  ),
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  isHeartActive ? Icons.favorite : Icons.favorite_border,
                                  color: isHeartActive ? Colors.white : const Color(0xFF28A228),
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Content Section
                Expanded(
                  child: _buildContent(cartState, cartItems, checkoutState),
                ),
              ],
            ),
          );
        }
        );
      },
    );
  }

  Widget _buildContent(CartState state, List<CartItem> cartItems, CheckoutState checkoutState) {
    if (state is CartLoading) {
      return _buildCheckoutShimmerLoading();
    } else if (state is CartError) {
      // Show simple empty cart state instead of error
      return _buildSimpleEmptyState();
    } else {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Product Cards - show all items if cart has items
            if (cartItems.isNotEmpty) ...[
              // Cart Items Header
              Row(
                children: [
                  Text(
                    'Cart Items (${cartItems.length})',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              
              // Display all cart items
              ...cartItems.asMap().entries.map((entry) {
                int index = entry.key;
                CartItem cartItem = entry.value;
                return Column(
                  children: [
                    _buildProductCard(cartItem),
                    if (index < cartItems.length - 1) SizedBox(height: 16.h),
                  ],
                );
              }).toList().cast<Widget>(),
              SizedBox(height: 24.h),
            ] else ...[
              // Empty cart state
              _buildEmptyCartState(),
            ],
            
            SizedBox(height: 24.h),
            
            // Info Section
            _buildInfoSection(),
            
            SizedBox(height: 24.h),
            
            // Address Section
            _buildAddressSection(),
            
            SizedBox(height: 24.h),
            
            // Coupon Section
           // _buildCouponSection(),
            
            // SizedBox(height: 24.h),

            _buildPaymentMethods(),

            SizedBox(height: 24.h),
            
            // Payment Summary
            _buildPaymentSummary(cartItems),
            
            SizedBox(height: 24.h),
            
            // Confirm Order Button
            _buildConfirmOrderButton(),
          ],
        ),
      );
    }
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
            'Payment Proof',
            style: TextStyle(
              color: const Color(0xFF1E1E1E),
              fontSize: 16.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please upload a screenshot of your Instapay payment',
            style: TextStyle(
              color: const Color(0xFF848484),
              fontSize: 12.sp,
              fontFamily: 'Poppins',
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
                color: paymentProofPath != null ? Color(0xFFF0F8F0) : Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: paymentProofPath != null ? Color(0xFF28A228) : Color(0xFFE0E0E0),
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
                          'Tap to upload payment proof',
                          style: TextStyle(
                            color: Color(0xFF848484),
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
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
        
        // Payment proof upload when Instapay is selected
        if (_selectedPaymentMethod == 'instapay') ...[
          SizedBox(height: 16.h),
          _buildPaymentProofSection(),
        ],
      ],
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



  Widget _buildProductCard(CartItem cartItem) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Stack(
        children: [
          // Main content
          Row(
            children: [
              // Product Image
              Container(
                width: 54.w,
                height: 64.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Color(0xFFF0F0F0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    cartItem.product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Color(0xFFF0F0F0),
                        child: Icon(
                          Icons.image_not_supported,
                          color: Color(0xFF848484),
                          size: 24.sp,
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Color(0xFFF0F0F0),
                        child: ShimmerCard(
                          height: 64.h,
                          width: 54.w,
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name, // Use actual product name
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '*${cartItem.quantity}', // Show actual quantity
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${cartItem.product.price} EGP', // Show actual price with EGP
                      style: TextStyle(
                        color: Color(0xFF28A228),
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Remove Button - Positioned at top right
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              onPressed: () {
                // Handle remove product using CartCubit
                context.read<CartCubit>().removeFromCart(cartItem.id);
              },
              icon: Container(
                width: 20.w,
                height: 20.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Icon(
                  Icons.close,
                  size: 14.sp,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Info',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 16.sp,
            fontFamily: 'Poppins',
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
                    hintText: 'Name',
                    hintStyle: TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
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
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 12.h),
        
        // Phone Field with Country Code
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
              
              // Country Code Dropdown
              GestureDetector(
                onTap: () {
                  setState(() {
                    isCountryCodeDropdownOpen = !isCountryCodeDropdownOpen;
                    isGovernorateDropdownOpen = false; // Close other dropdown
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedCountryCode,
                        style: TextStyle(
                          color: Color(0xFF1E1E1E),
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        isCountryCodeDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        color: Color(0xFF848484),
                        size: 16.sp,
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(width: 12.w),
              
              // Phone Number Input
              Expanded(
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(
                      color: Color(0xFF848484),
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  onChanged: (value) {
                    // Optional: Add phone number formatting here
                    // You can add formatting logic like removing non-digits
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Country Code Dropdown List
        if (isCountryCodeDropdownOpen) ...[
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 200.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Color(0xFFE0E0E0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1E000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: countryCodes.length,
              itemBuilder: (context, index) {
                final country = countryCodes[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCountryCode = country['code']!;
                      isCountryCodeDropdownOpen = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: selectedCountryCode == country['code'] ? Color(0xFFF0F8F0) : Colors.transparent,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      children: [
                        Text(
                          country['flag']!,
                          style: TextStyle(fontSize: 20.sp),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                country['code']!,
                                style: TextStyle(
                                  color: selectedCountryCode == country['code'] ? Color(0xFF28A228) : Color(0xFF1E1E1E),
                                  fontSize: 14.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                country['country']!,
                                style: TextStyle(
                                  color: selectedCountryCode == country['code'] ? Color(0xFF28A228) : Color(0xFF848484),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selectedCountryCode == country['code'])
                          Icon(
                            Icons.check,
                            color: Color(0xFF28A228),
                            size: 16.sp,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        
        // Governorate Field
        GestureDetector(
          onTap: () {
            setState(() {
              isGovernorateDropdownOpen = !isGovernorateDropdownOpen;
              isCountryCodeDropdownOpen = false; // Close country code dropdown
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF28A228),
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    selectedGovernorate ?? 'Governorate',
                    style: TextStyle(
                      color: selectedGovernorate != null ? Color(0xFF1E1E1E) : Color(0xFF848484),
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Icon(
                  isGovernorateDropdownOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: Color(0xFF848484),
                  size: 20.sp,
                ),
              ],
            ),
          ),
        ),
        
        // Governorate Dropdown List
        if (isGovernorateDropdownOpen) ...[
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            constraints: BoxConstraints(maxHeight: 200.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: Color(0xFFE0E0E0)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1E000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: shippingGovernments.isNotEmpty ? shippingGovernments.length : egyptianGovernorates.length,
              itemBuilder: (context, index) {
                final governorate = shippingGovernments.isNotEmpty 
                    ? shippingGovernments[index].nameEn 
                    : egyptianGovernorates[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGovernorate = governorate;
                      isGovernorateDropdownOpen = false;
                      // Update shipping cost when governorate is selected
                      if (shippingGovernments.isNotEmpty) {
                        shippingCost = shippingGovernments[index].shippingCost;
                      } else {
                        // Default shipping cost for non-API governorates
                        shippingCost = 50.0;
                      }
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: selectedGovernorate == governorate ? Color(0xFFF0F8F0) : Colors.transparent,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      children: [
                        if (selectedGovernorate == governorate)
                          Icon(
                            Icons.check,
                            color: Color(0xFF28A228),
                            size: 16.sp,
                          ),
                        if (selectedGovernorate == governorate) SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            governorate,
                            style: TextStyle(
                              color: selectedGovernorate == governorate ? Color(0xFF28A228) : Color(0xFF1E1E1E),
                              fontSize: 14.sp,
                              fontFamily: 'Poppins',
                              fontWeight: selectedGovernorate == governorate ? FontWeight.w500 : FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
        
        SizedBox(height: 12.h),
        
        // Address Field
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
              Icon(
                Icons.location_on_outlined,
                color: Color(0xFF28A228),
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Address',
                    hintStyle: TextStyle(
                    color: Color(0xFF848484),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                  style: TextStyle(
                    color: Color(0xFF1E1E1E),
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
    );
  }


  Widget _buildPaymentSummary(List<CartItem> cartItems) {
    // Don't show payment summary if cart is empty
    if (cartItems.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Calculate totals
    double orderTotal = cartItems.fold(0.0, (sum, cartItem) => sum + cartItem.totalPrice);
    // Add shipping cost to total
    double total = orderTotal + shippingCost;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Summary',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        
        // Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order Total',
              style: TextStyle(
                color: Color(0xFF848484),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '${orderTotal.toStringAsFixed(2)} EGP',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        
        // Items Discount
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       'Items Discount',
        //       style: TextStyle(
        //         color: Color(0xFF848484),
        //         fontSize: 14.sp,
        //         fontFamily: 'Poppins',
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //     Text(
        //       '- ${discount.toStringAsFixed(2)}',
        //       style: TextStyle(
        //         color: Color(0xFF1E1E1E),
        //         fontSize: 14.sp,
        //         fontFamily: 'Poppins',
        //         fontWeight: FontWeight.w400,
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(height: 16.h),
        
        // Shipping
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Shipping',
              style: TextStyle(
                color: Color(0xFF848484),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              shippingCost > 0 ? '${shippingCost.toStringAsFixed(2)} EGP' : 'Free',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        SizedBox(height: 16.h),
        
        // Divider
        Container(
          width: double.infinity,
          height: 1.h,
          color: const Color(0x26848484),
        ),
        
        SizedBox(height: 16.h),
        
        // Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${total.toStringAsFixed(2)} EGP',
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 18.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfirmOrderButton() {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, checkoutState) {
        return GestureDetector(
          onTap: () async {
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
                    if (selectedCountryCode.isEmpty) {
                      _showErrorSnackBar('Please select a country code');
                      return;
                    }
                    if (_addressController.text.trim().isEmpty) {
                      _showErrorSnackBar('Please enter your address');
                      return;
                    }
                    if (selectedGovernorate == null) {
                      _showErrorSnackBar('Please select a governorate');
                      return;
                    }
                    if (_selectedPaymentMethod == null) {
                      _showErrorSnackBar('Please select a payment method');
                      return;
                    }
                    if (_selectedPaymentMethod == 'instapay' && paymentProofPath == null) {
                      _showErrorSnackBar('Please upload payment proof for Instapay');
                      return;
                    }

                    if (cartState is! CartLoaded || cartState.cartItems.isEmpty) {
                      _showErrorSnackBar('No items in cart to checkout');
              return;
            }

            try {
                      // Calculate totals
                      double orderTotal = cartState.cartItems.fold(0.0, (sum, cartItem) => sum + cartItem.totalPrice);
                      double total = orderTotal + shippingCost;

                      // Get government ID
                      int governmentId = 1; // Default ID
                      if (shippingGovernments.isNotEmpty) {
                        try {
                          final government = shippingGovernments.firstWhere(
                            (gov) => gov.nameEn.toLowerCase() == selectedGovernorate!.toLowerCase(),
                          );
                          governmentId = government.id;
                        } catch (e) {
                          // Use default ID if not found
                        }
                      }

                      // Create checkout request
                      final checkoutRequest = CheckoutRequest(
                        userId: 14, // You might want to get this from user session
                        paymentType: _selectedPaymentMethod!,
                        clientName: _nameController.text.trim(),
                        fullPhone: '$selectedCountryCode${_phoneController.text.trim()}',
                        clientEmail: _emailController.text.trim(),
                        clientAddress: _addressController.text.trim(),
                        subtotal: orderTotal,
                        shippingGovernmentId: governmentId,
                        shippingCost: shippingCost,
                        total: total,
                        cartItems: cartState.cartItems,
                      );

                      // Submit order
                      await context.read<CheckoutCubit>().submitOrder(
                        checkoutRequest, 
                        paymentProofPath: paymentProofPath,
                      );

              if (mounted) {
                        // Clear cart after successful order
                        await context.read<CartCubit>().clearCart();
                        
                        // Show success dialog
                        _showSuccessDialog();
                      }
                    } catch (e) {
                      if (mounted) {
                        _showErrorSnackBar('Error: ${e.toString()}');
                      }
                    }
                  },
                  child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2628A228),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Text(
              'Confirm Order',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.50,
                letterSpacing: 0.50,
              ),
            ),
          ),
        );
          },
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
        content: Text(message),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      bottom: 100.h,
                      left: 16.w,
                      right: 16.w,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
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
        setState(() {
          paymentProofPath = image.path;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  Widget _buildEmptyCartState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple Cart Icon
            Icon(
              Icons.shopping_cart_outlined,
              size: 80.sp,
              color: const Color(0xFF28A228),
            ),
            
            SizedBox(height: 24.h),
            
            // Title
            Text(
              'No products in cart',
              style: TextStyle(
                color: const Color(0xFF1E1E1E),
                fontSize: 18.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            
            SizedBox(height: 8.h),
            
            // Subtitle
            Text(
              'Add some products to continue shopping',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF848484),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Go to Store Button
            GestureDetector(
              onTap: () => context.push(AppRouter.store),
          child: Container(
            width: double.infinity,
                height: 50.h,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Center(
                  child: Text(
                    'Go to Store',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Beautiful Cart Icon with Background
            Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                color: const Color(0xFF28A228).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 50.sp,
                color: const Color(0xFF28A228),
              ),
            ),
            
            SizedBox(height: 32.h),
            
            // Title
            Text(
              'Your cart is empty',
              style: TextStyle(
                color: const Color(0xFF1E1E1E),
                fontSize: 20.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
            
            SizedBox(height: 12.h),
            
            // Subtitle
            Text(
              'Start shopping to add items to your cart',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF848484),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
            
            SizedBox(height: 40.h),
            
            // Go to Store Button
            GestureDetector(
              onTap: () => context.push(AppRouter.store),
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2628A228),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.store,
                        color: Colors.white,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Start Shopping',
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
            ),
          ],
            ),
          ),
        );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 370.w,
            height: 340.h,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Success GIF Animation
                SizedBox(
                  width: 150.w,
                  height: 150.h,
                  child: Image.asset(
                    'assets/images/done_gif.gif',
                    fit: BoxFit.contain,
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Congratulations Title
                Text(
                  'Congratulations!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF28A228),
                    fontFamily: 'Poppins',
                  ),
                ),
                
                SizedBox(height: 8.h),
                
                // Subtitle
                Text(
                  'Your Order has been confirmed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF848484),
                    fontFamily: 'Poppins',
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Go to Home Page Button
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(); // Close dialog
                    context.go(AppRouter.homeFeature); // Navigate to home
                  },
                  child: Container(
                    width: 200.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                    child: Center(
                      child: Text(
                        'Go to Home Page',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildCheckoutShimmerLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Shimmer for product card
          ShimmerCard(
            height: 100.h,
            padding: EdgeInsets.all(16.w),
          ),
          
          SizedBox(height: 24.h),
          
          // Shimmer for Info section
          ShimmerCard(
            height: 200.h,
            padding: EdgeInsets.all(16.w),
          ),
          
          SizedBox(height: 24.h),
          
          // Shimmer for Address section
          ShimmerCard(
            height: 150.h,
            padding: EdgeInsets.all(16.w),
          ),
          
          SizedBox(height: 24.h),
          
          // Shimmer for Payment methods
          ShimmerCard(
            height: 120.h,
            padding: EdgeInsets.all(16.w),
          ),
          
          SizedBox(height: 24.h),
          
          // Shimmer for Payment summary
          ShimmerCard(
            height: 200.h,
            padding: EdgeInsets.all(16.w),
          ),
          
          SizedBox(height: 24.h),
          
          // Shimmer for Confirm button
          ShimmerCard(
            height: 50.h,
            padding: EdgeInsets.all(16.w),
          ),
        ],
      ),
    );
  }
}
