class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? bio;
  final String? phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.bio,
    required this.phone,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      bio: json['bio'],
      phone: json['phone'],
    );
  }

    UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? bio,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
    );
  }
}