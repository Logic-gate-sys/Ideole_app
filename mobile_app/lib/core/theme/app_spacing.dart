/// Ideole Design System - Spacing Constants
/// Centralized spacing values for consistent padding, margins, and gaps
class AppSpacing {
  // Micro spacing - smallest units
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 8;

  // Base spacing units
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;

  // Large spacing units
  static const double xxxl = 32;
  static const double huge = 48;
  static const double giant = 64;

  // Convenience groupings

  /// Compact spacing for dense layouts
  static const double compactPadding = xs;
  static const double compactGap = sm;

  /// Normal spacing for most UI elements
  static const double normalPadding = xl;
  static const double normalGap = lg;

  /// Spacious spacing for emphasis and breathing room
  static const double spaciousPadding = xxl;
  static const double spaciousGap = xl;

  /// Card and container padding
  static const double cardPaddingSmall = lg;
  static const double cardPaddingMedium = xl;
  static const double cardPaddingLarge = xxl;

  /// Common padding/margin combinations
  static const double screenPadding = xl; // Screen edges
  static const double sectionGap = xxl; // Between sections
  static const double elementGap = lg; // Between elements

  /// Inset spacing (for internal element spacing)
  static const double insetSmall = md;
  static const double insetMedium = lg;
  static const double insetLarge = xl;

  /// Bottom navigation / FAB bottom spacing
  static const double bottomNavSpacing = xxl;
  static const double fabHorizontalMargin = xl;
  static const double fabVerticalMargin = xl;

  /// Icon spacing
  static const double iconSmall = xs;
  static const double iconMedium = sm;
  static const double iconLarge = lg;

  /// List and grid spacing
  static const double verticalListSpacing = md;
  static const double horizontalListSpacing = lg;
  static const double gridSpacing = lg;
  static const double gridSpacingLarge = xl;
}
