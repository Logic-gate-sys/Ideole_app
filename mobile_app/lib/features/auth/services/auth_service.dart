import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/models/user_model.dart';
import '../../../core/constants/api_constants.dart';

class AuthService {
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<User> signup(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse(signupEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to signup');
    }
  }
}
