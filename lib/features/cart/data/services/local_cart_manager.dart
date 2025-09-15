import 'package:the_track_fit/features/cart/domain/models/cart_item.dart';
import 'package:the_track_fit/features/store/domain/models/product.dart';

class LocalCartManager {
  static final LocalCartManager _instance = LocalCartManager._internal();
  factory LocalCartManager() => _instance;
  LocalCartManager._internal();

  final List<CartItem> _cartItems = [];
  int _nextId = 1;

  // Add product to local cart
  void addToCart(Product product, int quantity) {
    // Check if product already exists in cart
    final existingIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      // Update quantity if product already exists
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + quantity,
      );
    } else {
      // Add new item to cart
      _cartItems.add(CartItem(
        id: _nextId++,
        product: product,
        quantity: quantity,
      ));
    }
  }

  // Get all cart items
  List<CartItem> getCartItems() {
    return List.from(_cartItems);
  }

  // Remove item from cart
  void removeFromCart(int cartItemId) {
    _cartItems.removeWhere((item) => item.id == cartItemId);
  }

  // Update item quantity
  void updateQuantity(int cartItemId, int quantity) {
    final index = _cartItems.indexWhere((item) => item.id == cartItemId);
    if (index != -1) {
      if (quantity <= 0) {
        removeFromCart(cartItemId);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      }
    }
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
  }

  // Get cart item count
  int get itemCount => _cartItems.length;

  // Get total price
  double get totalPrice => _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
}
