import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage service
/// Handles storing and retrieving authentication tokens
class TokenStorage {
  static const String _sessionNamespace = 'secure_sessions';
  static const String _tokenKey = '$_sessionNamespace.auth_token';
  static const String _userIdKey = '$_sessionNamespace.user_id';
  static const String _emailKey = '$_sessionNamespace.user_email';

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static final TokenStorage _instance = TokenStorage._internal();
  String? _token;
  String? _userId;
  String? _email;

  factory TokenStorage() {
    return _instance;
  }

  TokenStorage._internal();

  /// Initialize the storage (call this once at app startup)
  Future<void> init() async {
    final values = await Future.wait([
      _secureStorage.read(key: _tokenKey),
      _secureStorage.read(key: _userIdKey),
      _secureStorage.read(key: _emailKey),
    ]);

    _token = values[0];
    _userId = values[1];
    _email = values[2];
  }

  /// Save authentication token and user info
  Future<void> saveToken({
    required String token,
    required String userId,
    required String email,
  }) async {
    try {
      await Future.wait([
        _secureStorage.write(key: _tokenKey, value: token),
        _secureStorage.write(key: _userIdKey, value: userId),
        _secureStorage.write(key: _emailKey, value: email),
      ]);

      _token = token;
      _userId = userId;
      _email = email;
    } catch (e) {
      throw Exception('Failed to save token: $e');
    }
  }

  /// Get stored token
  String? getToken() {
    return _token;
  }

  /// Get stored user ID
  String? getUserId() {
    return _userId;
  }

  /// Get stored email
  String? getEmail() {
    return _email;
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
        _secureStorage.delete(key: _tokenKey),
        _secureStorage.delete(key: _userIdKey),
        _secureStorage.delete(key: _emailKey),
      ]);

      _token = null;
      _userId = null;
      _email = null;
    } catch (e) {
      throw Exception('Failed to clear token: $e');
    }
  }
}
