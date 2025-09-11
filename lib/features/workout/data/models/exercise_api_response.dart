class ExerciseApiResponse {
  final List<ExerciseApiData> data;
  final int status;
  final String message;

  const ExerciseApiResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory ExerciseApiResponse.fromJson(Map<String, dynamic> json) {
    return ExerciseApiResponse(
      data: (json['data'] as List<dynamic>)
          .map((item) => ExerciseApiData.fromJson(item as Map<String, dynamic>))
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

class ExerciseApiData {
  final int id;
  final int exerciseCategoryId;
  final String arName;
  final String? arDescription;
  final String enName;
  final String? enDescription;
  final String gif;
  final String gender;
  final String location;
  final String equipment;
  final String createdAt;
  final String updatedAt;
  final int dayId;
  final String goal;
  final Map<String, dynamic>? category;

  const ExerciseApiData({
    required this.id,
    required this.exerciseCategoryId,
    required this.arName,
    this.arDescription,
    required this.enName,
    this.enDescription,
    required this.gif,
    required this.gender,
    required this.location,
    required this.equipment,
    required this.createdAt,
    required this.updatedAt,
    required this.dayId,
    required this.goal,
    this.category,
  });

  factory ExerciseApiData.fromJson(Map<String, dynamic> json) {
    return ExerciseApiData(
      id: json['id'] as int,
      exerciseCategoryId: json['exercise_category_id'] as int,
      arName: json['ar_name'] as String,
      arDescription: json['ar_description'] as String?,
      enName: json['en_name'] as String,
      enDescription: json['en_description'] as String?,
      gif: json['gif'] as String,
      gender: json['gender'] as String,
      location: json['location'] as String,
      equipment: json['equipment'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      dayId: json['day_id'] as int,
      goal: json['goal'] as String,
      category: json['category'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exercise_category_id': exerciseCategoryId,
      'ar_name': arName,
      'ar_description': arDescription,
      'en_name': enName,
      'en_description': enDescription,
      'gif': gif,
      'gender': gender,
      'location': location,
      'equipment': equipment,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'day_id': dayId,
      'goal': goal,
      'category': category,
    };
  }
}
