import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../../../shared/models/user_model.dart';
import '../../../core/services/error_handler.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? currentUser;
  bool isAuthenticated = false;
  bool isLoading = false;
  String? error;

  Future<void> initialize() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final loggedIn = await _authService.isLoggedIn();
      if (!loggedIn) {
        currentUser = null;
        isAuthenticated = false;
        return;
      }

      currentUser = await _authService.getMe();
      isAuthenticated = true;
      try {
        await _authService.updateLastActive();
      } catch (_) {
        // Ignore activity update failures to avoid blocking startup flow.
      }
    } catch (_) {
      currentUser = null;
      isAuthenticated = false;
      await _authService.logout();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      currentUser = user;
      isAuthenticated = true;
      try {
        await _authService.updateLastActive();
      } catch (_) {
        // Ignore activity update failures on login.
      }
      return user;
    } catch (e) {
      error = e.toString();
      currentUser = null;
      isAuthenticated = false;
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> refreshCurrentUser() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final refreshedUser = await _authService.getMe();
      currentUser = refreshedUser.copyWith(token: currentUser?.token);
      return true;
    } on ApiException catch (e) {
      error = e.message;
      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String username,
    required String email,
    String? profileUrl,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final updatedUser = await _authService.updateProfile(
        username: username,
        email: email,
        profileUrl: profileUrl,
      );

      currentUser = updatedUser.copyWith(token: currentUser?.token);
      return true;
    } on ApiException catch (e) {
      error = e.message;
      return false;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> signup({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = await _authService.signup(
        username: username,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      currentUser = user;
      isAuthenticated = true;
      return user;
    } catch (e) {
      error = e.toString();
      currentUser = null;
      isAuthenticated = false;
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _authService.logout();
      currentUser = null;
      isAuthenticated = false;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
