class CheckoutResponse {
  final bool success;
  final String message;
  final CheckoutData? data;

  CheckoutResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      success: json['status'] == 201 || json['status'] == 200,
      message: json['message'] as String,
      data: json['data'] != null ? CheckoutData.fromJson(json['data']) : null,
    );
  }
}

class CheckoutData {
  final int id;
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
  final String createdAt;
  final String updatedAt;
  final List<SaleItem> saleItems;

  CheckoutData({
    required this.id,
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
    required this.createdAt,
    required this.updatedAt,
    required this.saleItems,
  });

  factory CheckoutData.fromJson(Map<String, dynamic> json) {
    return CheckoutData(
      id: int.parse(json['id'].toString()),
      userId: int.parse(json['user_id'].toString()),
      paymentType: json['payment_type'] as String,
      paymentProof: json['payment_proof'] as String?,
      clientName: json['client_name'] as String,
      fullPhone: json['client_phone'] as String,
      clientEmail: json['client_email'] as String,
      clientAddress: json['client_address'] as String,
      subtotal: double.parse(json['subtotal'].toString()),
      shippingGovernmentId: int.parse(json['shipping_government_id'].toString()),
      shippingCost: double.parse(json['shipping_cost'].toString()),
      total: double.parse(json['total'].toString()),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      saleItems: (json['sale_items'] as List)
          .map((item) => SaleItem.fromJson(item))
          .toList(),
    );
  }
}

class SaleItem {
  final int id;
  final int saleId;
  final int productId;
  final int quantity;
  final double price;
  final String createdAt;
  final String updatedAt;
  final Product product;

  SaleItem({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      id: int.parse(json['id'].toString()),
      saleId: int.parse(json['sale_id'].toString()),
      productId: int.parse(json['product_id'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      price: double.parse(json['price'].toString()),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      product: Product.fromJson(json['product']),
    );
  }
}

class Product {
  final int id;
  final String image;
  final String arName;
  final String enName;
  final String arDescription;
  final String enDescription;
  final double price;
  final int stock;
  final String createdAt;
  final String updatedAt;

  Product({
    required this.id,
    required this.image,
    required this.arName,
    required this.enName,
    required this.arDescription,
    required this.enDescription,
    required this.price,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: int.parse(json['id'].toString()),
      image: json['image'] as String,
      arName: json['ar_name'] as String,
      enName: json['en_name'] as String,
      arDescription: json['ar_description'] as String,
      enDescription: json['en_description'] as String,
      price: double.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }
}
