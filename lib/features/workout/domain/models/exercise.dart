import 'package:the_track_fit/core/helpers/api_localization_helper.dart';
import 'package:the_track_fit/core/services/language_service.dart';

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
  final int? sets;
  final int? reps;
  
  // Arabic and English fields for localization
  final String? arName;
  final String? enName;
  final String? arDescription;
  final String? enDescription;

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
    this.sets,
    this.reps,
    this.arName,
    this.enName,
    this.arDescription,
    this.enDescription,
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
    int? sets,
    int? reps,
    String? arName,
    String? enName,
    String? arDescription,
    String? enDescription,
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
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      arName: arName ?? this.arName,
      enName: enName ?? this.enName,
      arDescription: arDescription ?? this.arDescription,
      enDescription: enDescription ?? this.enDescription,
    );
  }

  // Factory method to create Exercise from API data
  factory Exercise.fromApiData(Map<String, dynamic> apiData) {
    final gifPath = apiData['gif'] as String;
    final fullImagePath = gifPath.startsWith('http') 
        ? gifPath 
        : 'https://thetrackfit.com/storage/$gifPath';
    
    // Get localized values
    final currentLang = LanguageService.instance.currentLanguage;
    final localizedName = ApiLocalizationHelper.getLocalizedValueSync(
      apiData['ar_name'] as String?,
      apiData['en_name'] as String?,
      currentLang,
    );
    final localizedDescription = ApiLocalizationHelper.getLocalizedValueSync(
      apiData['ar_description'] as String?,
      apiData['en_description'] as String?,
      currentLang,
    );
    
    return Exercise(
      id: apiData['id'].toString(),
      title: localizedName.isNotEmpty ? localizedName : (apiData['en_name'] as String? ?? 'Exercise'),
      subtitle: localizedDescription.isNotEmpty ? localizedDescription : 'No description available',
      imagePath: fullImagePath,
      type: _mapEquipmentToType(apiData['equipment'] as String? ?? 'no_equipment'),
      isFavorite: false,
      description: localizedDescription.isNotEmpty ? localizedDescription : apiData['en_description'] as String?,
      gender: apiData['gender'] as String?,
      location: apiData['location'] as String?,
      equipment: apiData['equipment'] as String?,
      goal: apiData['goal'] as String?,
      categoryId: apiData['exercise_category_id'].toString(),
      sets: apiData['sets'] as int?,
      reps: apiData['reps'] as int?,
      arName: apiData['ar_name'] as String?,
      enName: apiData['en_name'] as String?,
      arDescription: apiData['ar_description'] as String?,
      enDescription: apiData['en_description'] as String?,
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

  // Getter for localized name
  String get localizedName {
    final currentLang = LanguageService.instance.currentLanguage;
    return ApiLocalizationHelper.getLocalizedValueSync(arName, enName, currentLang);
  }

  // Getter for localized description
  String get localizedDescription {
    final currentLang = LanguageService.instance.currentLanguage;
    return ApiLocalizationHelper.getLocalizedValueSync(arDescription, enDescription, currentLang);
  }

  // Async getter for localized name with translation
  Future<String> get localizedNameAsync async {
    final currentLang = LanguageService.instance.currentLanguage;
    return await ApiLocalizationHelper.getLocalizedValue(arName, enName, currentLang);
  }

  // Async getter for localized description with translation
  Future<String> get localizedDescriptionAsync async {
    final currentLang = LanguageService.instance.currentLanguage;
    return await ApiLocalizationHelper.getLocalizedValue(arDescription, enDescription, currentLang);
  }

  // Helper method to format sets and reps as a display string
  String get setsAndRepsDisplay {
    if (sets != null && reps != null) {
      return '$sets Sets x $reps reps';
    } else if (sets != null) {
      return '$sets Sets';
    } else if (reps != null) {
      return '$reps reps';
    } else {
      return 'No sets/reps specified';
    }
  }
}

