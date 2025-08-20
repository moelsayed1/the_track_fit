import '../models/product.dart';

abstract class ProductRepository {
  List<Product> getAllProducts();
  List<Product> searchProducts(String query);
  List<Product> getFavoriteProducts();
  void toggleProductFavorite(String productId);
}
