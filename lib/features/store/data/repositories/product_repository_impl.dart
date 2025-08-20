import '../../domain/models/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Maxin Protein Powder',
      price: 29.99,
      imageUrl: 'assets/images/product_image.png',
    ),
    Product(
      id: '2',
      name: 'Creatine Monohydrate',
      price: 19.99,
      imageUrl: 'assets/images/product_image.png',
    ),
    Product(
      id: '3',
      name: 'BCAA Supplement',
      price: 24.99,
      imageUrl: 'assets/images/product_image.png',
    ),
    Product(
      id: '4',
      name: 'Pre-Workout Formula',
      price: 34.99,
      imageUrl: 'assets/images/product_image.png',
    ),
    Product(
      id: '5',
      name: 'Omega-3 Fish Oil',
      price: 15.99,
      imageUrl: 'assets/images/product_image.png',
    ),
    Product(
      id: '6',
      name: 'Multivitamin Complex',
      price: 22.99,
      imageUrl: 'assets/images/product_image.png',
    ),
  ];

  @override
  List<Product> getAllProducts() {
    return List.from(_products);
  }

  @override
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return getAllProducts();
    return _products
        .where((product) =>
            product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  List<Product> getFavoriteProducts() {
    return _products.where((product) => product.isFavorite).toList();
  }

  @override
  void toggleProductFavorite(String productId) {
    final productIndex = _products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      _products[productIndex].toggleFavorite();
    }
  }
}
