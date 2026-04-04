import 'package:flutter/material.dart';
import 'colors.dart';

/// Ideole Sahara Design System Typography
/// Using Eb Garamond (serif) for headlines and Manrope (sans-serif) for body
class SaharaTypography {
  // Headline Styles (Eb Garamond, serif, often italic)
  static final TextStyle displayLarge = TextStyle(
    fontFamily: 'EbGaramond',
    fontSize: 56,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
    color: SaharaColors.onSurface,
  );

  static final TextStyle displayMedium = TextStyle(
    fontFamily: 'EbGaramond',
    fontSize: 40,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.2,
    color: SaharaColors.onSurface,
  );

  static final TextStyle displaySmall = TextStyle(
    fontFamily: 'EbGaramond',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.2,
    color: SaharaColors.onSurface,
  );

  static final TextStyle headlineLarge = TextStyle(
    fontFamily: 'EbGaramond',
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: SaharaColors.onSurface,
  );

  static final TextStyle headlineMedium = TextStyle(
    fontFamily: 'EbGaramond',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
    color: SaharaColors.onSurface,
  );

  static final TextStyle headlineSmall = TextStyle(
    fontFamily: 'EbGaramond',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
    color: SaharaColors.onSurface,
  );

  // Italic Headlines (design emphasis)
  static final TextStyle headlineLargeItalic = headlineLarge.copyWith(
    fontStyle: FontStyle.italic,
  );

  static final TextStyle headlineMediumItalic = headlineMedium.copyWith(
    fontStyle: FontStyle.italic,
  );

  static final TextStyle displayLargeItalic = displayLarge.copyWith(
    fontStyle: FontStyle.italic,
  );

  // Title Styles (Manrope, sans-serif, strong)
  static final TextStyle titleLarge = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.15,
    height: 1.4,
    color: SaharaColors.onSurface,
  );

  static final TextStyle titleMedium = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.15,
    height: 1.4,
    color: SaharaColors.onSurface,
  );

  static final TextStyle titleSmall = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 1.4,
    color: SaharaColors.onSurface,
  );

  // Body Styles (Manrope, standard text)
  static final TextStyle bodyLarge = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5,
    color: SaharaColors.onSurface,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.5,
    color: SaharaColors.onSurface,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.4,
    color: SaharaColors.onSurface,
  );

  // Label Styles (Manrope, uppercase tracking)
  static final TextStyle labelLarge = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.4,
    color: SaharaColors.onSurface,
  );

  static final TextStyle labelMedium = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.15,
    height: 1.3,
    color: SaharaColors.onSurface,
  );

  static final TextStyle labelSmall = TextStyle(
    fontFamily: 'Manrope',
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    height: 1.2,
    color: SaharaColors.onSurface,
  );

  // Helper methods
  static TextStyle bodyLargeItalic() => bodyLarge.copyWith(
    fontStyle: FontStyle.italic,
  );
}
