class RegisterResponse {
  final bool success;
  final String message;
  final UserData? data;

  RegisterResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return 'RegisterResponse(success: $success, message: $message, data: $data)';
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String? token;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'token': token,
    };
  }

  @override
  String toString() {
    return 'UserData(id: $id, name: $name, email: $email, phone: $phone, gender: $gender)';
  }
}
