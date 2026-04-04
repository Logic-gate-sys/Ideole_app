import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'dart:convert';

/// Storage Service - Manages persistent local storage
class StorageService {
  static final StorageService _instance = StorageService._internal();
  late SharedPreferences _prefs;

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUser = 'user_data';
  static const String _keyUserId = 'user_id';

  StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  /// Initialize storage service (must be called before use)
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save authentication tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _prefs.setString(_keyAccessToken, accessToken),
      _prefs.setString(_keyRefreshToken, refreshToken),
    ]);
  }

  /// Get access token
  String? getAccessToken() => _prefs.getString(_keyAccessToken);

  /// Get refresh token
  String? getRefreshToken() => _prefs.getString(_keyRefreshToken);

  /// Save user data
  Future<void> saveUser(User user) async {
    final userJson = jsonEncode(user.toJson());
    await Future.wait([
      _prefs.setString(_keyUser, userJson),
      _prefs.setString(_keyUserId, user.id),
    ]);
  }

  /// Get cached user data
  User? getCachedUser() {
    final userJson = _prefs.getString(_keyUser);
    if (userJson == null) return null;
    try {
      return User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Get cached user ID
  String? getUserId() => _prefs.getString(_keyUserId);

  /// Check if user is authenticated (has tokens)
  bool isAuthenticated() {
    return getAccessToken() != null && getRefreshToken() != null;
  }

  /// Clear all authentication data
  Future<void> clearAuth() async {
    await Future.wait([
      _prefs.remove(_keyAccessToken),
      _prefs.remove(_keyRefreshToken),
      _prefs.remove(_keyUser),
      _prefs.remove(_keyUserId),
    ]);
  }

  /// Clear all app data (for account deletion)
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
