import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Ideole Typography System
/// Uses Eb Garamond (serif, italic) for headlines
/// Uses Manrope (sans-serif) for body and labels
class AppTextStyles {
  // Font families
  static const String headlineFont = 'EbGaramond';
  static const String bodyFont = 'Manrope';
  static const String labelFont = 'Manrope';

  // Display Styles (Large titles, hero text)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: headlineFont,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 1.1,
    letterSpacing: -0.25,
    color: AppColors.onSurface,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: headlineFont,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 1.15,
    letterSpacing: 0,
    color: AppColors.onSurface,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: headlineFont,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 1.22,
    letterSpacing: 0,
    color: AppColors.onSurface,
    fontStyle: FontStyle.italic,
  );

  // Headline Styles
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: headlineFont,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.15,
    color: AppColors.onSurface,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: headlineFont,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: 0,
    color: AppColors.onSurface,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: headlineFont,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.onSurface,
    fontStyle: FontStyle.italic,
  );

  // Title Styles
  static const TextStyle titleLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 22,
    fontWeight: FontWeight.w500,
    height: 1.27,
    letterSpacing: 0,
    color: AppColors.onSurface,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.15,
    color: AppColors.onSurface,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  // Body Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: bodyFont,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: bodyFont,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0.25,
    color: AppColors.onSurface,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: bodyFont,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.4,
    color: AppColors.onSurfaceVariant,
  );

  // Label Styles
  static const TextStyle labelLarge = TextStyle(
    fontFamily: labelFont,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
    letterSpacing: 0.1,
    color: AppColors.onSurface,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: labelFont,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: labelFont,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.45,
    letterSpacing: 0.5,
    color: AppColors.onSurface,
  );

  // Convenience styles
  static const TextStyle heading1 = displayLarge;
  static const TextStyle heading2 = headlineLarge;
  static const TextStyle heading3 = headlineMedium;
  static const TextStyle heading4 = headlineSmall;

  static const TextStyle body = bodyLarge;
  static const TextStyle bodySmallText = bodySmall;

  static const TextStyle caption = labelSmall;
  static const TextStyle tag = labelMedium;

  // Text variants
  static TextStyle italic(TextStyle style) =>
      style.copyWith(fontStyle: FontStyle.italic);

  static TextStyle bold(TextStyle style) =>
      style.copyWith(fontWeight: FontWeight.bold);

  static TextStyle colored(TextStyle style, Color color) =>
      style.copyWith(color: color);
}
