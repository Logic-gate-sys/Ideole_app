import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemePreference { system, light, dark }

class ThemeController extends ChangeNotifier {
  static const String _themePreferenceKey = 'theme_preference';

  AppThemePreference _preference = AppThemePreference.system;
  bool _notificationScheduled = false;

  AppThemePreference get preference => _preference;

  ThemeMode get themeMode {
    switch (_preference) {
      case AppThemePreference.system:
        return ThemeMode.system;
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
    }
  }

  String get preferenceLabel {
    switch (_preference) {
      case AppThemePreference.system:
        return 'System';
      case AppThemePreference.light:
        return 'Light';
      case AppThemePreference.dark:
        return 'Dark';
    }
  }

  Future<void> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final rawValue = prefs.getString(_themePreferenceKey);
    final parsedPreference = _parsePreference(rawValue);
    if (_preference == parsedPreference) {
      return;
    }

    _preference = parsedPreference;
    _notifyListenersSafely();
  }

  Future<void> setPreference(AppThemePreference nextPreference) async {
    if (_preference == nextPreference) {
      return;
    }

    _preference = nextPreference;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, nextPreference.name);
    _notifyListenersSafely();
  }

  AppThemePreference _parsePreference(String? rawValue) {
    switch (rawValue) {
      case 'light':
        return AppThemePreference.light;
      case 'dark':
        return AppThemePreference.dark;
      case 'system':
      default:
        return AppThemePreference.system;
    }
  }

  void _notifyListenersSafely() {
    if (!hasListeners) {
      return;
    }

    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks) {
      notifyListeners();
      return;
    }

    if (_notificationScheduled) {
      return;
    }

    _notificationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationScheduled = false;
      if (hasListeners) {
        notifyListeners();
      }
    });
  }
}
