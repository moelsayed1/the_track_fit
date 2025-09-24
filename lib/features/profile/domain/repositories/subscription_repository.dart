import '../models/subscription_response.dart';

abstract class SubscriptionRepository {
  Future<SubscriptionResponse> getCurrentSubscription();
}
