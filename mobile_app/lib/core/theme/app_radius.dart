import 'package:flutter/material.dart';

/// Ideole Design System - Border Radius Constants
/// Consistent corner radius for Material 3 design
class AppRadius {
  // Base radius values
  static const double xs = 2;
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double xxl = 24;
  static const double full = 9999; // Fully rounded (pills, circles)

  // BorderRadius objects for convenience

  /// Extra small - for tags, badges, input borders
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));

  /// Small - for small containers, chips
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));

  /// Medium - standard for most containers
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));

  /// Large - for cards, dialogs
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));

  /// Extra large - for large containers, bottom sheets
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(xl));

  /// 2X large - for hero sections
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xxl));

  /// Fully rounded - for pills, circular buttons, avatars
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(full));

  // Specific use-case border radius

  /// Button radius (Material 3 standard)
  static const BorderRadius buttonRadius = radiusMd;

  /// Card radius
  static const BorderRadius cardRadius = radiusLg;

  /// Dialog/Modal radius
  static const BorderRadius dialogRadius = radiusXl;

  /// Bottom sheet radius (top corners only)
  static const BorderRadius bottomSheetRadius = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );

  /// Chip/Badge radius
  static const BorderRadius chipRadius = radiusXs;

  /// Input field radius
  static const BorderRadius inputRadius = radiusMd;

  /// Snackbar radius
  static const BorderRadius snackbarRadius = radiusMd;

  /// FAB radius (rounded rectangle)
  static const BorderRadius fabRadius = radiusMd;

  /// Avatar radius
  static const BorderRadius avatarRadius = radiusFull;

  /// Image radius (commonly used for image containers)
  static const BorderRadius imageRadius = radiusLg;

  /// Top corners only (for cards with bottom buttons)
  static const BorderRadius topRadius = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  /// Bottom corners only
  static const BorderRadius bottomRadius = BorderRadius.only(
    bottomLeft: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );

  /// Left corners only
  static const BorderRadius leftRadius = BorderRadius.only(
    topLeft: Radius.circular(lg),
    bottomLeft: Radius.circular(lg),
  );

  /// Right corners only
  static const BorderRadius rightRadius = BorderRadius.only(
    topRight: Radius.circular(lg),
    bottomRight: Radius.circular(lg),
  );
}
