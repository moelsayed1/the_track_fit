import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/widgets/shimmer_loading.dart';
import 'package:the_track_fit/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:the_track_fit/features/cart/domain/models/cart_item.dart';

class CartScreenBody extends StatefulWidget {
  const CartScreenBody({super.key});

  @override
  State<CartScreenBody> createState() => _CartScreenBodyState();
}

class _CartScreenBodyState extends State<CartScreenBody> {
  bool isCartActive = true;
  bool isHeartActive = false;

  @override
  void initState() {
    super.initState();
    // Load cart items when screen initializes
    context.read<CartCubit>().loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF6FFF6),
          body: SafeArea(
            child: Column(
              children: [
                // Header Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
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
                  child: _buildCartContent(state),
                ),
              ],
            ),
          ),
          // Fixed Payment Summary and Checkout Button at bottom
          bottomNavigationBar: _buildBottomNavigationBar(state),
        );
      },
    );
  }

  Widget _buildCartContent(CartState state) {
    if (state is CartLoading) {
      return _buildCartShimmerLoading();
    } else if (state is CartError) {
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
              'Failed to load cart items',
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              state.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () => context.read<CartCubit>().loadCartItems(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF28A228),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (state is CartLoaded) {
      final cartItems = state.cartItems;
      
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
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
            ],
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }

  Widget? _buildBottomNavigationBar(CartState state) {
    if (state is CartLoaded && state.cartItems.isNotEmpty) {
      return Container(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Payment Summary Section
            _buildPaymentSummary(state.cartItems),
            
            SizedBox(height: 24.h), // Fixed 24.h spacing as requested
            
            // Checkout Button
            _buildCheckoutButton(),
          ],
        ),
      );
    }
    return null;
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
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: cartItem.product.imageUrl.startsWith('http')
                      ? Image.network(
                          cartItem.product.imageUrl,
                          width: 54.w,
                          height: 64.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/product_image.png',
                              width: 54.w,
                              height: 64.h,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          cartItem.product.imageUrl,
                          width: 54.w,
                          height: 64.h,
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
                      '\$${cartItem.product.price}',
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
  Future<void> _removeProduct(int index) async {
    final cartCubit = context.read<CartCubit>();
    final currentState = cartCubit.state;
    
    if (currentState is CartLoaded) {
      final cartItem = currentState.cartItems[index];
      
      try {
        await cartCubit.removeFromCart(cartItem.id);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Product removed from cart'),
              backgroundColor: const Color(0xFF28A228),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: 100.h, // Position above the fixed button
                left: 16.w,
                right: 16.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to remove product: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.only(
                bottom: 100.h, // Position above the fixed button
                left: 16.w,
                right: 16.w,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        }
      }
    }
  }
   
  Widget _buildPaymentSummary(List<CartItem> cartItems) {
    // Calculate totals dynamically
    double orderTotal = cartItems.fold(0.0, (sum, cartItem) => sum + cartItem.totalPrice);
    double total = orderTotal; // No discount applied
    
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
    return GestureDetector(
      onTap: () {
        // Navigate to checkout screen
        context.push(AppRouter.checkout);
      },
      child: Container(
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
      ),
    );
  }

  Widget _buildCartShimmerLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          // Shimmer for product cards
          ...List.generate(3, (index) {
            return Column(
              children: [
                ShimmerCard(
                  height: 100.h,
                  padding: EdgeInsets.all(16.w),
                ),
                if (index < 2) SizedBox(height: 16.h),
              ],
            );
          }),
          
          SizedBox(height: 24.h),
          
          // Shimmer for payment summary
          ShimmerCard(
            height: 200.h,
            padding: EdgeInsets.all(16.w),
          ),
        ],
      ),
    );
  }
}