import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Ideole card widget matching the design system
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool showBorder;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.padding,
    this.borderRadius,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(8);
    final bg = backgroundColor ?? AppColors.surface;
    final border = showBorder
        ? Border.all(
            color: borderColor ?? AppColors.outlineVariant,
            width: 1,
          )
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: bg,
        elevation: elevation ?? 0.5,
        shadowColor: AppColors.outline.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: br),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: br,
            border: border,
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Simple container card with padding
class AppCardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: padding,
      child: child,
    );
  }
}
