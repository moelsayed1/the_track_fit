import '../helpers/api_response_helper.dart';

/// Base class for models that need translation
abstract class TranslatableModel {
  /// Process text fields from API response
  Future<void> processTextFields(Map<String, dynamic> data, List<String> fieldNames, {String? currentLang}) async {
    final localizedFields = await ApiResponseHelper.processTextFields(data, fieldNames, currentLang: currentLang);
    
    // Apply localized values to model properties
    localizedFields.forEach((key, value) {
      _setTranslatedField(key, value);
    });
  }

  /// Set translated field value - override in subclasses
  void _setTranslatedField(String fieldName, String value) {
    // This should be overridden in subclasses to set the appropriate properties
  }

  /// Get localized value helper
  Future<String> getLocalizedValue(String? arValue, String? enValue, {String? currentLang}) async {
    return await ApiResponseHelper.getLocalizedValue(arValue, enValue, currentLang ?? 'ar');
  }

  /// Get localized value using current app language automatically
  Future<String> getLocalizedValueAuto(String? arValue, String? enValue) async {
    return await ApiResponseHelper.getLocalizedValueAuto(arValue, enValue);
  }

  /// Get translated value helper (backward compatibility)
  Future<String> getTranslatedValue(String? arValue, String? enValue) async {
    return await ApiResponseHelper.getTranslatedValue(arValue, enValue);
  }
}

/// Example model for exercises
class ExerciseModel extends TranslatableModel {
  final int id;
  String title;
  String description;
  String category;
  String? equipment;
  String? instructions;
  String? tips;
  final String imageUrl;
  final int duration;
  final int calories;

  ExerciseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.equipment,
    this.instructions,
    this.tips,
    required this.imageUrl,
    required this.duration,
    required this.calories,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      equipment: json['equipment'],
      instructions: json['instructions'],
      tips: json['tips'],
      imageUrl: json['image_url'] ?? '',
      duration: json['duration'] ?? 0,
      calories: json['calories'] ?? 0,
    );
  }

  /// Create from API response with automatic translation
  static Future<ExerciseModel> fromApiResponse(Map<String, dynamic> json) async {
    final model = ExerciseModel.fromJson(json);
    
    // Process translatable fields
    await model.processTextFields(json, [
      'title',
      'description',
      'category',
      'equipment',
      'instructions',
      'tips',
    ]);
    
    return model;
  }

  @override
  void _setTranslatedField(String fieldName, String value) {
    switch (fieldName) {
      case 'title':
        title = value;
        break;
      case 'description':
        description = value;
        break;
      case 'category':
        category = value;
        break;
      case 'equipment':
        equipment = value;
        break;
      case 'instructions':
        instructions = value;
        break;
      case 'tips':
        tips = value;
        break;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'equipment': equipment,
      'instructions': instructions,
      'tips': tips,
      'image_url': imageUrl,
      'duration': duration,
      'calories': calories,
    };
  }
}

/// Example model for products
class ProductModel extends TranslatableModel {
  final int id;
  String name;
  String description;
  String category;
  String? brand;
  String? ingredients;
  final double price;
  final String imageUrl;
  final int stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.brand,
    this.ingredients,
    required this.price,
    required this.imageUrl,
    required this.stock,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      brand: json['brand'],
      ingredients: json['ingredients'],
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image_url'] ?? '',
      stock: json['stock'] ?? 0,
    );
  }

  /// Create from API response with automatic translation
  static Future<ProductModel> fromApiResponse(Map<String, dynamic> json) async {
    final model = ProductModel.fromJson(json);
    
    // Process translatable fields
    await model.processTextFields(json, [
      'name',
      'description',
      'category',
      'brand',
      'ingredients',
    ]);
    
    return model;
  }

  @override
  void _setTranslatedField(String fieldName, String value) {
    switch (fieldName) {
      case 'name':
        name = value;
        break;
      case 'description':
        description = value;
        break;
      case 'category':
        category = value;
        break;
      case 'brand':
        brand = value;
        break;
      case 'ingredients':
        ingredients = value;
        break;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'brand': brand,
      'ingredients': ingredients,
      'price': price,
      'image_url': imageUrl,
      'stock': stock,
    };
  }
}

/// Example model for goals/categories
class CategoryModel extends TranslatableModel {
  final int id;
  String name;
  String description;
  final String iconUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      iconUrl: json['icon_url'] ?? '',
    );
  }

  /// Create from API response with automatic translation
  static Future<CategoryModel> fromApiResponse(Map<String, dynamic> json) async {
    final model = CategoryModel.fromJson(json);
    
    // Process translatable fields
    await model.processTextFields(json, [
      'name',
      'description',
    ]);
    
    return model;
  }

  @override
  void _setTranslatedField(String fieldName, String value) {
    switch (fieldName) {
      case 'name':
        name = value;
        break;
      case 'description':
        description = value;
        break;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
    };
  }
}
