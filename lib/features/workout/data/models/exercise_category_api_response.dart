import 'package:the_track_fit/features/workout/data/models/exercise_api_response.dart';

class ExerciseCategoryApiResponse {
  final List<ExerciseCategoryApiData> data;
  final int status;
  final String message;

  const ExerciseCategoryApiResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ExerciseCategoryApiResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseCategoryApiResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => ExerciseCategoryApiData.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }
}

class ExerciseCategoryApiData {
  final int id;
  final String arName;
  final String enName;
  final String icon;
  final String createdAt;
  final String updatedAt;
  final List<ExerciseApiData> exercises;

  const ExerciseCategoryApiData({
    required this.id,
    required this.arName,
    required this.enName,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
    required this.exercises,
  });

  factory ExerciseCategoryApiData.fromJson(Map<String, dynamic> json) {
    return ExerciseCategoryApiData(
      id: json['id'] as int,
      arName: json['ar_name'] as String,
      enName: json['en_name'] as String,
      icon: json['icon'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((item) => ExerciseApiData.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ar_name': arName,
      'en_name': enName,
      'icon': icon,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'exercises': exercises.map((item) => item.toJson()).toList(),
    };
  }
}
