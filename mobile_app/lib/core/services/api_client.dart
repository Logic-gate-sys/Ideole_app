import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/config/environment.dart';
import 'error_handler.dart';
import 'token_storage.dart';

/// Centralized HTTP client for all API requests
/// Handles authentication, error handling, logging, and retries
class ApiClient {
  final TokenStorage _tokenStorage;
  late http.Client _client;

  ApiClient({TokenStorage? tokenStorage}) : _tokenStorage = tokenStorage ?? TokenStorage() {
    _client = http.Client();
  }

  /// Get default headers with authentication
  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add auth token if available
    final token = _tokenStorage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Construct full URL from endpoint
  String _buildUrl(String endpoint) {
    String cleanEndpoint = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '${Environment.baseUrl}$cleanEndpoint';
  }

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final url = _buildUrl(endpoint);
      final uri = Uri.parse(url);
      
      // Add query parameters if provided
      final finalUri = queryParams != null && queryParams.isNotEmpty
          ? uri.replace(queryParameters: _convertParamsToStrings(queryParams))
          : uri;

      if (Environment.isDebug) {
        debugLog('GET $finalUri');
      }

      final response = await _client.get(
        finalUri,
        headers: _getHeaders(),
      ).timeout(
        Duration(seconds: Environment.apiTimeout),
        onTimeout: () => throw ApiException(
          message: 'Request timeout',
          statusCode: null,
          path: endpoint,
        ),
      );

      return ResponseHandler.handleResponse(response, endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ResponseHandler.handleException(e, endpoint);
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = _buildUrl(endpoint);

      if (Environment.isDebug) {
        debugLog('POST $url');
        debugLog('Body: $body');
      }

      final response = await _client.post(
        Uri.parse(url),
        headers: _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(
        Duration(seconds: Environment.apiTimeout),
        onTimeout: () => throw ApiException(
          message: 'Request timeout',
          statusCode: null,
          path: endpoint,
        ),
      );

      return ResponseHandler.handleResponse(response, endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ResponseHandler.handleException(e, endpoint);
    }
  }

  /// PATCH request
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = _buildUrl(endpoint);

      if (Environment.isDebug) {
        debugLog('PATCH $url');
        debugLog('Body: $body');
      }

      final response = await _client.patch(
        Uri.parse(url),
        headers: _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(
        Duration(seconds: Environment.apiTimeout),
        onTimeout: () => throw ApiException(
          message: 'Request timeout',
          statusCode: null,
          path: endpoint,
        ),
      );

      return ResponseHandler.handleResponse(response, endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ResponseHandler.handleException(e, endpoint);
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    try {
      final url = _buildUrl(endpoint);

      if (Environment.isDebug) {
        debugLog('PUT $url');
        debugLog('Body: $body');
      }

      final response = await _client.put(
        Uri.parse(url),
        headers: _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      ).timeout(
        Duration(seconds: Environment.apiTimeout),
        onTimeout: () => throw ApiException(
          message: 'Request timeout',
          statusCode: null,
          path: endpoint,
        ),
      );

      return ResponseHandler.handleResponse(response, endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ResponseHandler.handleException(e, endpoint);
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final url = _buildUrl(endpoint);

      if (Environment.isDebug) {
        debugLog('DELETE $url');
      }

      final response = await _client.delete(
        Uri.parse(url),
        headers: _getHeaders(),
      ).timeout(
        Duration(seconds: Environment.apiTimeout),
        onTimeout: () => throw ApiException(
          message: 'Request timeout',
          statusCode: null,
          path: endpoint,
        ),
      );

      return ResponseHandler.handleResponse(response, endpoint);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ResponseHandler.handleException(e, endpoint);
    }
  }

  /// Convert query parameters to string values for Uri
  Map<String, String> _convertParamsToStrings(Map<String, dynamic> params) {
    return params.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  /// Dispose HTTP client
  void dispose() {
    _client.close();
  }
}
