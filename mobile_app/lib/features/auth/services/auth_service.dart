import '../../../shared/models/user_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/services/error_handler.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final TokenStorage _tokenStorage = TokenStorage();

  /// Login with email and password
  /// Returns User object with auth token
  /// Throws ApiException on error
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        loginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
      );

      // Backend response format: { success: true, data: { id, name, email, token, ... } }
      final user = User.fromJson(response['data']);

      // Save token for future requests
      if (user.token != null && user.token!.isNotEmpty) {
        await _tokenStorage.saveToken(
          token: user.token!,
          userId: user.id,
          email: user.email,
        );
      }

      return user;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Login failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Sign up with name, email, and password
  /// Returns User object with auth token
  /// Throws ApiException on error
  Future<User> signup(String name, String email, String password) async {
    try {
      final response = await _apiClient.post(
        signupEndpoint,
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      // Backend response format: { success: true, data: { id, name, email, token, ... } }
      final user = User.fromJson(response['data']);

      // Save token for future requests
      if (user.token != null && user.token!.isNotEmpty) {
        await _tokenStorage.saveToken(
          token: user.token!,
          userId: user.id,
          email: user.email,
        );
      }

      return user;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Signup failed: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Logout by clearing stored token
  Future<void> logout() async {
    await _tokenStorage.deleteToken();
  }

  /// Check if user has valid stored token
  Future<bool> isLoggedIn() async {
    return await _tokenStorage.isTokenValid();
  }

  /// Get stored token
  Future<String?> getAuthToken() async {
    return Future.value(_tokenStorage.getToken());
  }
}
