import '../../domain/models/product.dart';
import '../../domain/models/product_response.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  final List<Product> _cachedProducts = [];
  final List<Product> _favoriteProducts = [];
  
  // Request deduplication
  final Map<String, Future<ProductResponse>> _activeRequests = {};
  
  ProductRepositoryImpl({required ProductRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<ProductResponse> getNewProducts({int perPage = 10, int page = 1}) async {
    // Create a unique key for this request
    final requestKey = 'new_products_${perPage}_$page';
    
    // Check if there's already an active request for this key
    if (_activeRequests.containsKey(requestKey)) {
      return await _activeRequests[requestKey]!;
    }
    
    // Create the request and store it
    final request = _performGetNewProducts(perPage: perPage, page: page);
    _activeRequests[requestKey] = request;
    
    try {
      final response = await request;
      return response;
    } finally {
      // Remove the request from active requests when done
      _activeRequests.remove(requestKey);
    }
  }
  
  Future<ProductResponse> _performGetNewProducts({int perPage = 8, int page = 1}) async {
    try {
      final response = await _remoteDataSource.getNewProducts(
        perPage: perPage,
        page: page,
      );
      
      // Cache the products for offline access
      if (page == 1) {
        _cachedProducts.clear();
      }
      _cachedProducts.addAll(response.products);
      
      return response;
    } catch (e) {
      // Return cached products if API fails
      if (_cachedProducts.isNotEmpty) {
        return ProductResponse(
          products: _cachedProducts,
          pagination: PaginationInfo(
            currentPage: 1,
            lastPage: 1,
            perPage: _cachedProducts.length,
            total: _cachedProducts.length,
            links: PaginationLinks(),
          ),
          status: 200,
          message: 'Cached products loaded',
        );
      }
      rethrow;
    }
  }

  @override
  Future<List<Product>> getAllProducts() async {
    if (_cachedProducts.isEmpty) {
      final response = await getNewProducts(perPage: 100);
      return response.products;
    }
    return List.from(_cachedProducts);
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final products = await getAllProducts();
    if (query.isEmpty) return products;
    return products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    return List.from(_favoriteProducts);
  }

  @override
  Future<void> toggleProductFavorite(int productId) async {
    final productIndex = _cachedProducts.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      _cachedProducts[productIndex].toggleFavorite();
      
      // Update favorite products list
      if (_cachedProducts[productIndex].isFavorite) {
        _favoriteProducts.add(_cachedProducts[productIndex]);
      } else {
        _favoriteProducts.removeWhere((p) => p.id == productId);
      }
    }
  }
}
