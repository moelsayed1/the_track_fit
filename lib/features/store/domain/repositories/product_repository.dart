import '../models/product.dart';
import '../models/product_response.dart';

abstract class ProductRepository {
  Future<ProductResponse> getNewProducts({int perPage = 10, int page = 1});
  Future<List<Product>> getAllProducts();
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> getFavoriteProducts();
  Future<void> toggleProductFavorite(int productId);
}
