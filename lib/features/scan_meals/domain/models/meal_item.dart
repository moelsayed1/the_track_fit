class MealItem {
  final String itemNameEn;
  final String itemNameAr;

  MealItem({
    required this.itemNameEn,
    required this.itemNameAr,
  });

  factory MealItem.fromJson(Map<String, dynamic> json) {
    return MealItem(
      itemNameEn: json['item_name_en'] ?? '',
      itemNameAr: json['item_name_ar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name_en': itemNameEn,
      'item_name_ar': itemNameAr,
    };
  }

  // Helper method to get localized name based on current language
  String getLocalizedName(String language) {
    return language == 'ar' ? itemNameAr : itemNameEn;
  }
}
