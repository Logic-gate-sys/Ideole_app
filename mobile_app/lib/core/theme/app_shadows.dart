import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Ideole Design System - Shadow & Elevation Constants
/// Material Design 3 compliant shadows for consistent depth
class AppShadows {
  // Shadow blur and spread values
  static const double _blur = 8;
  static const double _largeBlur = 16;

  // Elevation levels (Material 3)

  /// No elevation - flat design
  static const List<BoxShadow> elevation0 = [];

  /// Subtle shadow (for subtle depth)
  static List<BoxShadow> get elevation1 => [
    BoxShadow(
      color: AppColors.outline.withValues(alpha: 0.08),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  /// Light shadow (for cards, chips)
  static List<BoxShadow> get elevation2 => [
    BoxShadow(
      color: AppColors.outline.withValues(alpha: 0.1),
      blurRadius: _blur,
      offset: const Offset(0, 2),
    ),
  ];

  /// Medium shadow (for standard containers)
  static List<BoxShadow> get elevation3 => [
    BoxShadow(
      color: AppColors.outline.withValues(alpha: 0.12),
      blurRadius: _blur,
      offset: const Offset(0, 4),
    ),
  ];

  /// High shadow (for floating elements)
  static List<BoxShadow> get elevation4 => [
    BoxShadow(
      color: AppColors.outline.withValues(alpha: 0.14),
      blurRadius: _largeBlur,
      offset: const Offset(0, 6),
    ),
  ];

  /// Very high shadow (for modals, dialogs)
  static List<BoxShadow> get elevation5 => [
    BoxShadow(
      color: AppColors.outline.withValues(alpha: 0.16),
      blurRadius: _largeBlur,
      offset: const Offset(0, 8),
    ),
  ];

  // Semantic shadows (use-case based)

  /// Subtle card shadow
  static List<BoxShadow> get cardShadow => elevation2;

  /// FAB shadow (prominent floating action button)
  static List<BoxShadow> get fabShadow => elevation4;

  /// Dialog/Modal shadow
  static List<BoxShadow> get modalShadow => elevation5;

  /// Bottom sheet shadow
  static List<BoxShadow> get bottomSheetShadow => [
    BoxShadow(
      color: AppColors.outline.withValues(alpha: 0.12),
      blurRadius: _largeBlur,
      offset: const Offset(0, -4),
    ),
  ];

  /// Snackbar shadow
  static List<BoxShadow> get snackbarShadow => elevation4;

  /// Nnav bar shadow (bottom navigation)
  static List<BoxShadow> get navBarShadow => [
    BoxShadow(
      color: AppColors.outline.withValues(alpha: 0.1),
      blurRadius: _largeBlur,
      offset: const Offset(0, -2),
    ),
  ];

  /// App bar shadow
  static List<BoxShadow> get appBarShadow => elevation1;

  /// Hover/Interactive elevation
  static List<BoxShadow> get hoverShadow => elevation3;

  /// Focus state elevation
  static List<BoxShadow> get focusShadow => elevation3;

  /// Pressed/Active elevation
  static List<BoxShadow> get activeShadow => elevation2;

  /// Inset shadow (for sunken elements) - Note: Flutter doesn't support inset shadows natively
  /// This approximates an inset shadow using a soft shadow below
  static List<BoxShadow> get insetShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, -2),  // Negative offset to simulate inset
      spreadRadius: 1,
    ),
  ];

  // Color-specific shadows

  /// Primary accent shadow
  static List<BoxShadow> get primaryShadow => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.2),
      blurRadius: _blur,
      offset: const Offset(0, 4),
    ),
  ];

  /// Error/Alert shadow
  static List<BoxShadow> get errorShadow => [
    BoxShadow(
      color: AppColors.error.withValues(alpha: 0.15),
      blurRadius: _blur,
      offset: const Offset(0, 4),
    ),
  ];

  /// Success shadow
  static List<BoxShadow> get successShadow => [
    BoxShadow(
      color: AppColors.success.withValues(alpha: 0.15),
      blurRadius: _blur,
      offset: const Offset(0, 4),
    ),
  ];

  // Opacity variations for transitions

  /// Faded shadow (30% opacity)
  static List<BoxShadow> get shadowFaded => [
    BoxShadow(
      color: AppColors.outline.withValues(alpha: 0.03),
      blurRadius: _blur,
      offset: const Offset(0, 2),
    ),
  ];

  /// Emphasized shadow (high opacity)
  static List<BoxShadow> get shadowEmphasized => [
    BoxShadow(
      color: AppColors.outline.withValues(alpha: 0.25),
      blurRadius: _largeBlur,
      offset: const Offset(0, 12),
    ),
  ];
}
