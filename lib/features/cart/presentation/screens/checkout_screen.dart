import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/features/auth/new_password/presentation/widgets/reset_password_done.dart';
import 'package:the_track_fit/features/store/domain/models/product.dart';
import 'package:the_track_fit/features/cart/domain/models/cart_item.dart';

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
  String? selectedGovernorate;
  bool isGovernorateDropdownOpen = false;
  
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
  
  // Sample cart items for checkout
  List<CartItem> cartItems = [
    CartItem(
      product: Product(
        id: '1',
        name: 'Maxin Protein Powder',
        price: 20.0,
        imageUrl: 'assets/images/product_image.png',
      ),
      quantity: 1,
    ),
  ];

  @override
  void dispose() {
    _couponController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Product Card
                    _buildProductCard(cartItems[0]),
                    
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
                    _buildPaymentSummary(),
                    
                    SizedBox(height: 24.h),
                    
                    // Confirm Order Button
                    _buildConfirmOrderButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
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
                  child: Image.asset(
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
                      'Product name',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '*${cartItem.quantity}',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '${cartItem.product.price.toStringAsFixed(0)}\$',
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
                // Handle remove product
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
                    hintText: 'Phone',
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
              itemCount: egyptianGovernorates.length,
              itemBuilder: (context, index) {
                final governorate = egyptianGovernorates[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGovernorate = governorate;
                      isGovernorateDropdownOpen = false;
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
                child: Text(
                  'Address',
                  style: TextStyle(
                    color: Color(0xFF848484),
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

  Widget _buildCouponSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E000000),
            blurRadius: 4,
            offset: Offset(0, 0),
            spreadRadius: 0,
          )
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
                  color: Color(0xFF1E1E1E),
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showCouponInput = !showCouponInput;
                  });
                },
                child: Text(
                  'Apply Coupon',
                  style: TextStyle(
                    color: Color(0xFF28A228),
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFF28A228),
                  ),
                ),
              ),
            ],
          ),
          
          if (showCouponInput) ...[
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              height: 45.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Color(0xFFEDEDED),
                borderRadius: BorderRadius.circular(30.r),
              ),
                             child: TextField(
                 controller: _couponController,
                 textAlign: TextAlign.center,
                 decoration: InputDecoration(
                   hintText: 'Coupon',
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
               ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentSummary() {
    // Calculate totals
    double orderTotal = cartItems.fold(0.0, (sum, cartItem) => sum + cartItem.totalPrice);
   // Fixed discount for demo
    double total = orderTotal ;
    
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
              orderTotal.toStringAsFixed(2),
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
              'Free',
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
              '${total.toStringAsFixed(0)} EGP',
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
    return GestureDetector(
      onTap: () async{
          try {
        // TODO: Implement password reset logic
        await Future.delayed(const Duration(seconds: 1)); // Simulate API call
        
          if (mounted) {
            // Show success dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return ResetPasswordDone(
                  text: 'Your order has been confirmed successfully!',
                  isFromCheckout: true,
                );
              },
            );
          }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
          });
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
  }
}
