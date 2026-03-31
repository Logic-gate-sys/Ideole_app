import 'package:shared_preferences/shared_preferences.dart';

/// Secure token storage service
/// Handles storing and retrieving authentication tokens
class TokenStorage {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _emailKey = 'user_email';

  static final TokenStorage _instance = TokenStorage._internal();
  late SharedPreferences _prefs;

  factory TokenStorage() {
    return _instance;
  }

  TokenStorage._internal();

  /// Initialize the storage (call this once at app startup)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save authentication token and user info
  Future<void> saveToken({
    required String token,
    required String userId,
    required String email,
  }) async {
    try {
      await Future.wait([
        _prefs.setString(_tokenKey, token),
        _prefs.setString(_userIdKey, userId),
        _prefs.setString(_emailKey, email),
      ]);
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  /// Get stored token
  String? getToken() {
    try {
      return _prefs.getString(_tokenKey);
    } catch (e) {
      return null;
    }
  }

  /// Get stored user ID
  String? getUserId() {
    try {
      return _prefs.getString(_userIdKey);
    } catch (e) {
      return null;
    }
  }

  /// Get stored email
  String? getEmail() {
    try {
      return _prefs.getString(_emailKey);
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return getToken() != null && getToken()!.isNotEmpty;
  }

  /// Check if token is valid (async version for compatibility)
  Future<bool> isTokenValid() async {
    return isAuthenticated();
  }

  /// Delete token (alias for clear)
  Future<void> deleteToken() async {
    await clear();
  }

  /// Clear all stored data (logout)
  Future<void> clear() async {
    try {
      await Future.wait([
        _prefs.remove(_tokenKey),
        _prefs.remove(_userIdKey),
        _prefs.remove(_emailKey),
      ]);
    } catch (e) {
      throw Exception('Failed to clear token: $e');
    }
  }
}
