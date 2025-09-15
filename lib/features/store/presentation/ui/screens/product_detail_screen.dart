import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/widgets/shimmer_loading.dart';
import 'package:the_track_fit/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:the_track_fit/features/store/domain/models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool _isAddingToCart = false;

  void _decreaseQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  Future<void> _addToCart() async {
    if (_isAddingToCart) return; // Prevent multiple calls
    
    setState(() {
      _isAddingToCart = true;
    });

    try {
      final cartCubit = context.read<CartCubit>();
      await cartCubit.addToCart(
        productId: widget.product.id,
        quantity: quantity,
        product: widget.product, // Pass product object for local storage
        clearExisting: true, // Clear existing cart items before adding new one
      );

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Product added to cart successfully'),
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

        // Navigate to cart screen
        context.push(AppRouter.cart);
      }
    } catch (e) {
      if (mounted) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add product to cart: $e'),
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
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 0.h),
            // Header with back button and title
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: const BoxDecoration(
                color: Color(0x26848484),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: SizedBox(
                      width: 32.w,
                      height: 32.h,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/logos/arrow_left.svg',
                          width: 20.w,
                          height: 20.h,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF1E1E1E),
                            BlendMode.srcIn,
                          ),
                          placeholderBuilder: (context) => Icon(
                            Icons.arrow_back,
                            color: const Color(0xFF1E1E1E),
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Product Detail',
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

            // Product content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 100.h), // Added bottom padding for fixed button
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    // Product name
                    Center(
                      child: Text(
                        widget.product.name,
                        style: TextStyle(
                          color: const Color(0xFF1E1E1E),
                          fontSize: 20.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Product image
                    Center(
                      child: Container(
                        width: 150.w,
                        height: 180.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: widget.product.imageUrl.startsWith('http')
                              ? Image.network(
                                  widget.product.imageUrl,
                                  width: 150.w,
                                  height: 180.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/product_image.png',
                                      width: 150.w,
                                      height: 177.h,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    // Handle loading state correctly with a centered shimmer
                                    return Center(
                                      child: ShimmerLoading(
                                        child: Container(
                                          width: 150.w,
                                          height: 177.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Image.asset(
                                  widget.product.imageUrl,
                                  width: 150.w,
                                  height: 180.h,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),

                    SizedBox(height: 40.h),

                    // Product details section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Details',
                          style: TextStyle(
                            color: const Color(0xFF1E1E1E),
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          widget.product.enDescription,
                          style: TextStyle(
                            color: const Color(0xFF848484),
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Text(
                              'Price : ',
                              style: TextStyle(
                                color: const Color(0xFF1E1E1E),
                                fontSize: 16.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$${widget.product.price}',
                              style: TextStyle(
                                color: const Color(0xFF28A228),
                                fontSize: 20.sp,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 60.h),

                    // Quantity selector
                    Center(
                      child: Container(
                        width: 120.w,
                        height: 32.h,
                        decoration: ShapeDecoration(
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: _decreaseQuantity,
                              child: Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: const ShapeDecoration(
                                  color: Color(0x3F848484),
                                  shape: OvalBorder(),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.remove,
                                    color: Color(0xFF1E1E1E),
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              quantity.toString(),
                              style: TextStyle(
                                color: const Color(0xFF1E1E1E),
                                fontSize: 16.sp,
                                fontFamily: 'Overpass',
                                fontWeight: FontWeight.w700,
                                height: 1.13,
                              ),
                            ),
                            GestureDetector(
                              onTap: _increaseQuantity,
                              child: Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFF28A228),
                                  shape: OvalBorder(),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
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
              ),
            ),
          ],
        ),
      ),
      // Fixed Add To Cart Button at bottom
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 28.h),
        child: _buildAddToCartButton(),
      ),
    );
  }

  Widget _buildAddToCartButton() {
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
      child: GestureDetector(
        onTap: _isAddingToCart ? null : _addToCart,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isAddingToCart) ...[
              SizedBox(
                width: 20.w,
                height: 20.h,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              SizedBox(width: 8.w),
            ],
            Text(
              _isAddingToCart ? 'Adding...' : 'Add To Cart',
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
          ],
        ),
      ),
    );
  }
}
