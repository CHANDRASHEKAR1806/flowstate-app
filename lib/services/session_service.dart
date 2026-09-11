import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keySavedEmail = 'saved_email';
  static const String _keyRememberMe = 'remember_me';

  // App preferences
  static const String _keyIsDarkTheme = 'is_dark_theme';
  static const String _keyPushNotifications = 'push_notifications';
  static const String _keyDailyDigest = 'daily_digest';
  static const String _keySoundHaptics = 'sound_haptics';
  static const String _keyBiometricLock = 'biometric_lock';

  final SharedPreferences _prefs;

  SessionService(this._prefs);

  bool get isLoggedIn => _prefs.getBool(_keyIsLoggedIn) ?? false;
  int? get currentUserId => _prefs.getInt(_keyUserId);
  String get savedEmail => _prefs.getString(_keySavedEmail) ?? '';
  bool get rememberMe => _prefs.getBool(_keyRememberMe) ?? false;

  bool get isDarkTheme => _prefs.getBool(_keyIsDarkTheme) ?? false;
  bool get pushNotifications => _prefs.getBool(_keyPushNotifications) ?? true;
  bool get dailyDigest => _prefs.getBool(_keyDailyDigest) ?? true;
  bool get soundHaptics => _prefs.getBool(_keySoundHaptics) ?? true;
  bool get biometricLock => _prefs.getBool(_keyBiometricLock) ?? false;

  Future<void> saveLoginSession({
    required int userId,
    required String email,
    required bool rememberMe,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setInt(_keyUserId, userId);
    await _prefs.setBool(_keyRememberMe, rememberMe);
    if (rememberMe) {
      await _prefs.setString(_keySavedEmail, email);
    } else {
      await _prefs.remove(_keySavedEmail);
    }
  }

  Future<void> clearSession() async {
    await _prefs.setBool(_keyIsLoggedIn, false);
    await _prefs.remove(_keyUserId);
    if (!rememberMe) {
      await _prefs.remove(_keySavedEmail);
    }
  }

  Future<void> setDarkTheme(bool value) => _prefs.setBool(_keyIsDarkTheme, value);
  Future<void> setPushNotifications(bool value) => _prefs.setBool(_keyPushNotifications, value);
  Future<void> setDailyDigest(bool value) => _prefs.setBool(_keyDailyDigest, value);
  Future<void> setSoundHaptics(bool value) => _prefs.setBool(_keySoundHaptics, value);
  Future<void> setBiometricLock(bool value) => _prefs.setBool(_keyBiometricLock, value);
}
