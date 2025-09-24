class CouponResponse {
  final CouponData? data;
  final int status;
  final String message;

  CouponResponse({
    this.data,
    required this.status,
    required this.message,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) {
    return CouponResponse(
      data: json['data'] != null ? CouponData.fromJson(json['data']) : null,
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
      'message': message,
    };
  }

  /// Check if coupon was applied successfully
  bool get isSuccess {
    return status == 200 && data != null;
  }

  /// Check if coupon is invalid or expired
  bool get isInvalidOrExpired {
    return status == 404;
  }

  /// Check if coupon usage limit reached
  bool get isUsageLimitReached {
    return status == 400;
  }

  /// Check if validation error
  bool get isValidationError {
    return status == 422;
  }
}

class CouponData {
  final String originalPrice;
  final String discountAmount;
  final int finalPrice;
  final int couponId;

  CouponData({
    required this.originalPrice,
    required this.discountAmount,
    required this.finalPrice,
    required this.couponId,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      originalPrice: json['original_price']?.toString() ?? '0.00',
      discountAmount: json['discount_amount']?.toString() ?? '0.00',
      finalPrice: json['final_price'] is int ? json['final_price'] : int.tryParse(json['final_price']?.toString() ?? '0') ?? 0,
      couponId: json['coupon_id'] is int ? json['coupon_id'] : int.tryParse(json['coupon_id']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'original_price': originalPrice,
      'discount_amount': discountAmount,
      'final_price': finalPrice,
      'coupon_id': couponId,
    };
  }

  /// Get formatted original price with EGP
  String get formattedOriginalPrice {
    final price = double.tryParse(originalPrice) ?? 0.0;
    return '${price.toStringAsFixed(0)} EGP';
  }

  /// Get formatted discount amount with EGP
  String get formattedDiscountAmount {
    final discount = double.tryParse(discountAmount) ?? 0.0;
    return '${discount.toStringAsFixed(0)} EGP';
  }

  /// Get formatted final price with EGP
  String get formattedFinalPrice {
    return '$finalPrice EGP';
  }
}
