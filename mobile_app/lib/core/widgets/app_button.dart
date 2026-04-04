import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Primary action button with customizable variants
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isFullWidth;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isFullWidth = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final br = borderRadius ?? BorderRadius.circular(8);

    switch (variant) {
      case AppButtonVariant.filled:
        return _buildFilledButton(context, br);
      case AppButtonVariant.outlined:
        return _buildOutlinedButton(context, br);
      case AppButtonVariant.text:
        return _buildTextButton(context, br);
      case AppButtonVariant.tonal:
        return _buildTonalButton(context, br);
    }
  }

  Widget _buildFilledButton(BuildContext context, BorderRadius br) {
    final isSmall = size == AppButtonSize.small;
    final padding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: FilledButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: FilledButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: br),
          backgroundColor: isEnabled ? AppColors.primary : AppColors.outline,
        ),
        child: isLoading
            ? SizedBox(
                height: isSmall ? 16 : 20,
                width: isSmall ? 16 : 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isEnabled ? AppColors.onPrimary : AppColors.onSurface,
                  ),
                ),
              )
            : _buildButtonContent(isSmall),
      ),
    );
  }

  Widget _buildOutlinedButton(BuildContext context, BorderRadius br) {
    final isSmall = size == AppButtonSize.small;
    final padding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: OutlinedButton.styleFrom(
          padding: padding,
          side: BorderSide(
            color: isEnabled ? AppColors.primary : AppColors.outline,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(borderRadius: br),
        ),
        child: isLoading
            ? SizedBox(
                height: isSmall ? 16 : 20,
                width: isSmall ? 16 : 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              )
            : _buildButtonContent(isSmall),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, BorderRadius br) {
    return TextButton(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: br),
      ),
      child: isLoading
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            )
          : Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isEnabled ? AppColors.primary : AppColors.outline,
              ),
            ),
      );
  }

  Widget _buildTonalButton(BuildContext context, BorderRadius br) {
    final isSmall = size == AppButtonSize.small;
    final padding = isSmall
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: FilledButton.tonal(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        style: FilledButton.styleFrom(
          padding: padding,
          backgroundColor:
              isEnabled ? AppColors.primaryFixed : AppColors.surfaceContainer,
          foregroundColor:
              isEnabled ? AppColors.onPrimaryFixed : AppColors.onSurface,
          shape: RoundedRectangleBorder(borderRadius: br),
        ),
        child: isLoading
            ? SizedBox(
                height: isSmall ? 16 : 20,
                width: isSmall ? 16 : 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isEnabled ? AppColors.primary : AppColors.onSurface,
                  ),
                ),
              )
            : _buildButtonContent(isSmall),
      ),
    );
  }

  Widget _buildButtonContent(bool isSmall) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isSmall ? 16 : 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: isSmall ? AppTextStyles.labelSmall : AppTextStyles.labelMedium,
          ),
        ],
      );
    }
    return Text(
      label,
      style: isSmall ? AppTextStyles.labelSmall : AppTextStyles.labelMedium,
    );
  }
}

enum AppButtonVariant { filled, outlined, text, tonal }

enum AppButtonSize { small, medium, large }
