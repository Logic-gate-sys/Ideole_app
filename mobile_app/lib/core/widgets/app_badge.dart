import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppBadgeVariant { filled, outlined, tonal }

/// Ideole badge widget for status/label indicators
class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.filled,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.prefix,
    this.suffix,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color tc;
    Color? bc;

    switch (variant) {
      case AppBadgeVariant.filled:
        bg = backgroundColor ?? AppColors.primaryContainer;
        tc = textColor ?? AppColors.onPrimaryContainer;
        bc = null;
        break;
      case AppBadgeVariant.outlined:
        bg = backgroundColor ?? Colors.transparent;
        tc = textColor ?? AppColors.primary;
        bc = borderColor ?? AppColors.primary;
        break;
      case AppBadgeVariant.tonal:
        bg = backgroundColor ?? AppColors.tertiaryContainer;
        tc = textColor ?? AppColors.onTertiaryContainer;
        bc = null;
        break;
    }

    Widget badge = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: bc != null ? Border.all(color: bc, width: 1) : null,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefix != null) ...[
            prefix!,
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: tc),
          ),
          if (suffix != null) ...[
            const SizedBox(width: 4),
            suffix!,
          ],
        ],
      ),
    );

    if (onTap != null) {
      badge = GestureDetector(onTap: onTap, child: badge);
    }

    return badge;
  }
}

/// Badge with icon indicator
class AppBadgeWithIcon extends StatelessWidget {
  final String label;
  final IconData icon;
  final AppBadgeVariant variant;
  final Color? backgroundColor;
  final Color? textColor;

  const AppBadgeWithIcon({
    super.key,
    required this.label,
    required this.icon,
    this.variant = AppBadgeVariant.filled,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBadge(
      label: label,
      variant: variant,
      backgroundColor: backgroundColor,
      textColor: textColor,
      prefix: Icon(
        icon,
        size: 14,
        color: textColor ?? (variant == AppBadgeVariant.outlined
            ? AppColors.primary
            : AppColors.onPrimaryContainer),
      ),
    );
  }
}

/// Status badge with specific colors
class AppStatusBadge extends StatelessWidget {
  final String label;
  final AppStatusCategory status;

  const AppStatusBadge({
    super.key,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    switch (status) {
      case AppStatusCategory.success:
        bgColor = AppColors.successContainer;
        textColor = AppColors.onSuccessContainer;
        break;
      case AppStatusCategory.warning:
        bgColor = AppColors.warningContainer;
        textColor = AppColors.onWarningContainer;
        break;
      case AppStatusCategory.error:
        bgColor = AppColors.errorContainer;
        textColor = AppColors.onErrorContainer;
        break;
      case AppStatusCategory.info:
        bgColor = AppColors.infoContainer;
        textColor = AppColors.onInfoContainer;
        break;
    }

    return AppBadge(
      label: label,
      backgroundColor: bgColor,
      textColor: textColor,
      variant: AppBadgeVariant.filled,
    );
  }
}

enum AppStatusCategory { success, warning, error, info }
