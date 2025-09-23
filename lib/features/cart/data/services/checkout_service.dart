import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/features/cart/domain/models/shipping_government.dart';
import 'package:the_track_fit/features/cart/domain/models/checkout_request.dart';
import 'package:the_track_fit/features/cart/domain/models/checkout_response.dart';

class CheckoutService {
  final ApiService _apiService;

  CheckoutService({required ApiService apiService}) : _apiService = apiService;

  // Get shipping governments
  Future<List<ShippingGovernment>> getShippingGovernments() async {
    try {
      log('CheckoutService: Getting shipping governments...');
      final response = await _apiService.get(AppConstants.getShippingGovernmentsEndpoint);
      
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        final governments = data
            .map((json) => ShippingGovernment.fromJson(json))
            .toList();
        log('CheckoutService: Retrieved ${governments.length} shipping governments');
        return governments;
      } else {
        throw Exception('Failed to get shipping governments: ${response.statusCode}');
      }
    } catch (e) {
      log('CheckoutService: Error getting shipping governments: $e');
      throw Exception('Failed to get shipping governments: $e');
    }
  }

  // Submit checkout order
  Future<CheckoutResponse> submitOrder(CheckoutRequest request, {String? paymentProofPath}) async {
    try {
      log('CheckoutService: Submitting order...');
      log('CheckoutService: Request data: ${request.toJson()}');
      
      Response response;
      
      if (paymentProofPath != null && request.paymentType == 'instapay') {
        // Use multipart form data for file upload
        final Map<String, dynamic> formData = request.toJson();
        formData['payment_proof'] = File(paymentProofPath);
        
        // Remove cart from formData as it will be handled separately
        final cartData = formData.remove('cart');
        
        response = await _apiService.postMultipart(
          AppConstants.storeSaleEndpoint,
          data: formData,
          cartData: cartData, // Pass cart data separately
        );
      } else {
        // Use regular JSON for other payment types
        response = await _apiService.post(
          AppConstants.storeSaleEndpoint,
          data: request.toJson(),
        );
      }
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        log('CheckoutService: Order submitted successfully');
        return CheckoutResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to submit order: ${response.statusCode}');
      }
    } catch (e) {
      log('CheckoutService: Error submitting order: $e');
      throw Exception('Failed to submit order: $e');
    }
  }
}
