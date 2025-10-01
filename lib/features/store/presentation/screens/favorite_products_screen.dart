import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_track_fit/core/constants/app_colors.dart';
import 'package:the_track_fit/core/router/app_router.dart';
import 'package:the_track_fit/core/widgets/app_scaffold.dart';
import 'package:the_track_fit/features/store/domain/models/product.dart';
import 'package:the_track_fit/features/store/domain/repositories/product_repository.dart';
import 'package:the_track_fit/features/store/data/repositories/product_repository_impl.dart';
import 'package:the_track_fit/features/store/data/datasources/product_remote_datasource.dart';
import 'package:the_track_fit/features/store/presentation/widgets/product_card.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/generated/l10n/app_localizations.dart';

class FavoriteProductsScreen extends StatefulWidget {
  const FavoriteProductsScreen({super.key});

  @override
  State<FavoriteProductsScreen> createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  late final ProductRepository _productRepository;
  List<Product> _favoriteProducts = [];
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _productRepository = ProductRepositoryImpl(
      remoteDataSource: ProductRemoteDataSourceImpl(apiService: ApiService()),
    );
    _loadFavoriteProducts();
  }

  Future<void> _loadFavoriteProducts() async {
    if (_isDisposed) return;
    
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      log('FavoriteProductsScreen: Loading favorite products...');
      final favoriteProducts = await _productRepository.getFavoriteProductsFromAPI();
      
      if (!_isDisposed) {
        setState(() {
          _favoriteProducts = favoriteProducts;
          _isLoading = false;
        });
        log('FavoriteProductsScreen: Loaded ${favoriteProducts.length} favorite products');
      }
    } catch (e) {
      log('FavoriteProductsScreen: Error loading favorite products: $e');
      if (!_isDisposed) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _onFavoriteToggle(int productId) async {
    if (_isDisposed) return;
    
    try {
      await _productRepository.toggleProductFavorite(productId);
      if (!_isDisposed) {
        // Reload the favorite products list
        _loadFavoriteProducts();
      }
    } catch (e) {
      log('FavoriteProductsScreen: Error toggling favorite: $e');
      if (!_isDisposed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.failedToUpdateFavorite}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onProductTap(Product product) {
    context.push(AppRouter.productDetail, extra: {'product': product});
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoriteProducts),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_favoriteProducts.isEmpty) {
      return _buildEmptyState();
    }

    return _buildProductsList();
  }

  Widget _buildLoadingState() {
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
                    Container(
                      height: 16.h,
                      width: 100.w,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 16.h,
                      width: 80.w,
                      color: Colors.white,
                    ),
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

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
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
              AppLocalizations.of(context)!.failedToLoadFavoriteProducts,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _error ?? AppLocalizations.of(context)!.unknownErrorOccurred,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64.sp,
              color: Colors.grey[400],
            ),
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
              AppLocalizations.of(context)!.productsYouMarkAsFavoriteWillAppearHere,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[500],
              ),
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

  Widget _buildProductsList() {
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
}
