class User {
  final String? id;
  final String username;
  final String password;
  final String name;
  final String email;
  final String profileImageUrl;
  final DateTime birthday;
  final bool gender;
  final bool role;

  User({
    this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.birthday,
    required this.gender,
    required this.role,
  });

  User copyWith({
    String? id,
    String? username,
    String? password,
    String? name,
    String? email,
    String? profileImageUrl,
    DateTime? birthday,
    bool? gender,
    bool? role,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      role: role ?? this.role,
    );
  }
}
