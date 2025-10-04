import 'dart:developer';
import 'dart:io';

import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';

class SubscriptionService {
  static SubscriptionService? _instance;
  static ApiService? _apiService;

  SubscriptionService._();

  static SubscriptionService get instance {
    _instance ??= SubscriptionService._();
    return _instance!;
  }

  ApiService get _api {
    _apiService ??= ApiService();
    return _apiService!;
  }

  /// Submit subscription with payment proof
  Future<Map<String, dynamic>> submitSubscription({
    required String name,
    required String email,
    required String phone,
    required int packageId,
    required String paymentType,
    required double total,
    String? paymentProofPath,
    String? couponCode,
    Map<String, dynamic>? userData,
  }) async {
    try {
      log(
        'SubscriptionService: Submitting subscription - packageId: $packageId, paymentType: $paymentType',
      );

      // Prepare form data to match API structure
      Map<String, dynamic> formData = {
        'name': name,
        'email': email,
        'phone': phone,
        'package_id': packageId.toString(),
        'payment_type': paymentType,
        'total': total.toString(), // API expects 'total' field
      };

      // Add coupon code if provided
      if (couponCode != null && couponCode.isNotEmpty) {
        formData['coupon_code'] = couponCode;
      }

      // Add payment proof file if provided
      if (paymentProofPath != null && paymentProofPath.isNotEmpty) {
        final file = File(paymentProofPath);

        // Check if file exists
        if (!await file.exists()) {
          log(
            'SubscriptionService: Payment proof file does not exist: $paymentProofPath',
          );
          throw Exception(
            'Payment proof file not found. Please select the image again.',
          );
        }

        // Check file size (optional - prevent very large files)
        final fileSize = await file.length();
        if (fileSize > 10 * 1024 * 1024) {
          // 10MB limit
          log(
            'SubscriptionService: Payment proof file too large: $fileSize bytes',
          );
          throw Exception(
            'Payment proof file is too large. Please select a smaller image.',
          );
        }

        log(
          'SubscriptionService: Payment proof file validated - size: $fileSize bytes',
        );
        formData['payment_proof'] = file;
      }

      // Add user data if provided
      if (userData != null && userData.isNotEmpty) {
        // Add all user data to form data
        userData.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            formData[key] = value.toString();
          }
        });
        log('SubscriptionService: Added user data: ${userData.keys.toList()}');
      }

      log('SubscriptionService: Form data prepared: ${formData.keys.toList()}');

      final response = await _api.postMultipart(
        AppConstants.storeSubscriptionEndpoint,
        data: formData,
      );

      log('SubscriptionService: Response status: ${response.statusCode}');
      log('SubscriptionService: Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clean up temporary payment proof file if it was created
        if (paymentProofPath != null &&
            paymentProofPath.contains('payment_proof_')) {
          try {
            final tempFile = File(paymentProofPath);
            if (await tempFile.exists()) {
              await tempFile.delete();
              log(
                'SubscriptionService: Cleaned up temporary payment proof file',
              );
            }
          } catch (e) {
            log('SubscriptionService: Failed to clean up temporary file: $e');
          }
        }

        return {
          'success': true,
          'data': response.data['data'],
          'message':
              response.data['message'] ?? 'Subscription created successfully',
          'status': response.data['status'],
        };
      } else {
        return {
          'success': false,
          'message':
              response.data['message'] ?? 'Failed to submit subscription',
          'errors': response.data['errors'] ?? {},
        };
      }
    } catch (e) {
      log('SubscriptionService: Error submitting subscription: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
        'errors': {},
      };
    }
  }
}
