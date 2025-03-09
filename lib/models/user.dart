import 'dart:io';

class User {
  final String? id;
  final String username;
  final String email;
  final String name;
  final DateTime birthday;
  final bool gender;
  final String? imageUrl;
  final File? profileImage;
  final bool role;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.name,
    required this.birthday,
    required this.gender,
    this.imageUrl = '',
    this.profileImage,
    required this.role,
  });

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? name,
    DateTime? birthday,
    bool? gender,
    String? imageUrl,
    File? profileImage,
    bool? role,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      name: name ?? this.name,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
    );
  }

  bool hasProfileImage() {
    return profileImage != null || imageUrl!.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'birthday': birthday.toIso8601String(),
      'gender': gender,
      'imageUrl': imageUrl,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String?,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? 'N/A',
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : DateTime(2000, 1, 1),
      gender: json['gender'] ?? false,
      imageUrl: (json['imageUrl'] ?? '').toString(),
      profileImage: null,
      role: json['role'] ?? false,
    );
  }
}
