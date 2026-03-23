import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    fontFamily: "Inter",
  );

  static ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.textPrimary,
    primaryColor: AppColors.primary,
    fontFamily: "Inter",
  );
}
