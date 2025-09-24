import '../models/coupon_response.dart';

abstract class CouponRepository {
  Future<CouponResponse> applyCoupon({
    required String code,
    required int packageId,
  });
}
