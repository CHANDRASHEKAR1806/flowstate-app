class UserModel {
  final int id;
  final String email;
  final String password;
  final String fullName;
  final String role;
  final String department;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.fullName,
    this.role = 'Member',
    this.department = 'Workspace',
    this.avatarUrl = '',
  });

  UserModel copyWith({
    int? id,
    String? email,
    String? password,
    String? fullName,
    String? role,
    String? department,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      department: department ?? this.department,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'fullName': fullName,
      'role': role,
      'department': department,
      'avatarUrl': avatarUrl,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      role: json['role'] as String? ?? 'Member',
      department: json['department'] as String? ?? 'Workspace',
      avatarUrl: json['avatarUrl'] as String? ?? '',
    );
  }

  String get initials {
    if (fullName.trim().isEmpty) return 'U';
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
