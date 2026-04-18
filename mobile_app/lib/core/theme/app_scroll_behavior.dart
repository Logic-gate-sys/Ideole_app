import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Global scroll behavior for Ideole pages.
///
/// - Enables drag-based scrolling with mouse/stylus on desktop/tablet.
/// - Keeps scrollables responsive even when content is shorter than viewport.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => const {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.unknown,
  };

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const AlwaysScrollableScrollPhysics().applyTo(
      super.getScrollPhysics(context),
    );
  }
}