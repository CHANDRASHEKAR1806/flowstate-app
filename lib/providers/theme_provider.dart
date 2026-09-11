import 'package:flutter/material.dart';
import '../services/session_service.dart';

class ThemeProvider extends ChangeNotifier {
  final SessionService _sessionService;

  late bool _isDarkTheme;
  late bool _pushNotifications;
  late bool _dailyDigest;
  late bool _soundHaptics;
  late bool _biometricLock;

  ThemeProvider(this._sessionService) {
    _isDarkTheme = _sessionService.isDarkTheme;
    _pushNotifications = _sessionService.pushNotifications;
    _dailyDigest = _sessionService.dailyDigest;
    _soundHaptics = _sessionService.soundHaptics;
    _biometricLock = _sessionService.biometricLock;
  }

  bool get isDarkTheme => _isDarkTheme;
  ThemeMode get themeMode => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;
  bool get pushNotifications => _pushNotifications;
  bool get dailyDigest => _dailyDigest;
  bool get soundHaptics => _soundHaptics;
  bool get biometricLock => _biometricLock;

  void toggleDarkTheme(bool value) {
    _isDarkTheme = value;
    _sessionService.setDarkTheme(value);
    notifyListeners();
  }

  void togglePushNotifications(bool value) {
    _pushNotifications = value;
    _sessionService.setPushNotifications(value);
    notifyListeners();
  }

  void toggleDailyDigest(bool value) {
    _dailyDigest = value;
    _sessionService.setDailyDigest(value);
    notifyListeners();
  }

  void toggleSoundHaptics(bool value) {
    _soundHaptics = value;
    _sessionService.setSoundHaptics(value);
    notifyListeners();
  }

  void toggleBiometricLock(bool value) {
    _biometricLock = value;
    _sessionService.setBiometricLock(value);
    notifyListeners();
  }
}
