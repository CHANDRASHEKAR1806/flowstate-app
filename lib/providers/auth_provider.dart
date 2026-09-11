import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/session_service.dart';
import '../services/user_repository.dart';

class AuthProvider extends ChangeNotifier {
  final SessionService _sessionService;
  final UserRepository _userRepository;

  UserModel? _currentUser;
  bool _isLoading = false;

  AuthProvider(this._sessionService, this._userRepository) {
    _loadInitialUser();
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _sessionService.isLoggedIn && _currentUser != null;
  bool get isLoading => _isLoading;
  String get savedEmail => _sessionService.savedEmail;
  bool get savedRememberMe => _sessionService.rememberMe;

  Future<void> _loadInitialUser() async {
    if (_sessionService.isLoggedIn) {
      final userId = _sessionService.currentUserId;
      if (userId != null) {
        _currentUser = await _userRepository.getUserById(userId);
        notifyListeners();
      }
    }
  }

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _userRepository.authenticate(email, password);
      if (user != null) {
        _currentUser = user;
        await _sessionService.saveLoginSession(
          userId: user.id,
          email: user.email,
          rememberMe: rememberMe,
        );
        _isLoading = false;
        notifyListeners();
        onSuccess();
      } else {
        _isLoading = false;
        notifyListeners();
        onError('Invalid email or password. Please try again.');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      onError('An error occurred during login. Please try again.');
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String role = 'Member',
    String department = 'Workspace',
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newUser = await _userRepository.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        department: department,
      );
      _currentUser = newUser;
      await _sessionService.saveLoginSession(
        userId: newUser.id,
        email: newUser.email,
        rememberMe: true,
      );
      _isLoading = false;
      notifyListeners();
      onSuccess();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      onError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> quickDemoLogin({required VoidCallback onSuccess}) async {
    final demo = await _userRepository.authenticate('alex.morgan@company.com', 'password123');
    if (demo != null) {
      _currentUser = demo;
      await _sessionService.saveLoginSession(
        userId: demo.id,
        email: demo.email,
        rememberMe: true,
      );
      notifyListeners();
      onSuccess();
    } else {
      // Fallback: register standard test user
      final registered = await _userRepository.register(
        fullName: 'Alex Morgan',
        email: 'alex.morgan@company.com',
        password: 'password123',
        role: 'Lead UX Designer',
        department: 'Core Team',
      );
      _currentUser = registered;
      await _sessionService.saveLoginSession(
        userId: registered.id,
        email: registered.email,
        rememberMe: true,
      );
      notifyListeners();
      onSuccess();
    }
  }

  Future<void> updateProfile({
    required String fullName,
    required String role,
    required String department,
  }) async {
    if (_currentUser == null) return;
    final updated = await _userRepository.updateUserProfile(
      id: _currentUser!.id,
      fullName: fullName,
      role: role,
      department: department,
    );
    _currentUser = updated;
    notifyListeners();
  }

  Future<void> logout() async {
    await _sessionService.clearSession();
    _currentUser = null;
    notifyListeners();
  }
}
