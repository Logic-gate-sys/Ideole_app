import 'api_service.dart';
import 'storage_service.dart';
import '../models/auth.dart';
import '../models/user.dart';

/// Authentication Service - Handles auth API calls
class AuthService {
  final StorageService _storageService = StorageService();

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  /// Validate password strength (at least 6 characters, 1 uppercase, 1 number)
  bool _isValidPassword(String password) {
    return password.length >= 6 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password);
  }

  /// Register new user
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
    String? username,
  }) async {
    // Client-side validation
    if (email.isEmpty) {
      throw ValidationException('Email is required');
    }
    if (!_isValidEmail(email)) {
      throw ValidationException('Invalid email format');
    }
    if (password.isEmpty) {
      throw ValidationException('Password is required');
    }
    if (password.length < 8) {
      throw ValidationException('Password must be at least 8 characters');
    }
    if (!_isValidPassword(password)) {
      throw ValidationException(
        'Password must contain 1 uppercase letter and 1 number',
      );
    }
    if (password != confirmPassword) {
      throw ValidationException('Passwords do not match');
    }
    if (firstName.isEmpty) {
      throw ValidationException('First name is required');
    }
    if (lastName.isEmpty) {
      throw ValidationException('Last name is required');
    }

    // Generate username from email if not provided
    final finalUsername = username ?? email.split('@')[0];
    if (finalUsername.length < 3) {
      throw ValidationException('Username must be at least 3 characters');
    }

    try {
      final response = await ApiService.post(
        '/auth/register',
        body: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'username': finalUsername,
        },
      );

      final authResponse = AuthResponse.fromJson(response);
      
      // Save tokens and user data
      await _storageService.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      await _storageService.saveUser(authResponse.user);

      return authResponse;
    } on Exception {
      rethrow;
    }
  }

  /// Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    // Client-side validation
    if (email.isEmpty) {
      throw ValidationException('Email is required');
    }
    if (!_isValidEmail(email)) {
      throw ValidationException('Invalid email format');
    }
    if (password.isEmpty) {
      throw ValidationException('Password is required');
    }

    try {
      final response = await ApiService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponse.fromJson(response);
      
      // Save tokens and user data
      await _storageService.saveTokens(
        accessToken: authResponse.accessToken,
        refreshToken: authResponse.refreshToken,
      );
      await _storageService.saveUser(authResponse.user);

      return authResponse;
    } on Exception {
      rethrow;
    }
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    final refreshToken = _storageService.getRefreshToken();
    
    if (refreshToken == null) {
      throw AuthException('No refresh token available', code: 'NO_REFRESH_TOKEN');
    }

    try {
      final response = await ApiService.post(
        '/auth/refresh',
        body: {'refreshToken': refreshToken},
      );

      // Response format: { success: true, data: user, token: accessToken }
      final newAccessToken = response['token'] as String;

      await _storageService.saveTokens(
        accessToken: newAccessToken,
        refreshToken: refreshToken,
      );
    } on Exception {
      // If refresh fails, clear auth data
      await _storageService.clearAuth();
      rethrow;
    }
  }

  /// Logout user
  Future<void> logout() async {
    final accessToken = _storageService.getAccessToken();

    try {
      if (accessToken != null) {
        // Call logout endpoint
        await ApiService.post(
          '/auth/logout',
          body: {},
          token: accessToken,
        );
      }
    } catch (e) {
      // Continue logout even if API call fails
      print('Logout API error: $e');
    } finally {
      // Clear local auth data
      await _storageService.clearAuth();
    }
  }

  /// Get current user from storage
  User? getCurrentUser() {
    return _storageService.getCachedUser();
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _storageService.isAuthenticated();
  }

  /// Get access token
  String? getAccessToken() {
    return _storageService.getAccessToken();
  }
}
