import '../../../shared/models/user_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_client.dart';
import '../../../core/services/token_storage.dart';
import '../../../core/services/error_handler.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final TokenStorage _tokenStorage = TokenStorage();

  /// Login with email and password.
  /// Backend returns token at top-level and user under data.
  Future<User> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        loginEndpoint,
        body: {
          'email': email,
          'password': password,
        },
      );

      final rawToken = response['token'] as String?;
      final rawUser = Map<String, dynamic>.from(response['data'] ?? {});
      final user = User.fromJson({
        ...rawUser,
        'token': ?rawToken,
      });

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

  /// Register a new user.
  Future<User> signup({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        signupEndpoint,
        body: {
          'username': username,
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'password': password,
        },
      );

      final rawToken = response['token'] as String?;
      final rawUser = Map<String, dynamic>.from(response['data'] ?? {});
      final user = User.fromJson({
        ...rawUser,
        'token': ?rawToken,
      });

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

  /// Get currently authenticated user profile.
  Future<User> getMe() async {
    try {
      final response = await _apiClient.get(getMeEndpoint);
      return User.fromJson(Map<String, dynamic>.from(response['data'] ?? {}));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Unable to fetch profile: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Update current user profile through /users/me.
  Future<User> updateProfile({
    String? username,
    String? email,
    String? profileUrl,
  }) async {
    try {
      final body = <String, dynamic>{};

      if (username != null) {
        final trimmed = username.trim();
        if (trimmed.isNotEmpty) {
          body['username'] = trimmed;
        }
      }

      if (email != null) {
        final trimmed = email.trim();
        if (trimmed.isNotEmpty) {
          body['email'] = trimmed;
        }
      }

      if (profileUrl != null) {
        final trimmed = profileUrl.trim();
        if (trimmed.isNotEmpty) {
          body['profileUrl'] = trimmed;
        }
      }

      if (body.isEmpty) {
        throw ApiException(
          message: 'No profile changes provided',
          statusCode: 400,
        );
      }

      final response = await _apiClient.put(
        updateUserProfileEndpoint,
        body: body,
      );

      final updatedUser = User.fromJson(
        Map<String, dynamic>.from(response['data'] ?? {}),
      );

      final existingToken = _tokenStorage.getToken();
      if (existingToken != null && existingToken.isNotEmpty) {
        await _tokenStorage.saveToken(
          token: existingToken,
          userId: updatedUser.id,
          email: updatedUser.email,
        );
      }

      return updatedUser;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Unable to update profile: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Ping user active endpoint for activity tracking.
  Future<void> updateLastActive() async {
    try {
      await _apiClient.patch(updateLastActiveEndpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Unable to update activity: ${e.toString()}',
        statusCode: 500,
      );
    }
  }

  /// Logout by calling backend endpoint and clearing local auth state.
  Future<void> logout() async {
    try {
      await _apiClient.post(logoutEndpoint);
    } catch (_) {
      // Local cleanup should still happen even if network/logout endpoint fails.
    } finally {
      await _tokenStorage.deleteToken();
    }
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
