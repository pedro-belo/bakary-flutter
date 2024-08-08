class User {
  final int id;
  final String username;
  final bool isAdmin;
  final bool isActive;

  User({
    required this.id,
    required this.username,
    required this.isAdmin,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> userData) {
    return User(
      id: userData['id'] as int,
      username: userData['username'] as String,
      isAdmin: userData['is_admin'] as bool,
      isActive: userData['is_active'] as bool,
    );
  }
}
