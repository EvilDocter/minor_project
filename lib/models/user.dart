/// lib/models/user.dart
class UserModel {
  final int? id;
  final String username;
  final String password;
  final String role;
  final int enabled;

  UserModel({this.id, required this.username, required this.password, required this.role, this.enabled = 1});

  Map<String, dynamic> toMap() => {
        'id': id,
        'username': username,
        'password': password,
        'role': role,
        'enabled': enabled,
      };

  static UserModel fromMap(Map<String, dynamic> m) => UserModel(
        id: m['id'] as int?,
        username: m['username'] as String,
        password: m['password'] as String,
        role: m['role'] as String,
        enabled: m['enabled'] as int? ?? 1,
      );
}
