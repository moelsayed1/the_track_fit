import 'meal.dart';

class MealCategory {
  final int id;
  final String enName;
  final String arName;
  final String image;
  final String createdAt;
  final String updatedAt;
  final List<Meal> meals;

  MealCategory({
    required this.id,
    required this.enName,
    required this.arName,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.meals,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['id'] ?? 0,
      enName: json['en_name'] ?? '',
      arName: json['ar_name'] ?? '',
      image: json['image'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      meals: (json['meals'] as List<dynamic>?)
          ?.map((meal) => Meal.fromJson(meal))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'image': image,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }

  // Helper method to get full image URL
  String get fullImageUrl {
    return 'https://thetrackfit.com/storage/$image';
  }

  // Helper method to get localized name based on current language
  String getLocalizedName(String language) {
    return language == 'ar' ? arName : enName;
  }
}
