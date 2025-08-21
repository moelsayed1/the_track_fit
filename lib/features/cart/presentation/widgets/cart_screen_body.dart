import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_track_fit/features/store/domain/models/product.dart';
import 'package:the_track_fit/features/cart/domain/models/cart_item.dart';

class CartScreenBody extends StatefulWidget {
  const CartScreenBody({super.key});

  @override
  State<CartScreenBody> createState() => _CartScreenBodyState();
}

class _CartScreenBodyState extends State<CartScreenBody> {
  bool isCartActive = true;
  bool isHeartActive = false;
  
  // Cart items state using Product model
  List<CartItem> cartItems = [
    CartItem(
      product: Product(
        id: '1',
        name: 'Premium Protein Powder',
        price: 29.99,
        imageUrl: 'assets/images/product_image.png',
      ),
      quantity: 1,
    ),
    CartItem(
      product: Product(
        id: '2',
        name: 'Resistance Bands Set',
        price: 19.99,
        imageUrl: 'assets/images/product_image.png',
      ),
      quantity: 2,
    ),
  ];

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
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
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
                        'Cart',
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
                              isHeartActive ? Icons.favorite_border : Icons.favorite_border,
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
            
            // Product List Section
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    // Check if cart is empty
                    if (cartItems.isEmpty)
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 220.h),
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64.sp,
                              color: Color(0xFF848484),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Your cart is empty',
                              style: TextStyle(
                                color: Color(0xFF848484),
                                fontSize: 18.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Add some products to get started',
                              style: TextStyle(
                                color: Color(0xFF848484),
                                fontSize: 14.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      // Dynamic Product Cards
                      ...cartItems.asMap().entries.map((entry) {
                        int index = entry.key;
                        CartItem cartItem = entry.value;
                        return Column(
                          children: [
                            _buildProductCard(cartItem, index),
                            if (index < cartItems.length - 1) SizedBox(height: 16.h),
                          ],
                        );
                      }).toList().cast<Widget>(),
                      
                      SizedBox(height: 180),
                      
                      // Payment Summary Section
                      _buildPaymentSummary(),
                      
                      SizedBox(height: 32.h),
                      
                      // Checkout Button
                      _buildCheckoutButton(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildProductCard(CartItem cartItem, int index) {
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
                  image: DecorationImage(
                    image: AssetImage(cartItem.product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartItem.product.name,
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
                      '\$${cartItem.product.price.toStringAsFixed(2)}',
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
                _removeProduct(index);
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
  
  // Method to remove product from cart
  void _removeProduct(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }
   
  Widget _buildPaymentSummary() {
    // Calculate totals dynamically
    double orderTotal = cartItems.fold(0.0, (sum, cartItem) => sum + cartItem.totalPrice);
    double discount = orderTotal * 0.126; // 12.6% discount
    double total = orderTotal - discount;
    
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
                height: 1.14,
              ),
            ),
            Text(
              orderTotal.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.29,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        
        // Items Discount
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Items Discount',
              style: TextStyle(
                color: Color(0xFF848484),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.14,
              ),
            ),
            Text(
              '- ${discount.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 1.29,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        
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
                height: 1.14,
              ),
            ),
            Text(
              'Free',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 1.29,
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
                fontWeight: FontWeight.w400,
                height: 1.13,
              ),
            ),
            Text(
              '${total.toStringAsFixed(2)} EGP',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 16.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 1.13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Color(0xFF28A228), Color(0xD85CD65C)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x2628A228),
            blurRadius: 4,
            offset: Offset(4, 0),
            spreadRadius: 0,
          )
        ],
      ),
      child: Text(
        'Checkout',
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
    );
  }
}