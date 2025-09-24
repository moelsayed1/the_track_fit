import 'dart:developer';

import 'package:the_track_fit/core/services/api_service.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../domain/models/subscription_response.dart';

class SubscriptionService {
  static SubscriptionService? _instance;
  static SubscriptionRepositoryImpl? _repository;
  
  SubscriptionService._();
  
  static SubscriptionService get instance {
    _instance ??= SubscriptionService._();
    return _instance!;
  }
  
  SubscriptionRepositoryImpl get _subscriptionRepository {
    _repository ??= SubscriptionRepositoryImpl(apiService: ApiService());
    return _repository!;
  }
  
  // Cache for subscription data
  SubscriptionResponse? _cachedSubscription;
  DateTime? _lastFetchTime;
  static const Duration _cacheExpiry = Duration(minutes: 10); // Shorter cache for subscription data
  
  /// Get current subscription with caching
  Future<SubscriptionResponse> getCurrentSubscription({bool forceRefresh = false}) async {
    try {
      // Check if we have valid cached data
      if (!forceRefresh && 
          _cachedSubscription != null && 
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheExpiry) {
        log('SubscriptionService: Returning cached subscription');
        return _cachedSubscription!;
      }
      
      log('SubscriptionService: Fetching fresh subscription data');
      final subscription = await _subscriptionRepository.getCurrentSubscription();
      
      // Update cache
      _cachedSubscription = subscription;
      _lastFetchTime = DateTime.now();
      
      return subscription;
    } catch (e) {
      log('SubscriptionService: Error getting subscription: $e');
      
      // Return cached data if available, even if expired
      if (_cachedSubscription != null) {
        log('SubscriptionService: Returning expired cached data due to error');
        return _cachedSubscription!;
      }
      
      rethrow;
    }
  }
  
  /// Clear cache (useful for testing or when data needs to be refreshed)
  void clearCache() {
    _cachedSubscription = null;
    _lastFetchTime = null;
    log('SubscriptionService: Cache cleared');
  }
}
