import 'package:mediconnect_app/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.userType,
    required super.phoneNumber,
    super.avatarUrl,
    required super.isVerified,
    required super.dateJoined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      userType: json['user_type'],
      phoneNumber: json['phone_number'],
      avatarUrl: json['avatar'],
      isVerified: json['is_verified'],
      dateJoined: DateTime.parse(json['date_joined']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'user_type': userType,
      'phone_number': phoneNumber,
      'avatar': avatarUrl,
      'is_verified': isVerified,
      'date_joined': dateJoined.toIso8601String(),
    };
  }
}
