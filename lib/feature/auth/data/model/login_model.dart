// lib/features/login/data/models/login_response_model.dart

class LoginResponseModel {
  final String? message; // جعلناه nullable لأن الـ JSON لا يحتوي عليه حالياً
  final String token;
  final UserModel user;

  LoginResponseModel({this.message, required this.token, required this.user});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      // القيمة في الـ JSON هي 'Token' بحرف كبير
      token: json['Token'] as String,
      message: json['message'] as String? ?? 'تم تسجيل الدخول بنجاح',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'Token': token, 'message': message, 'user': user.toJson()};
  }
}

class UserModel {
  final String role;

  UserModel({required this.role});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(role: json['role'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'role': role};
  }
}
