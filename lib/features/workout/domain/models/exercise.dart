class Exercise {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final String type;
  final bool isFavorite;
  final String? description;
  final String? gender;
  final String? location;
  final String? equipment;
  final String? goal;
  final String? categoryId;

  const Exercise({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.type,
    this.isFavorite = false,
    this.description,
    this.gender,
    this.location,
    this.equipment,
    this.goal,
    this.categoryId,
  });

  Exercise copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imagePath,
    String? type,
    bool? isFavorite,
    String? description,
    String? gender,
    String? location,
    String? equipment,
    String? goal,
    String? categoryId,
  }) {
    return Exercise(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imagePath: imagePath ?? this.imagePath,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      equipment: equipment ?? this.equipment,
      goal: goal ?? this.goal,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  // Factory method to create Exercise from API data
  factory Exercise.fromApiData(Map<String, dynamic> apiData) {
    final gifPath = apiData['gif'] as String;
    final fullImagePath = gifPath.startsWith('http') 
        ? gifPath 
        : 'https://thetrackfit.com/storage/$gifPath';
    
    return Exercise(
      id: apiData['id'].toString(),
      title: apiData['en_name'] as String,
      subtitle: apiData['en_description'] as String? ?? 'No description available',
      imagePath: fullImagePath,
      type: _mapEquipmentToType(apiData['equipment'] as String),
      isFavorite: false,
      description: apiData['en_description'] as String?,
      gender: apiData['gender'] as String,
      location: apiData['location'] as String,
      equipment: apiData['equipment'] as String,
      goal: apiData['goal'] as String,
      categoryId: apiData['exercise_category_id'].toString(),
    );
  }

  // Helper method to map equipment to exercise type
  static String _mapEquipmentToType(String equipment) {
    switch (equipment) {
      case 'no_equipment':
        return 'cardio';
      case 'mat_only':
        return 'stretching';
      case 'machines':
        return 'gym';
      default:
        return 'cardio';
    }
  }
}

