import 'dart:developer';

import 'package:the_track_fit/core/constants/app_constants.dart';
import 'package:the_track_fit/core/services/api_service.dart';
import '../../domain/models/subscription_response.dart';
import '../../domain/repositories/subscription_repository.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final ApiService _apiService;

  SubscriptionRepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<SubscriptionResponse> getCurrentSubscription() async {
    try {
      log('SubscriptionRepository: Getting current subscription');
      
      final response = await _apiService.get(
        AppConstants.getCurrentSubscriptionEndpoint,
      );

      log('SubscriptionRepository: Response status: ${response.statusCode}');
      log('SubscriptionRepository: Response data: ${response.data}');

      if (response.statusCode == 200) {
        return SubscriptionResponse.fromJson(response.data);
      } else if (response.statusCode == 404) {
        // Handle no subscription found case - this is a valid response
        log('SubscriptionRepository: No active subscription found');
        return SubscriptionResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load subscription: ${response.statusCode}');
      }
    } catch (e) {
      log('SubscriptionRepository: Error getting subscription: $e');
      rethrow;
    }
  }
}
