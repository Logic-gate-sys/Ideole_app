import 'package:flutter/material.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';

/// Primary button (filled, rounded)
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final EdgeInsetsGeometry padding;

  const PrimaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: FilledButton(
        onPressed: isLoading || !isEnabled ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: SaharaColors.primary,
          disabledBackgroundColor: SaharaColors.onSurface.withOpacity(0.12),
          foregroundColor: SaharaColors.onPrimary,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(SaharaColors.onPrimary),
                ),
              )
            : Text(
                label,
                style: SaharaTypography.titleMedium.copyWith(
                  color: SaharaColors.onPrimary,
                ),
              ),
      ),
    );
  }
}

/// Secondary button (outlined)
class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isEnabled;
  final double? width;
  final EdgeInsetsGeometry padding;

  const SecondaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.width,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: OutlinedButton(
        onPressed: isLoading || !isEnabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: SaharaColors.onSurface,
          disabledForegroundColor: SaharaColors.onSurface.withOpacity(0.38),
          side: BorderSide(
            color: isEnabled
                ? SaharaColors.outline
                : SaharaColors.outline.withOpacity(0.12),
          ),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(SaharaColors.onSurface),
                ),
              )
            : Text(
                label,
                style: SaharaTypography.titleMedium.copyWith(
                  color: SaharaColors.onSurface,
                ),
              ),
      ),
    );
  }
}

/// Text button (no background, no border)
class TextLinkButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isEnabled;

  const TextLinkButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: SaharaColors.primary,
        disabledForegroundColor: SaharaColors.primary.withOpacity(0.38),
        padding: EdgeInsets.zero,
        minimumSize: const Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: SaharaTypography.bodyMedium.copyWith(
          color: SaharaColors.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
