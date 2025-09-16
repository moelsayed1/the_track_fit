class ShippingGovernment {
  final int id;
  final String nameEn;
  final String nameAr;
  final double shippingCost;

  ShippingGovernment({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.shippingCost,
  });

  factory ShippingGovernment.fromJson(Map<String, dynamic> json) {
    return ShippingGovernment(
      id: json['id'] as int,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
      shippingCost: double.parse(json['shipping_cost'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_ar': nameAr,
      'shipping_cost': shippingCost.toString(),
    };
  }

  @override
  String toString() {
    return nameEn; // Use English name for display
  }
}
