class RegisterResponse {
  final int status;
  final String message;
  final AuthData? data;

  RegisterResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      status: json['status'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  String toString() {
    return 'RegisterResponse(status: $status, message: $message, data: $data)';
  }
}

class AuthData {
  final UserData user;
  final String token;

  AuthData({
    required this.user,
    required this.token,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: UserData.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }

  @override
  String toString() {
    return 'AuthData(user: $user, token: $token)';
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String? image;
  final String type;
  final String? emailVerifiedAt;
  final String createdAt;
  final String updatedAt;
  final String? shiftStart;
  final String? shiftEnd;
  final int? trainerId;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.image,
    required this.type,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.shiftStart,
    this.shiftEnd,
    this.trainerId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image']?.toString(),
      type: json['type'] ?? 'customer',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      shiftStart: json['shift_start'],
      shiftEnd: json['shift_end'],
      trainerId: json['trainer_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'image': image,
      'type': type,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'shift_start': shiftStart,
      'shift_end': shiftEnd,
      'trainer_id': trainerId,
    };
  }

  @override
  String toString() {
    return 'UserData(id: $id, name: $name, email: $email, phone: $phone, gender: $gender, type: $type)';
  }
}
