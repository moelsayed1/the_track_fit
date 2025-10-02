import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/widgets/shimmer_loading.dart';
import 'package:the_track_fit/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:the_track_fit/features/cart/domain/models/cart_item.dart';
import 'package:the_track_fit/features/store/domain/models/product.dart';
import 'package:the_track_fit/features/store/domain/repositories/product_repository.dart';
import 'package:the_track_fit/features/store/data/repositories/product_repository_impl.dart';
import 'package:the_track_fit/features/store/data/datasources/product_remote_datasource.dart';
import 'package:the_track_fit/features/store/presentation/widgets/product_card.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import 'package:the_track_fit/core/utils/font_helper.dart';

class CartScreenBody extends StatefulWidget {
  const CartScreenBody({super.key});

  @override
  State<CartScreenBody> createState() => _CartScreenBodyState();
}

class _CartScreenBodyState extends State<CartScreenBody> {
  bool isCartActive = true;
  bool isHeartActive = false;

  // Favorite products state
  late final ProductRepository _productRepository;
  List<Product> _favoriteProducts = [];
  bool _isLoadingFavorites = false;
  String? _favoriteError;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    // Initialize product repository
    _productRepository = ProductRepositoryImpl(
      remoteDataSource: ProductRemoteDataSourceImpl(apiService: ApiService()),
    );
    // Load cart items when screen initializes
    context.read<CartCubit>().loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: const BoxDecoration(color: Color(0x26848484)),
                  child: Directionality(
                    textDirection: isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side - Title (and icons for English)
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.cart,
                              style: TextStyle(
                                color: const Color(0xFF1E1E1E),
                                fontSize: 18.sp,
                                fontFamily: context.fontFamily,
                                fontWeight: FontWeight.w500,
                                height: 0.89,
                              ),
                            ),
                            if (!isArabic) ...[
                              SizedBox(width: 8.w),
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
                                        isCartActive
                                            ? Colors.white
                                            : const Color(0xFF28A228),
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
                                  // Load favorite products when heart is tapped
                                  _loadFavoriteProducts();
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
                                      isHeartActive
                                          ? Icons.favorite_border
                                          : Icons.favorite_border,
                                      color: isHeartActive
                                          ? Colors.white
                                          : const Color(0xFF28A228),
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        // Right side - Icons for Arabic + Back arrow
                        Row(
                          children: [
                            if (isArabic) ...[
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
                                        isCartActive
                                            ? Colors.white
                                            : const Color(0xFF28A228),
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
                                  // Load favorite products when heart is tapped
                                  _loadFavoriteProducts();
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
                                      isHeartActive
                                          ? Icons.favorite_border
                                          : Icons.favorite_border,
                                      color: isHeartActive
                                          ? Colors.white
                                          : const Color(0xFF28A228),
                                      size: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],
                            // Back arrow
                            GestureDetector(
                              onTap: () => context.pop(),
                              child: Transform.rotate(
                                angle: !isArabic ? 3.14159 : 0,
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
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Product List Section
                Expanded(child: _buildCartContent(state)),
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
    // Show favorite products if heart is active
    if (isHeartActive) {
      return _buildFavoriteProductsContent();
    }

    if (state is CartLoading) {
      return _buildCartShimmerLoading();
    } else if (state is CartError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.failedToLoadCartItems,
              style: TextStyle(
                color: Colors.red,
                fontSize: 18.sp,
                fontFamily: context.fontFamily,
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
                fontFamily: context.fontFamily,
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
              child: Text(AppLocalizations.of(context)!.retry),
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
                      AppLocalizations.of(context)!.yourCartIsEmpty,
                      style: TextStyle(
                        color: Color(0xFF848484),
                        fontSize: 18.sp,
                        fontFamily: context.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      AppLocalizations.of(context)!.addSomeProductsToGetStarted,
                      style: TextStyle(
                        color: Color(0xFF848484),
                        fontSize: 14.sp,
                        fontFamily: context.fontFamily,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              // Dynamic Product Cards
              ...cartItems
                  .asMap()
                  .entries
                  .map((entry) {
                    int index = entry.key;
                    CartItem cartItem = entry.value;
                    return Column(
                      children: [
                        _buildProductCard(cartItem, index),
                        if (index < cartItems.length - 1)
                          SizedBox(height: 16.h),
                      ],
                    );
                  })
                  .toList()
                  .cast<Widget>(),
            ],
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Build favorite products content
  Widget _buildFavoriteProductsContent() {
    if (_isLoadingFavorites) {
      return _buildFavoriteShimmerLoading();
    }

    if (_favoriteError != null) {
      return _buildFavoriteErrorState();
    }

    if (_favoriteProducts.isEmpty) {
      return _buildFavoriteEmptyState();
    }

    return _buildFavoriteProductsList();
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
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

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
          ),
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
                        fontFamily: context.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '*${cartItem.quantity}',
                      style: TextStyle(
                        color: Color(0xFF1E1E1E),
                        fontSize: 16.sp,
                        fontFamily: context.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      '\$${cartItem.product.price}',
                      style: TextStyle(
                        color: Color(0xFF28A228),
                        fontSize: 16.sp,
                        fontFamily: context.fontFamily,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Remove Button - Positioned at top right for English, top left for Arabic
          Positioned(
            top: -10,
            right: isArabic ? null : -10,
            left: isArabic ? -10 : null,
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
                child: Icon(Icons.close, size: 14.sp, color: Colors.black),
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
              content: Text(
                AppLocalizations.of(context)!.productRemovedFromCart,
              ),
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
              content: Text(
                '${AppLocalizations.of(context)!.failedToRemoveProduct}: $e',
              ),
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
    double orderTotal = cartItems.fold(
      0.0,
      (sum, cartItem) => sum + cartItem.totalPrice,
    );
    double total = orderTotal; // No discount applied

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.paymentSummary,
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 16.sp,
            fontFamily: context.fontFamily,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),

        // Order Total
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.orderTotal,
              style: TextStyle(
                color: Color(0xFF848484),
                fontSize: 14.sp,
                fontFamily: context.fontFamily,
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
                fontFamily: context.fontFamily,
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
              AppLocalizations.of(context)!.shipping,
              style: TextStyle(
                color: Color(0xFF848484),
                fontSize: 14.sp,
                fontFamily: context.fontFamily,
                fontWeight: FontWeight.w400,
                height: 1.14,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.free,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 14.sp,
                fontFamily: context.fontFamily,
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
              AppLocalizations.of(context)!.total,
              style: TextStyle(
                color: Color(0xFF1E1E1E),
                fontSize: 16.sp,
                fontFamily: context.fontFamily,
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
                fontFamily: context.fontFamily,
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
            ),
          ],
        ),
        child: Text(
          AppLocalizations.of(context)!.checkout,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: context.fontFamily,
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
                ShimmerCard(height: 100.h, padding: EdgeInsets.all(16.w)),
                if (index < 2) SizedBox(height: 16.h),
              ],
            );
          }),

          SizedBox(height: 24.h),

          // Shimmer for payment summary
          ShimmerCard(height: 200.h, padding: EdgeInsets.all(16.w)),
        ],
      ),
    );
  }

  /// Load favorite products from API
  Future<void> _loadFavoriteProducts() async {
    if (_isDisposed) return;

    setState(() {
      _isLoadingFavorites = true;
      _favoriteError = null;
    });

    try {
      final favoriteProducts = await _productRepository
          .getFavoriteProductsFromAPI();

      if (!_isDisposed) {
        setState(() {
          _favoriteProducts = favoriteProducts;
          _isLoadingFavorites = false;
        });
      }
    } catch (e) {
      if (!_isDisposed) {
        setState(() {
          _favoriteError = e.toString();
          _isLoadingFavorites = false;
        });
      }
    }
  }

  /// Toggle product favorite status
  Future<void> _onFavoriteToggle(int productId) async {
    if (_isDisposed) return;

    try {
      await _productRepository.toggleProductFavorite(productId);
      if (!_isDisposed) {
        // Reload the favorite products list
        _loadFavoriteProducts();
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update favorite: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate to product detail
  void _onProductTap(Product product) {
    context.push(AppRouter.productDetail, extra: {'product': product});
  }

  /// Build favorite products shimmer loading
  Widget _buildFavoriteShimmerLoading() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          _buildShimmerCard(),
          SizedBox(height: 16.h),
          _buildShimmerCard(),
          SizedBox(height: 16.h),
          _buildShimmerCard(),
        ],
      ),
    );
  }

  /// Build shimmer card for favorites
  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 96.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              Container(
                width: 54.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 16.h, width: 100.w, color: Colors.white),
                    SizedBox(height: 8.h),
                    Container(height: 16.h, width: 80.w, color: Colors.white),
                  ],
                ),
              ),
              Container(
                width: 24.w,
                height: 24.h,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build favorite products error state
  Widget _buildFavoriteErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.failedToLoadFavoriteProducts,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _favoriteError ??
                  AppLocalizations.of(context)!.unknownErrorOccurred,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: _loadFavoriteProducts,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.tryAgain),
            ),
          ],
        ),
      ),
    );
  }

  /// Build favorite products empty state
  Widget _buildFavoriteEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64.sp, color: Colors.grey[400]),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.noFavoriteProducts,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              AppLocalizations.of(
                context,
              )!.productsYouMarkAsFavoriteWillAppearHere,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.go(AppRouter.store),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context)!.browseProducts),
            ),
          ],
        ),
      ),
    );
  }

  /// Build favorite products list
  Widget _buildFavoriteProductsList() {
    return RefreshIndicator(
      onRefresh: _loadFavoriteProducts,
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _favoriteProducts.length,
        itemBuilder: (context, index) {
          final product = _favoriteProducts[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: ProductCard(
              product: product,
              onFavoriteToggle: () => _onFavoriteToggle(product.id),
              onTap: () => _onProductTap(product),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
