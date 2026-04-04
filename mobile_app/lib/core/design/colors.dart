import 'package:flutter/material.dart';

/// Ideole Sahara Design System Color Palette
/// A warm, earthy theme with terracotta and cream tones
class SaharaColors {
  // Primary Colors
  static const Color primary = Color(0xFFC2652A); // Warm terracotta
  static const Color onPrimary = Color(0xFFFFFFFF); // White text on primary
  static const Color primaryContainer = Color(0xFFE08850);
  static const Color onPrimaryContainer = Color(0xFFFBE8D8);

  // Secondary Colors
  static const Color secondary = Color(0xFF78706A); // Muted taupe
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFEAE2DA);
  static const Color onSecondaryContainer = Color(0xFF605850);

  // Tertiary Colors
  static const Color tertiary = Color(0xFF8C3C3C); // Deep rust
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFD47070);
  static const Color onTertiaryContainer = Color(0xFF3A2020);

  // Surface Colors
  static const Color surface = Color(0xFFFAF5EE); // Cream background
  static const Color onSurface = Color(0xFF3A302A); // Dark brown text
  static const Color surfaceVariant = Color(0xFFECE6DC);
  static const Color onSurfaceVariant = Color(0xFF605850);

  // Container Colors (backgrounds for cards, inputs)
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceContainerLow = Color(0xFFF6F0E8);
  static const Color surfaceContainer = Color(0xFFF2ECE4);
  static const Color surfaceContainerHigh = Color(0xFFECE6DC);
  static const Color surfaceContainerHighest = Color(0xFFE6E0D6);

  // Error Colors
  static const Color error = Color(0xFFC0392B);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFCE4E0);
  static const Color onErrorContainer = Color(0xFF7A1A10);

  // Outline & Dividers
  static const Color outline = Color(0xFF9A9088);
  static const Color outlineVariant = Color(0xFFD8D0C8);

  // Disabled & Inactive
  static const Color surfaceDim = Color(0xFFDCD6CC);

  // Inverse (for elevation/overlays)
  static const Color inverseSurface = Color(0xFF3A302A);
  static const Color inverseOnSurface = Color(0xFFFAF5EE);
  static const Color inversePrimary = Color(0xFFF0A878);

  // Neutral (for text hierarchy)
  static const Color divider = outlineVariant;
  static const Color background = surface;
  static const Color onBackground = onSurface;

  // Fixed Colors (accent highlights)
  static const Color primaryFixed = Color(0xFFFBE8D8);
  static const Color primaryFixedDim = Color(0xFFF0A878);
  static const Color onPrimaryFixed = Color(0xFF401A08);
  static const Color onPrimaryFixedVariant = Color(0xFF8A4518);

  static const Color secondaryFixed = Color(0xFFEAE2DA);
  static const Color secondaryFixedDim = Color(0xFFCEC6BE);
  static const Color onSecondaryFixed = Color(0xFF2A2420);
  static const Color onSecondaryFixedVariant = Color(0xFF504840);

  static const Color tertiaryFixed = Color(0xFFFCE0E0);
  static const Color tertiaryFixedDim = Color(0xFFE8A0A0);
  static const Color onTertiaryFixed = Color(0xFF2E1515);
  static const Color onTertiaryFixedVariant = Color(0xFF6E3030);
}
