import 'dart:developer';

import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import '../../domain/models/coupon_response.dart';
import '../../domain/repositories/coupon_repository.dart';

class CouponRepositoryImpl implements CouponRepository {
  final ApiService _apiService;

  CouponRepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<CouponResponse> applyCoupon({
    required String code,
    required int packageId,
  }) async {
    try {
      log('CouponRepository: Applying coupon - code: $code, packageId: $packageId');
      
      final response = await _apiService.postForm(
        AppConstants.applyCouponEndpoint,
        data: {
          'code': code,
          'package_id': packageId.toString(),
        },
      );

      log('CouponRepository: Response status: ${response.statusCode}');
      log('CouponRepository: Response data: ${response.data}');

      if (response.statusCode == 200) {
        return CouponResponse.fromJson(response.data);
      } else if (response.statusCode == 404) {
        // Handle invalid or expired coupon
        return CouponResponse.fromJson(response.data);
      } else if (response.statusCode == 400) {
        // Handle usage limit reached
        return CouponResponse.fromJson(response.data);
      } else if (response.statusCode == 422) {
        // Handle validation error
        return CouponResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to apply coupon: ${response.statusCode}');
      }
    } catch (e) {
      log('CouponRepository: Error applying coupon: $e');
      rethrow;
    }
  }
}
