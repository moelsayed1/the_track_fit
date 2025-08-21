import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/constants/app_text_styles.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/features/store/presentation/widgets/product_card.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../domain/models/product.dart';
import '../../../domain/repositories/product_repository.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final ProductRepository _productRepository = ProductRepositoryImpl();
  final TextEditingController _searchController = TextEditingController();
  
  bool _isSearchMode = false; // Add search mode state
  bool _showOnlyFavorites = false;
  List<Product> _displayedProducts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    setState(() {
      if (_showOnlyFavorites) {
        _displayedProducts = _productRepository.getFavoriteProducts();
      } else if (_searchQuery.isNotEmpty) {
        _displayedProducts = _productRepository.searchProducts(_searchQuery);
      } else {
        _displayedProducts = _productRepository.getAllProducts();
      }
    });
  }

  void _toggleFavoriteFilter() {
    setState(() {
      _showOnlyFavorites = !_showOnlyFavorites;
      _loadProducts();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _loadProducts();
    });
  }

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (!_isSearchMode) {
        // Clear search when hiding search bar
        _searchController.clear();
        _searchQuery = '';
        _loadProducts();
      }
    });
  }

  void _onFavoriteToggle(String productId) {
    _productRepository.toggleProductFavorite(productId);
    _loadProducts();
  }

  void _onProductTap(Product product) {
    // Navigate to product detail screen using app router
    context.push(AppRouter.productDetail, extra: {'product': product});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: SafeArea(
        child: Column(
          children: [
                         // Custom AppBar matching Figma design
             Container(
               width: double.infinity,
               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
               decoration: const BoxDecoration(
                 color: Color(0x26848484),
               ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   // Left side - Back button and Store title
                   Row(
                     children: [
                                               GestureDetector(
                          onTap: () => context.go(AppRouter.home),
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
                          'Store',
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
                  
                  // Right side - Action icons
                  Row(
                    children: [
                                                                                                                                             // Cart Icon - Light green background with green border and dark green icon
                          GestureDetector(
                            onTap: () {
                              // Handle cart tap
                              context.push(AppRouter.cart);
                              
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: ShapeDecoration(
                                color: const Color(0x1A28A228), // Light green background
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
                                   colorFilter: const ColorFilter.mode(
                                     AppColors.primaryGreen, // Dark green icon on light green background
                                     BlendMode.srcIn,
                                   ),
                                 ),
                               ),
                            ),
                          ),
                       
                       SizedBox(width: 8.w),
                       
                                                                                                                                               // Favorite Icon - Light green background with green border and dark green icon
                          GestureDetector(
                            onTap: _toggleFavoriteFilter,
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                                                           decoration: ShapeDecoration(
                               color: _showOnlyFavorites 
                                   ? const Color(0xFF28A228) // Solid green background when active
                                   : const Color(0xFFC0DEC0), // Light green background when inactive
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
                                 _showOnlyFavorites
                                     ? Icons.favorite_border
                                     : Icons.favorite_border,
                                 color: _showOnlyFavorites 
                                     ? Colors.white // White heart outline when active (solid green background)
                                     : AppColors.primaryGreen, // Dark green heart outline when inactive (light green background)
                                 size: 20.sp,
                               ),
                             ),
                            ),
                          ),
                       
                       SizedBox(width: 8.w),
                       
                                                                                                                                                                                         // Search Icon - Toggleable with tap functionality
                        GestureDetector(
                          onTap: _toggleSearchMode,
                          child: Container(
                            width: 32.w,
                            height: 32.h,
                                                         decoration: ShapeDecoration(
                               color: _isSearchMode 
                                   ? const Color(0xFFC0DEC0) // Light green background when search is active
                                   : const Color(0xFF28A228), // Solid green background when search is inactive
                               shape: RoundedRectangleBorder(
                                 side: const BorderSide(width: 1, color: Color(0xFF28A228)), // Always green border
                                 borderRadius: BorderRadius.circular(16.r),
                               ),
                             ),
                                                          child: Center(
                               child: Icon(
                                 Icons.search, // Always search icon (magnifying glass)
                                 color: _isSearchMode 
                                     ? AppColors.primaryGreen // Green icon when search is active
                                     : Colors.white, // White icon when search is inactive
                                 size: 20.sp,
                               ),
                             ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
                                                                                                                               // Conditional Search Bar - shows when search mode is NOT active
            if (!_isSearchMode)
              Container(
                width: 343.w,
                height: 43.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: ShapeDecoration(
                  color: const Color(0x26848484),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
               child: Row(
                 mainAxisSize: MainAxisSize.min,
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                                       Container(
                      width: 24.w,
                      height: 24.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(),
                                           child: SvgPicture.asset(
                       'assets/logos/search.svg',
                       width: 24.w,
                       height: 24.h,
                       colorFilter: const ColorFilter.mode(
                         Color(0xBF848484),
                         BlendMode.srcIn,
                       ),
                     ),
                    ),
                    SizedBox(width: 4.w),
                   Expanded(
                                            child: TextField(
                         controller: _searchController,
                         onChanged: _onSearchChanged,
                         decoration: InputDecoration(
                           hintText: 'Search Product',
                           border: InputBorder.none,
                           hintStyle: TextStyle(
                             color: const Color(0xBF848484),
                             fontSize: 12.sp,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w400,
                             height: 1.33,
                           ),
                         ),
                         style: TextStyle(
                           color: const Color(0xFF1E1E1E),
                           fontSize: 12.sp,
                           fontFamily: 'Poppins',
                           fontWeight: FontWeight.w400,
                           height: 1.33,
                         ),
                       ),
                   ),
                 ],
               ),
             ),
            
            // Product List
            Expanded(
              child: _displayedProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                                                     Icon(
                             _showOnlyFavorites
                                 ? Icons.favorite_border
                                 : Icons.search_off,
                             size: 64.sp,
                             color: AppColors.gray,
                           ),
                           SizedBox(height: 16.h),
                          Text(
                            _showOnlyFavorites
                                ? 'No favorite products yet'
                                : 'No products found',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.gray,
                            ),
                          ),
                        ],
                      ),
                    )
                                     : ListView.builder(
                       padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                       itemCount: _displayedProducts.length,
                      itemBuilder: (context, index) {
                        final product = _displayedProducts[index];
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
