import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/constants/app_text_styles.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/features/store/presentation/widgets/product_card.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/product_remote_datasource.dart';
import '../../../domain/models/product.dart';
import '../../../domain/repositories/product_repository.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/widgets/app_scaffold.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  late final ProductRepository _productRepository;
  final TextEditingController _searchController = TextEditingController();
  
  bool _isSearchMode = false; // Add search mode state
  bool _showOnlyFavorites = false;
  List<Product> _displayedProducts = [];
  String _searchQuery = '';
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;
  Timer? _searchDebounceTimer;

  @override
  void initState() {
    super.initState();
    _productRepository = ProductRepositoryImpl(
      remoteDataSource: ProductRemoteDataSourceImpl(apiService: ApiService()),
    );
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    if (_isDisposed) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<Product> products;
      if (_showOnlyFavorites) {
        products = await _productRepository.getFavoriteProductsFromAPI();
      } else if (_searchQuery.isNotEmpty) {
        products = await _productRepository.searchProducts(_searchQuery);
      } else {
        products = await _productRepository.getAllProducts();
      }
      
      if (!_isDisposed) {
        setState(() {
          _displayedProducts = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!_isDisposed) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _toggleFavoriteFilter() {
    if (_isDisposed) return;
    setState(() {
      _showOnlyFavorites = !_showOnlyFavorites;
    });
    _loadProducts();
  }

  void _onSearchChanged(String query) {
    if (_isDisposed) return;
    
    // Cancel previous timer
    _searchDebounceTimer?.cancel();
    
    setState(() {
      _searchQuery = query;
    });
    
    // Debounce search to avoid too many API calls
    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (!_isDisposed) {
        _loadProducts();
      }
    });
  }

  void _toggleSearchMode() {
    if (_isDisposed) return;
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

  Future<void> _onFavoriteToggle(int productId) async {
    if (_isDisposed) return;
    try {
      await _productRepository.toggleProductFavorite(productId);
      if (!_isDisposed) {
        // Update the local product's favorite status immediately for better UX
        setState(() {
          final productIndex = _displayedProducts.indexWhere((p) => p.id == productId);
          if (productIndex != -1) {
            _displayedProducts[productIndex].toggleFavorite();
          }
        });
        
        // Also reload products to ensure consistency with server
        _loadProducts();
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

  void _onProductTap(Product product) {
    // Navigate to product detail screen using app router
    context.push(AppRouter.productDetail, extra: {'product': product});
  }

  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
      itemCount: 6, // Show 6 shimmer cards
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 96.h, // Height of ProductCard
              padding: EdgeInsets.all(16.w),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignOutside,
                    color: Color(0xFF28A228),
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
              ),
              child: Row(
                children: [
                  // Product image shimmer
                  Container(
                    width: 54.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Product details shimmer
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 80.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Favorite icon shimmer
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: const Color(0xFFF6FFF6),
      body: Column(
          children: [ // Custom AppBar matching Figma design
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
                    children: [                                                                                                             // Cart Icon - Light green background with green border and dark green icon
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
                       SizedBox(width: 8.w),                                                                                                              // Favorite Icon - Light green background with green border and dark green icon
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
                       SizedBox(width: 8.w),                                                                                                                                                  // Search Icon - Toggleable with tap functionality
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
            ),                                                                                                   // Conditional Search Bar - shows when search mode is NOT active
            if (!_isSearchMode)
              Container(
                width: 343.w,
                height: 43.h,
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
              child: _isLoading
                  ? _buildShimmerLoader()
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64.sp,
                                color: AppColors.gray,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Failed to load products',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.gray,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              TextButton(
                                onPressed: _loadProducts,
                                child: Text(
                                  'Retry',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.primaryGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _displayedProducts.isEmpty
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
      );
    }
  

  @override
  void dispose() {
    _isDisposed = true;
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

}