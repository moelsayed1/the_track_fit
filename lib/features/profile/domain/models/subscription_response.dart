import 'subscription.dart';

class SubscriptionResponse {
  final Subscription? data;
  final int status;
  final String message;

  SubscriptionResponse({
    this.data,
    required this.status,
    required this.message,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    return SubscriptionResponse(
      data: json['data'] != null ? Subscription.fromJson(json['data']) : null,
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

  /// Check if user has an active subscription
  bool get hasActiveSubscription {
    return data != null && status == 200;
  }

  /// Check if no subscription found (404)
  bool get noSubscriptionFound {
    return status == 404;
  }
}
