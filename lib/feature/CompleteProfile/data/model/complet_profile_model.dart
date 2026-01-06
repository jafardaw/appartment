class CompleteProfileModel {
  final String message;
  final UserData user;

  CompleteProfileModel({required this.message, required this.user});

  factory CompleteProfileModel.fromJson(Map<String, dynamic> json) {
    return CompleteProfileModel(
      message: json['message'],
      user: UserData.fromJson(json['user']),
    );
  }
}

class UserData {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? role;
  final String? profileImage;

  UserData({
    required this.id,
    this.firstName,
    this.lastName,
    this.role,
    this.profileImage,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      role: json['role'],
      profileImage: json['profile_image'],
    );
  }
}
