import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../../../shared/models/user_model.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? error;

  Future<User?> login(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = await _authService.login(email, password);
      return user;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> signup(String name, String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final user = await _authService.signup(name, email, password);
      return user;
    } catch (e) {
      error = e.toString();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
