import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/features/cart/data/services/cart_service.dart';
import 'package:the_track_fit/features/cart/domain/models/cart_item.dart';
import 'package:the_track_fit/features/store/domain/models/product.dart';

// Events
abstract class CartEvent {}

class LoadCartItems extends CartEvent {}

class AddToCart extends CartEvent {
  final int productId;
  final int quantity;
  final dynamic product;

  AddToCart({
    required this.productId,
    required this.quantity,
    required this.product,
  });
}

class RemoveFromCart extends CartEvent {
  final int cartItemId;

  RemoveFromCart({required this.cartItemId});
}

class ClearCart extends CartEvent {}

// States
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  CartLoaded({required this.cartItems});
}

class CartError extends CartState {
  final String message;

  CartError({required this.message});
}

// Cubit
class CartCubit extends Cubit<CartState> {
  final CartService _cartService;

  CartCubit({required CartService cartService}) 
      : _cartService = cartService,
        super(CartInitial());

  // Load cart items
  Future<void> loadCartItems() async {
    emit(CartLoading());
    
    try {
      final cartData = await _cartService.getCartItems();
      log('CartCubit: Loaded cart data: $cartData');
      
      // Check if cart is empty
      if (cartData.isEmpty) {
        log('CartCubit: Cart is empty');
        emit(CartLoaded(cartItems: []));
        return;
      }
      
      // Convert API response to CartItem objects
      final items = cartData.map((item) {
        log('CartCubit: Processing item: $item');
        // Create a Product object from the cart item data
        final product = Product(
          id: int.parse(item['product_id'].toString()),
          enName: item['product']?['en_name'] ?? 'Unknown Product',
          arName: item['product']?['ar_name'] ?? 'منتج غير معروف',
          enDescription: item['product']?['en_description'] ?? '',
          arDescription: item['product']?['ar_description'] ?? '',
          price: item['product']?['price'] ?? '0.00',
          image: item['product']?['image'] ?? '',
          stock: int.parse((item['product']?['stock'] ?? 0).toString()),
          createdAt: item['created_at'] ?? '',
          updatedAt: item['updated_at'] ?? '',
        );

        final cartItem = CartItem(
          id: int.parse(item['id'].toString()),
          product: product,
          quantity: int.parse(item['quantity'].toString()),
        );
        
        log('CartCubit: Created cart item: ${cartItem.product.enName}, quantity: ${cartItem.quantity}');
        return cartItem;
      }).toList();

      log('CartCubit: Total items created: ${items.length}');
      emit(CartLoaded(cartItems: items));
    } catch (e) {
      log('CartCubit: Error loading cart items: $e');
      emit(CartError(message: e.toString()));
    }
  }

  // Add product to cart
  Future<void> addToCart({
    required int productId,
    required int quantity,
    required dynamic product,
    bool clearExisting = true,
  }) async {
    try {
      await _cartService.addToCart(
        productId: productId,
        quantity: quantity,
        product: product,
        clearExisting: clearExisting,
      );
      
      // Reload cart items after adding
      await loadCartItems();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Remove product from cart
  Future<void> removeFromCart(int cartItemId) async {
    try {
      await _cartService.removeFromCart(cartItemId);
      
      // Reload cart items after removing
      await loadCartItems();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Clear cart
  Future<void> clearCart() async {
    try {
      await _cartService.clearCart();
      emit(CartLoaded(cartItems: []));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Add multiple products to cart (for checkout)
  Future<void> addMultipleToCart(List<CartItem> cartItems) async {
    try {
      // Clear existing cart first
      await _cartService.clearCart();
      
      // Add each item to cart
      for (final cartItem in cartItems) {
        await _cartService.addToCart(
          productId: cartItem.product.id,
          quantity: cartItem.quantity,
          product: cartItem.product,
          clearExisting: false, // Don't clear between items
        );
      }
      
      // Reload cart items after adding all
      await loadCartItems();
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Get current cart items (if loaded)
  List<CartItem> get currentCartItems {
    if (state is CartLoaded) {
      return (state as CartLoaded).cartItems;
    }
    return [];
  }
}
