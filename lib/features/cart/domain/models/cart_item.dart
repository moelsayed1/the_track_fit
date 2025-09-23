import 'package:the_track_fit/features/store/domain/models/product.dart';

class CartItem {
  final int id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.priceAsDouble * quantity;

  CartItem copyWith({
    int? id,
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItem &&
        other.product.id == product.id;
  }

  @override
  int get hashCode => product.id.hashCode;
}
