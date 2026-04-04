import 'package:flutter/foundation.dart';
import '../../../models/auth.dart';
import '../../../models/user.dart';
import '../../../services/auth_service.dart';

/// Auth Controller - Manages authentication state using ChangeNotifier
class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // State variables
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  /// Initialize auth state (check if already logged in)
  Future<void> init() async {
    _user = _authService.getCurrentUser();
    _isAuthenticated = _authService.isAuthenticated();
    notifyListeners();
  }

  /// Register user
  Future<bool> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String firstName,
    required String lastName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authResponse = await _authService.register(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        firstName: firstName,
        lastName: lastName,
      );

      _user = authResponse.user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } on ValidationException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } on Exception catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Login user
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final authResponse = await _authService.login(
        email: email,
        password: password,
      );

      _user = authResponse.user;
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();

      return true;
    } on ValidationException catch (e) {
      _errorMessage = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    } on Exception catch (e) {
      _errorMessage = _parseErrorMessage(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.logout();
      _user = null;
      _isAuthenticated = false;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    try {
      await _authService.refreshToken();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Parse API error message for better UX
  String _parseErrorMessage(String error) {
    if (error.contains('Unauthorized')) {
      return 'Invalid email or password';
    }
    if (error.contains('Network error')) {
      return 'No internet connection. Check your network.';
    }
    if (error.contains('Request timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (error.contains('Conflict')) {
      return 'Email already registered. Please sign in instead.';
    }
    return error;
  }
}
