class User {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String userType;
  final String phoneNumber;
  final String? avatarUrl;
  final bool isVerified;
  final DateTime dateJoined;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.userType,
    required this.phoneNumber,
    this.avatarUrl,
    required this.isVerified,
    required this.dateJoined,
  });

  bool get isAdmin => userType == 'admin';
  bool get isDoctor => userType == 'doctor';
  bool get isPatient => userType == 'patient';

  String get fullName => '$firstName $lastName';
}
