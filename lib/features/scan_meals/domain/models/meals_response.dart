import 'meal_category.dart';

class MealsResponse {
  final List<MealCategory> data;
  final int status;
  final String message;

  MealsResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory MealsResponse.fromJson(Map<String, dynamic> json) {
    return MealsResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((category) => MealCategory.fromJson(category))
          .toList() ?? [],
      status: json['status'] ?? 0,
      message: json['message'] ?? 'errorrrrrrr',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((category) => category.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }
}
