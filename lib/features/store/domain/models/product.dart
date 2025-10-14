import 'package:the_track_fit/core/helpers/api_localization_helper.dart';
import 'package:the_track_fit/core/services/language_service.dart';

class Product {
  final int id;
  final String enName;
  final String arName;
  final String enDescription;
  final String arDescription;
  final String price;
  final String image;
  final int stock;
  final String createdAt;
  final String updatedAt;
  bool isFavorite;

  Product({
    required this.id,
    required this.enName,
    required this.arName,
    required this.enDescription,
    required this.arDescription,
    required this.price,
    required this.image,
    required this.stock,
    required this.createdAt,
    required this.updatedAt,
    this.isFavorite = false,
  });

  // Factory constructor to create Product from API response
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      enName: json['en_name'] as String? ?? '',
      arName: json['ar_name'] as String? ?? '',
      enDescription: json['en_description'] as String? ?? '',
      arDescription: json['ar_description'] as String? ?? '',
      price: json['price'] as String? ?? '',
      image: json['image'] as String? ?? '',
      stock: json['stock'] as int,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      isFavorite:
          json['is_favorite'] as bool? ??
          false, // Default to false if not provided
    );
  }

  // Getter for display name (localized)
  String get name {
    final currentLang = LanguageService.instance.currentLanguage;
    return ApiLocalizationHelper.getLocalizedValueSync(
      arName,
      enName,
      currentLang,
    );
  }

  // Getter for display description (localized)
  String get description {
    final currentLang = LanguageService.instance.currentLanguage;
    return ApiLocalizationHelper.getLocalizedValueSync(
      arDescription,
      enDescription,
      currentLang,
    );
  }

  // Async getter for display name with translation
  Future<String> get localizedName async {
    final currentLang = LanguageService.instance.currentLanguage;
    return await ApiLocalizationHelper.getLocalizedValue(
      arName,
      enName,
      currentLang,
    );
  }

  // Async getter for display description with translation
  Future<String> get localizedDescription async {
    final currentLang = LanguageService.instance.currentLanguage;
    return await ApiLocalizationHelper.getLocalizedValue(
      arDescription,
      enDescription,
      currentLang,
    );
  }

  // Getter for display price as double
  double get priceAsDouble => double.tryParse(price) ?? 0.0;

  // Getter for full image URL with storage prefix
  String get imageUrl => 'https://thetrackfit.com/storage/$image';

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }

  Product copyWith({
    int? id,
    String? enName,
    String? arName,
    String? enDescription,
    String? arDescription,
    String? price,
    String? image,
    int? stock,
    String? createdAt,
    String? updatedAt,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      enName: enName ?? this.enName,
      arName: arName ?? this.arName,
      enDescription: enDescription ?? this.enDescription,
      arDescription: arDescription ?? this.arDescription,
      price: price ?? this.price,
      image: image ?? this.image,
      stock: stock ?? this.stock,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en_name': enName,
      'ar_name': arName,
      'en_description': enDescription,
      'ar_description': arDescription,
      'price': price,
      'image': image,
      'stock': stock,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
