import 'dart:developer';

import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/features/cart/data/services/local_cart_manager.dart';
import 'package:the_track_fit/features/store/domain/models/product.dart';

class CartService {
  final ApiService _apiService;
  final LocalCartManager _localCart = LocalCartManager();

  CartService({required ApiService apiService}) : _apiService = apiService;

  // Add product to cart
  Future<Map<String, dynamic>> addToCart({
    required int productId,
    required int quantity,
    Product? product, // Optional product object for local storage
    bool clearExisting = true, // Clear existing cart items before adding new one
  }) async {
    try {
      // Clear existing cart items before adding new one (if requested)
      if (clearExisting) {
        await _clearCart();
      }

      final response = await _apiService.post(
        AppConstants.storeInCartEndpoint,
        data: {
          'product_id': productId,
          'quantity': quantity,
        },
      );

      if (response.statusCode == 200) {
        // API call successful - clear local storage to avoid conflicts
        _localCart.clearCart();
        log('CartService: Cleared local storage after successful API add');
        return response.data;
      } else {
        throw Exception('Failed to add product to cart: ${response.statusCode}');
      }
    } catch (e) {
      // If API fails, still add to local storage
      if (product != null) {
        // Clear local cart if requested
        if (clearExisting) {
          _localCart.clearCart();
        }
        _localCart.addToCart(product, quantity);
        return {
          'status': 200,
          'message': 'Product added to local cart (API unavailable)',
          'data': {'product_id': productId, 'quantity': quantity}
        };
      }
      throw Exception('Failed to add product to cart: $e');
    }
  }

  // Get cart items - Always try API first, use local storage as fallback
  Future<List<Map<String, dynamic>>> getCartItems() async {
    try {
      // Always try the API first
      final response = await _apiService.get(AppConstants.getCartItemsEndpoint);
      
      if (response.statusCode == 200) {
        // Handle the API response structure: data.items[]
        final data = response.data['data'];
        log('CartService: API response data: $data');
        if (data != null && data['items'] != null) {
          final items = List<Map<String, dynamic>>.from(data['items']);
          log('CartService: Parsed ${items.length} cart items from API');
          // Clear local storage since we're using API data
          _localCart.clearCart();
          return items;
        }
        log('CartService: No items found in API response');
        return [];
      } else {
        throw Exception('Failed to get cart items: ${response.statusCode}');
      }
    } catch (e) {
      // If API fails, use local storage as fallback
      log('CartService: API failed, using local storage: $e');
      final localItems = _localCart.getCartItems();
      if (localItems.isNotEmpty) {
        log('CartService: Using local cart items (${localItems.length} items)');
        return _getLocalCartItems();
      }
      log('CartService: No local items found either');
      return [];
    }
  }

  // Convert local cart items to API format
  List<Map<String, dynamic>> _getLocalCartItems() {
    return _localCart.getCartItems().map((cartItem) {
      return {
        'id': cartItem.id,
        'product_id': cartItem.product.id,
        'quantity': cartItem.quantity,
        'product': {
          'id': cartItem.product.id,
          'en_name': cartItem.product.enName,
          'ar_name': cartItem.product.arName,
          'en_description': cartItem.product.enDescription,
          'ar_description': cartItem.product.arDescription,
          'price': cartItem.product.price,
          'image': cartItem.product.imageUrl,
          'stock': cartItem.product.stock,
        },
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };
    }).toList();
  }

  // Remove product from cart - Uses local storage as fallback
  Future<void> removeFromCart(int cartItemId) async {
    try {
      // First get the cart item to find the product_id
      final cartItems = await getCartItems();
      final cartItem = cartItems.firstWhere(
        (item) => item['id'] == cartItemId,
        orElse: () => throw Exception('Cart item not found'),
      );
      
      final productId = cartItem['product_id'] as int;
      
      // Use POST method for remove-from-cart endpoint with product_id
      final response = await _apiService.post(
        AppConstants.removeFromCartEndpoint,
        data: {'product_id': productId},
      );
      
      if (response.statusCode != 200) {
        throw Exception('Failed to remove product from cart: ${response.statusCode}');
      }
    } catch (e) {
      // If the endpoint doesn't exist (404) or other error, use local storage
      if (e.toString().contains('404') || e.toString().contains('Cart item not found')) {
        log('Remove from cart endpoint not available or item not found, using local storage');
        _localCart.removeFromCart(cartItemId);
        return;
      }
      throw Exception('Failed to remove product from cart: $e');
    }
  }

  // Clear all cart items
  Future<void> _clearCart() async {
    // Clear local storage
    _localCart.clearCart();
    log('Local cart cleared');
  }

  Future<void> clearCart() async {
    await _clearCart();
  }
}
