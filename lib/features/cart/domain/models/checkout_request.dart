import 'package:the_track_fit/features/cart/domain/models/cart_item.dart';

class CheckoutRequest {
  final int userId;
  final String paymentType;
  final String? paymentProof;
  final String clientName;
  final String fullPhone;
  final String clientEmail;
  final String clientAddress;
  final double subtotal;
  final int shippingGovernmentId;
  final double shippingCost;
  final double total;
  final List<CartItem> cartItems;

  CheckoutRequest({
    required this.userId,
    required this.paymentType,
    this.paymentProof,
    required this.clientName,
    required this.fullPhone,
    required this.clientEmail,
    required this.clientAddress,
    required this.subtotal,
    required this.shippingGovernmentId,
    required this.shippingCost,
    required this.total,
    required this.cartItems,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'payment_type': paymentType,
      if (paymentProof != null) 'payment_proof': paymentProof,
      'client_name': clientName,
      'full_phone': fullPhone,
      'client_email': clientEmail,
      'client_address': clientAddress,
      'subtotal': subtotal.toString(),
      'shipping_government_id': shippingGovernmentId.toString(),
      'shipping_cost': shippingCost.toString(),
      'total': total.toString(),
      'cart': cartItems.map((item) => {
        'product_id': item.product.id,
        'quantity': item.quantity,
      }).toList(),
    };
  }
}
