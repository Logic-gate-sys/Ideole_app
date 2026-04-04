import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

/// API Service - Centralized HTTP client
class ApiService {
  // Backend base URL - update for your environment
  // For Android Emulator: http://10.0.2.2:3000/api
  // For iOS Simulator: http://localhost:3000/api
  // For real device: http://<your-ip>:3000/api
  static const String baseUrl = 'http://10.0.2.2:3000/api';
  
  static const Duration timeout = Duration(seconds: 30);

  // Headers for requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Add authorization header
  static Map<String, String> _headersWithAuth(String token) {
    return {
      ..._headers,
      'Authorization': 'Bearer $token',
    };
  }

  /// Generic GET request
  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
    Map<String, String>? queryParams,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint').replace(
        queryParameters: queryParams,
      );
      
      final response = await http
          .get(
            uri,
            headers: token != null ? _headersWithAuth(token) : _headers,
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network error: No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    }
  }

  /// Generic POST request
  static Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: token != null ? _headersWithAuth(token) : _headers,
            body: jsonEncode(body),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network error: No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    }
  }

  /// Generic PUT request
  static Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    required String token,
  }) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headersWithAuth(token),
            body: jsonEncode(body),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network error: No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    }
  }

  /// Generic DELETE request
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    required String token,
  }) async {
    try {
      final response = await http
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: _headersWithAuth(token),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Network error: No internet connection');
    } on TimeoutException {
      throw Exception('Request timeout');
    }
  }

  /// Handle HTTP response and return data
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> jsonResponse = 
        jsonDecode(response.body) as Map<String, dynamic>;

    // Check if response indicates success
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonResponse;
    }

    // Handle error responses
    final errorMessage = jsonResponse['error'] as String? ?? 
        jsonResponse['message'] as String? ?? 
        'Unknown error occurred';

    switch (response.statusCode) {
      case 400:
        throw Exception('Validation error: $errorMessage');
      case 401:
        throw Exception('Unauthorized: Invalid credentials');
      case 403:
        throw Exception('Forbidden: You do not have permission');
      case 404:
        throw Exception('Not found: Resource does not exist');
      case 409:
        throw Exception('Conflict: $errorMessage');
      case 500:
        throw Exception('Server error: $errorMessage');
      default:
        throw Exception('Error: $errorMessage');
    }
  }
}
