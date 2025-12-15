enum UserRole { admin, teacher, student }

class User {
  final String id;
  final String username;
  final String password;
  final String name;
  final UserRole role;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'role': role.index,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      name: map['name'],
      role: UserRole.values[map['role']],
    );
  }
}