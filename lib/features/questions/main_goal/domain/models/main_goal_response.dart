class MainGoalResponse {
  final List<String> data;
  final int status;
  final String message;

  MainGoalResponse({
    required this.data,
    required this.status,
    required this.message,
  });

  factory MainGoalResponse.fromJson(Map<String, dynamic> json) {
    return MainGoalResponse(
      data: List<String>.from(json['data'] ?? []),
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'status': status,
      'message': message,
    };
  }
}
