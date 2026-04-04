/// Environment configuration for the app
/// Supports multiple environments: dev, staging, production
library;

import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

enum AppEnv {
  dev,
  staging,
  production,
}

class Environment {
  static const AppEnv appEnv = AppEnv.dev; // Change this for deployment

  /// Base URL for API endpoints
  static String get baseUrl {
    switch (appEnv) {
      case AppEnv.dev:
        // For local development:
        // - Android emulator: 10.0.2.2 (routes to host)
        // - iOS simulator: localhost
        // - Physical device: use actual machine IP
        if (kIsWeb) {
          return 'http://localhost:3000/api';
        } else if (Platform.isAndroid) {
          return 'http://10.0.2.2:3000/api'; // Android emulator
        } else {
          return 'http://localhost:3000/api'; // iOS simulator
        }
      case AppEnv.staging:
        return 'https://staging-api.ideole.com/api';
      case AppEnv.production:
        return 'https://api.ideole.com/api';
    }
  }

  /// Enable debug logging
  static bool get isDebug {
    return appEnv == AppEnv.dev;
  }

  /// API request timeout in seconds
  static const int apiTimeout = 30;

  /// Whether to use Mock API (for testing)
  static const bool useMockAPI = false;
}
