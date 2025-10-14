import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/widgets/localized_text.dart';
import 'package:the_track_fit/features/store/presentation/widgets/product_card.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/datasources/product_remote_datasource.dart';
import '../../../domain/models/product.dart';
import '../../../domain/repositories/product_repository.dart';
import 'package:the_track_fit/core/services/api_service.dart';

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
          // Sort products by creation date (most recent first) as a fallback
          _displayedProducts = _sortProductsByDate(products);
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

    // Store the current favorite status before toggling
    final productIndex = _displayedProducts.indexWhere(
      (p) => p.id == productId,
    );
    if (productIndex == -1) return;

    final wasFavorite = _displayedProducts[productIndex].isFavorite;

    // Update the local product's favorite status immediately for better UX
    setState(() {
      _displayedProducts[productIndex].toggleFavorite();

      // If we're in favorites mode and the product is being unfavorited, remove it from the list
      if (_showOnlyFavorites && !_displayedProducts[productIndex].isFavorite) {
        _displayedProducts.removeAt(productIndex);
      } else if (_showOnlyFavorites &&
          _displayedProducts[productIndex].isFavorite) {
        // If we're in favorites mode and the product is being favorited, sort the list
        _displayedProducts = _sortProductsByDate(_displayedProducts);
      }
    });

    try {
      // Call the API to toggle favorite status
      await _productRepository.toggleProductFavorite(productId);

      // If we're not in favorites mode, reload to ensure consistency
      if (!_showOnlyFavorites) {
        _loadProducts();
      }
    } catch (e) {
      if (!_isDisposed && mounted) {
        // Revert the local change if the API call failed
        setState(() {
          if (_showOnlyFavorites && !wasFavorite) {
            // If we removed the item from favorites list, add it back
            _loadProducts();
          } else {
            // Just toggle the favorite status back
            final currentProductIndex = _displayedProducts.indexWhere(
              (p) => p.id == productId,
            );
            if (currentProductIndex != -1) {
              _displayedProducts[currentProductIndex].toggleFavorite();
            }
          }
        });

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

  // Helper method to sort products by update date (oldest first)
  List<Product> _sortProductsByDate(List<Product> products) {
    final sortedProducts = List<Product>.from(products);
    sortedProducts.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.updatedAt);
        final dateB = DateTime.parse(b.updatedAt);
        final comparison = dateA.compareTo(dateB); // Oldest first
        log(
          'StoreScreen Sorting: ${a.name} (${a.updatedAt}) vs ${b.name} (${b.updatedAt}) -> $comparison',
        );
        return comparison;
      } catch (e) {
        log('StoreScreen Error parsing dates: $e');
        return 0; // Keep original order if parsing fails
      }
    });

    // Log the final sorted order
    log('StoreScreen Final sorted order:');
    for (int i = 0; i < sortedProducts.length; i++) {
      log('$i: ${sortedProducts[i].name} (${sortedProducts[i].updatedAt})');
    }

    return sortedProducts;
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Builder(
          builder: (context) {
            final isArabic =
                Localizations.localeOf(context).languageCode == 'ar';
            final String fontFamily = isArabic ? 'Cairo' : 'Poppins';

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: const BoxDecoration(color: Color(0x26848484)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back arrow (direction depends on language)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Transform(
                          alignment: Alignment.center,
                          transform:
                              Localizations.localeOf(context).languageCode ==
                                  'ar'
                              ? Matrix4.rotationY(3.1415926535897932)
                              : Matrix4.identity(),
                          child: SvgPicture.asset(
                            'assets/logos/arrow_left.svg',
                            width: 24.w,
                            height: 24.h,
                            colorFilter: const ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      LocalizedText(
                        AppLocalizations.of(context)!.store,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                        height: 0.89,
                      ),
                      Spacer(),
                      // Action icons (cart, favorite, search)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Cart Icon
                          GestureDetector(
                            onTap: () {
                              context.push(AppRouter.cart);
                            },
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: ShapeDecoration(
                                color: const Color(0x1A28A228),
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
                                    AppColors.primaryGreen,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Favorite Icon
                          GestureDetector(
                            onTap: _toggleFavoriteFilter,
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: ShapeDecoration(
                                color: _showOnlyFavorites
                                    ? const Color(0xFF28A228)
                                    : const Color(0xFFC0DEC0),
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
                                  Icons.favorite_border,
                                  color: _showOnlyFavorites
                                      ? Colors.white
                                      : AppColors.primaryGreen,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Search Icon
                          GestureDetector(
                            onTap: _toggleSearchMode,
                            child: Container(
                              width: 32.w,
                              height: 32.h,
                              decoration: ShapeDecoration(
                                color: _isSearchMode
                                    ? const Color(0xFFC0DEC0)
                                    : const Color(0xFF28A228),
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
                                  Icons.search,
                                  color: _isSearchMode
                                      ? AppColors.primaryGreen
                                      : Colors.white,
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
                // Conditional Search Bar - shows when search mode is NOT active
                if (!_isSearchMode)
                  Container(
                    width: 343.w,
                    height: 43.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
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
                              hintText: isArabic
                                  ? 'ابحث عن منتج'
                                  : 'Search Product',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: const Color(0xBF848484),
                                fontSize: 12.sp,
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                              ),
                            ),
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 12.sp,
                              fontFamily: fontFamily,
                              fontWeight: FontWeight.w400,
                              height: 1.33,
                            ),
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
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
                              LocalizedText(
                                isArabic
                                    ? 'فشل تحميل المنتجات'
                                    : 'Failed to load products',
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.gray,
                              ),
                              SizedBox(height: 8.h),
                              TextButton(
                                onPressed: _loadProducts,
                                child: LocalizedText(
                                  isArabic ? 'إعادة المحاولة' : 'Retry',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.primaryGreen,
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
                              LocalizedText(
                                _showOnlyFavorites
                                    ? (isArabic
                                          ? 'لا توجد منتجات مفضلة بعد'
                                          : 'No favorite products yet')
                                    : (isArabic
                                          ? 'لم يتم العثور على منتجات'
                                          : 'No products found'),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.gray,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            top: 16.h,
                            left: 16.w,
                            right: 16.w,
                          ),
                          itemCount: _displayedProducts.length,
                          itemBuilder: (context, index) {
                            final product = _displayedProducts[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: ProductCard(
                                product: product,
                                onFavoriteToggle: () =>
                                    _onFavoriteToggle(product.id),
                                onTap: () => _onProductTap(product),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
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
