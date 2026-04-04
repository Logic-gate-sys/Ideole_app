import 'package:flutter/material.dart';

/// Ideole Design System - Material 3 Color Palette
/// Based on warm earthy tones with burnt orange primary
class AppColors {
  // Primary Color System - Burnt Orange with warm tones
  static const Color primary = Color(0xFFC2652A); // Burnt orange
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color primaryContainer = Color(0xFFE08850); // Lighter orange
  static const Color onPrimaryContainer = Color(0xFFFBE8D8); // Very light cream

  // Primary Fixed (for badges, fixed backgrounds)
  static const Color primaryFixed = Color(0xFFFBE8D8);
  static const Color onPrimaryFixed = Color(0xFF401A08);
  static const Color primaryFixedDim = Color(0xFFF0A878);
  static const Color onPrimaryFixedVariant = Color(0xFF8A4518);

  // Secondary Color System - Warm gray-brown
  static const Color secondary = Color(0xFF78706A); // Warm gray-brown
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFEAE2DA);
  static const Color onSecondaryContainer = Color(0xFF605850);

  // Secondary Fixed
  static const Color secondaryFixed = Color(0xFFEAE2DA);
  static const Color onSecondaryFixed = Color(0xFF2A2420);
  static const Color secondaryFixedDim = Color(0xFFCEC6BE);
  static const Color onSecondaryFixedVariant = Color(0xFF504840);

  // Tertiary Color System - Deep rust red
  static const Color tertiary = Color(0xFF8C3C3C); // Deep rust
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFD47070); // Lighter rust
  static const Color onTertiaryContainer = Color(0xFF3A2020);

  // Tertiary Fixed
  static const Color tertiaryFixed = Color(0xFFFCE0E0);
  static const Color onTertiaryFixed = Color(0xFF2E1515);
  static const Color tertiaryFixedDim = Color(0xFFE8A0A0);
  static const Color onTertiaryFixedVariant = Color(0xFF6E3030);

  // Error Colors
  static const Color error = Color(0xFFC0392B); // Deep red
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFCE4E0);
  static const Color onErrorContainer = Color(0xFF7A1A10);

  // Neutral Colors - Surface & Background (warm linen palette)
  static const Color surface = Color(0xFFFAF5EE); // Off-white with warm tone
  static const Color onSurface = Color(0xFF3A302A); // Dark brown
  static const Color surfaceVariant = Color(0xFFECE6DC); // Light beige
  static const Color onSurfaceVariant = Color(0xFF605850); // Medium brown

  // Surface Containers (nested depth)
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceContainerLow = Color(0xFFF6F0E8); // Very light beige
  static const Color surfaceContainer = Color(0xFFF2ECE4); // Light beige
  static const Color surfaceContainerHigh = Color(0xFFECE6DC); // Medium beige
  static const Color surfaceContainerHighest = Color(0xFFE6E0D6); // Darker beige

  // Surface Brightness
  static const Color surfaceBright = Color(0xFFFAF5EE);
  static const Color surfaceDim = Color(0xFFDCD6CC);

  // Backgrounds
  static const Color background = Color(0xFFFAF5EE); // Same as surface
  static const Color onBackground = Color(0xFF3A302A);

  // Outline Colors
  static const Color outline = Color(0xFF9A9088); // Medium gray-brown
  static const Color outlineVariant = Color(0xFFD8D0C8); // Light gray-brown

  // Inverse (for floating elements)
  static const Color inverseSurface = Color(0xFF3A302A);
  static const Color inverseOnSurface = Color(0xFFFAF5EE);
  static const Color inversePrimary = Color(0xFFF0A878);

  // Surface Tint
  static const Color surfaceTint = Color(0xFFC2652A);

  // Additional semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  
  // Semantic color containers
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color onSuccessContainer = Color(0xFF065F46);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarningContainer = Color(0xFF78350F);
  static const Color infoContainer = Color(0xFFDEF7FF);
  static const Color onInfoContainer = Color(0xFF0C3D66);

  // Utility - Transparency variants
  static const Color scrimColor = Color(0x00000000);

  // Text Colors (convenience)
  static const Color textPrimary = onSurface;
  static const Color textSecondary = onSurfaceVariant;
  static const Color textTertiary = outline;
  static const Color textHint = outlineVariant;

  // Border Colors
  static const Color borderLight = outlineVariant;
  static const Color borderMedium = outline;
  static const Color borderDark = onSurfaceVariant;
}
