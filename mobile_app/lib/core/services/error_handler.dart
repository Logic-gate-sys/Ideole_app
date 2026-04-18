import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../core/config/environment.dart';

/// API Error model matching backend error format
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errorDetails;
  final String? path;
  final DateTime? timestamp;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorDetails,
    this.path,
    this.timestamp,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';

  /// User-friendly error message
  String getUserMessage() {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Your session has expired. Please login again.';
      case 403:
        return 'You do not have permission to perform this action.';
      case 404:
        return 'The requested resource was not found.';
      case 409:
        return 'This resource already exists.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service is temporarily unavailable.';
      default:
        return message;
    }
  }

  /// Check if error is authentication-related
  bool isAuthError() => statusCode == 401;

  /// Check if error is permission-related
  bool isPermissionError() => statusCode == 403;

  /// Check if error is validation-related
  bool isValidationError() => statusCode == 400;
}

/// HTTP Response handler and error parser
class ResponseHandler {
  /// Handle HTTP response and throw appropriate exceptions
  static dynamic handleResponse(
    http.Response response,
    String endpoint,
  ) {
    if (Environment.isDebug) {
      debugLog('Response [$endpoint]: ${response.statusCode}');
      debugLog('Body: ${response.body}');
    }

    // Success responses (2xx)
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        return {'success': true};
      }
      return jsonDecode(response.body);
    }

    // Parse error response
    Map<String, dynamic> errorBody = {};
    try {
      if (response.body.isNotEmpty) {
        errorBody = jsonDecode(response.body);
      }
    } catch (_) {
      // If body is not JSON, use raw body as message
      errorBody = {'error': response.body};
    }

    final errorMessage = errorBody['error'] ?? 'An error occurred';
    final errorDetails = errorBody['details'];

    throw ApiException(
      message: errorMessage is String ? errorMessage : 'An error occurred',
      statusCode: response.statusCode,
      errorDetails: errorDetails is Map ? Map<String, dynamic>.from(errorDetails) : null,
      path: endpoint,
      timestamp: DateTime.now(),
    );
  }

  /// Handle network and parsing exceptions
  static ApiException handleException(Object error, String endpoint) {
    if (Environment.isDebug) {
      debugLog('Error [$endpoint]: $error');
    }

    if (error is ApiException) {
      return error;
    }

    return ApiException(
      message: error.toString(),
      statusCode: null,
      path: endpoint,
      timestamp: DateTime.now(),
    );
  }
}

/// Debug logging utility
void debugLog(String message) {
  if (Environment.isDebug) {
    debugPrint('[Ideole API] $message');
  }
}
