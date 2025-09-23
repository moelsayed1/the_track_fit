import 'package:the_track_fit/features/workout/domain/models/exercise.dart';

class WorkoutType {
  final String id;
  final String name;
  final String iconPath;
  final bool isSelected;
  final List<Exercise>? exercises;

  const WorkoutType({
    required this.id,
    required this.name,
    required this.iconPath,
    this.isSelected = false,
    this.exercises,
  });

  WorkoutType copyWith({
    String? id,
    String? name,
    String? iconPath,
    bool? isSelected,
    List<Exercise>? exercises,
  }) {
    return WorkoutType(
      id: id ?? this.id,
      name: name ?? this.name,
      iconPath: iconPath ?? this.iconPath,
      isSelected: isSelected ?? this.isSelected,
      exercises: exercises ?? this.exercises,
    );
  }

  // Factory method to create WorkoutType from API data
  factory WorkoutType.fromApiData(Map<String, dynamic> apiData) {
    final iconPath = apiData['icon'] as String;
    final fullIconPath = iconPath.startsWith('http') 
        ? iconPath 
        : 'https://thetrackfit.com/storage/$iconPath';
    
    // Parse exercises from the API data
    List<Exercise> exercises = [];
    if (apiData['exercises'] != null) {
      final exercisesData = apiData['exercises'] as List;
      exercises = exercisesData
          .map((exerciseData) => Exercise.fromApiData(exerciseData))
          .toList();
    }
    
    return WorkoutType(
      id: apiData['id'].toString(),
      name: apiData['en_name'] as String,
      iconPath: fullIconPath,
      isSelected: false,
      exercises: exercises,
    );
  }
}

