class RegisterRequest {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String gender;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'gender': gender,
    };
  }

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'] ?? '',
      passwordConfirmation: json['password_confirmation'] ?? '',
      gender: json['gender'] ?? '',
    );
  }

  @override
  String toString() {
    return 'RegisterRequest(name: $name, email: $email, phone: $phone, gender: $gender)';
  }
}
