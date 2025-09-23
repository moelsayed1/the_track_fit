import 'meal_item.dart';

class Meal {
  final int id;
  final int mealCategoryId;
  final String enName;
  final String arName;
  final List<MealItem> items;
  final int calories;
  final String createdAt;
  final String updatedAt;
  final int dayId;

  Meal({
    required this.id,
    required this.mealCategoryId,
    required this.enName,
    required this.arName,
    required this.items,
    required this.calories,
    required this.createdAt,
    required this.updatedAt,
    required this.dayId,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] ?? 0,
      mealCategoryId: json['meal_category_id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => MealItem.fromJson(item))
          .toList() ?? [],
      calories: json['calories'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      dayId: json['day_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'meal_category_id': mealCategoryId,
      'en_name': enName,
      'ar_name': arName,
      'items': items.map((item) => item.toJson()).toList(),
      'calories': calories,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'day_id': dayId,
    };
  }

  // Helper method to get description from items
  String get description {
    return items.map((item) => item.itemNameEn).join(', ');
  }
}
