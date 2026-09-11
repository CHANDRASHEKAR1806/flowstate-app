import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserRepository {
  static const String _keyUsers = 'app_users_json';
  final SharedPreferences _prefs;

  UserRepository(this._prefs) {
    _initDemoUser();
  }

  void _initDemoUser() {
    if (!_prefs.containsKey(_keyUsers)) {
      final demoUser = UserModel(
        id: 1,
        email: 'alex.morgan@company.com',
        password: 'password123',
        fullName: 'Alex Morgan',
        role: 'Lead UX Designer',
        department: 'Core Team',
        avatarUrl: '',
      );
      saveUsers([demoUser]);
    }
  }

  List<UserModel> getAllUsers() {
    final raw = _prefs.getString(_keyUsers);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List<dynamic> list = jsonDecode(raw);
      return list.map((item) => UserModel.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveUsers(List<UserModel> users) async {
    final raw = jsonEncode(users.map((u) => u.toJson()).toList());
    await _prefs.setString(_keyUsers, raw);
  }

  Future<UserModel?> authenticate(String email, String password) async {
    final users = getAllUsers();
    final lower = email.trim().toLowerCase();
    for (final u in users) {
      if (u.email.toLowerCase() == lower && u.password == password) {
        return u;
      }
    }
    return null;
  }

  Future<UserModel?> getUserById(int id) async {
    final users = getAllUsers();
    for (final u in users) {
      if (u.id == id) return u;
    }
    return null;
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    String role = 'Member',
    String department = 'Workspace',
  }) async {
    final users = getAllUsers();
    final lower = email.trim().toLowerCase();
    if (users.any((u) => u.email.toLowerCase() == lower)) {
      throw Exception('An account with this email address already exists.');
    }

    final newId = users.isEmpty ? 1 : (users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1);
    final newUser = UserModel(
      id: newId,
      fullName: fullName.trim(),
      email: email.trim(),
      password: password,
      role: role,
      department: department,
    );

    users.add(newUser);
    await saveUsers(users);
    return newUser;
  }

  Future<UserModel> updateUserProfile({
    required int id,
    required String fullName,
    required String role,
    required String department,
  }) async {
    final users = getAllUsers();
    final index = users.indexWhere((u) => u.id == id);
    if (index == -1) throw Exception('User not found.');

    final updated = users[index].copyWith(
      fullName: fullName,
      role: role,
      department: department,
    );
    users[index] = updated;
    await saveUsers(users);
    return updated;
  }
}
