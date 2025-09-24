import 'dart:developer';

import 'package:the_track_fit/core/services/api_service.dart';
import '../../data/repositories/coupon_repository_impl.dart';
import '../../domain/models/coupon_response.dart';

class CouponService {
  static CouponService? _instance;
  static CouponRepositoryImpl? _repository;
  
  CouponService._();
  
  static CouponService get instance {
    _instance ??= CouponService._();
    return _instance!;
  }
  
  CouponRepositoryImpl get _couponRepository {
    _repository ??= CouponRepositoryImpl(apiService: ApiService());
    return _repository!;
  }
  
  /// Apply coupon code to a package
  Future<CouponResponse> applyCoupon({
    required String code,
    required int packageId,
  }) async {
    try {
      log('CouponService: Applying coupon - code: $code, packageId: $packageId');
      
      final response = await _couponRepository.applyCoupon(
        code: code,
        packageId: packageId,
      );
      
      log('CouponService: Coupon response - success: ${response.isSuccess}');
      
      return response;
    } catch (e) {
      log('CouponService: Error applying coupon: $e');
      rethrow;
    }
  }
}
