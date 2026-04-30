import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_button.dart';

/// Ideole dialog widget
class AppDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final List<AppDialogAction> actions;
  final VoidCallback? onClose;
  final Color? backgroundColor;

  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.onClose,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor ?? AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.headlineSmall,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    onClose?.call();
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            content,
            const SizedBox(height: 24),
            // Actions
            if (actions.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: List.generate(
                  actions.length,
                  (index) {
                    final action = actions[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        left: index > 0 ? 12 : 0,
                      ),
                      child: AppButton(
                        label: action.label,
                        variant: action.variant,
                        size: AppButtonSize.medium,
                        onPressed: () {
                          Navigator.pop(context);
                          action.onTap?.call();
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class AppDialogAction {
  final String label;
  final VoidCallback? onTap;
  final AppButtonVariant variant;

  AppDialogAction({
    required this.label,
    this.onTap,
    this.variant = AppButtonVariant.text,
  });
}

/// Alert dialog with predefined styles
class AppAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String positiveLabel;
  final String negativeLabel;
  final VoidCallback? onPositive;
  final VoidCallback? onNegative;
  final AlertType type;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.positiveLabel = 'OK',
    this.negativeLabel = 'Cancel',
    this.onPositive,
    this.onNegative,
    this.type = AlertType.info,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (type) {
      case AlertType.success:
        icon = Icons.check_circle;
        iconColor = AppColors.success;
        break;
      case AlertType.warning:
        icon = Icons.warning;
        iconColor = AppColors.warning;
        break;
      case AlertType.error:
        icon = Icons.error;
        iconColor = AppColors.error;
        break;
      case AlertType.info:
        icon = Icons.info;
        iconColor = AppColors.info;
        break;
    }

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: negativeLabel,
                  variant: AppButtonVariant.text,
                  size: AppButtonSize.medium,
                  onPressed: () {
                    onNegative?.call();
                  },
                ),
                const SizedBox(width: 12),
                AppButton(
                  label: positiveLabel,
                  variant: AppButtonVariant.filled,
                  size: AppButtonSize.medium,
                  onPressed: () {
                    onPositive?.call();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

enum AlertType { success, warning, error, info }

/// Bottom sheet widget
class AppBottomSheet extends StatelessWidget {
  final String title;
  final Widget content;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color? backgroundColor;

  const AppBottomSheet({
    super.key,
    required this.title,
    required this.content,
    this.actionLabel,
    this.onAction,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              title,
              style: AppTextStyles.headlineSmall,
            ),
          ),
          const SizedBox(height: 16),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: content,
          ),
          const SizedBox(height: 24),
          // Action
          if (actionLabel != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AppButton(
                label: actionLabel!,
                variant: AppButtonVariant.filled,
                size: AppButtonSize.medium,
                isFullWidth: true,
                onPressed: () {
                  Navigator.pop(context);
                  onAction?.call();
                },
              ),
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

/// Confirmation dialog helper
Future<bool?> showAppAlertDialog(
  BuildContext context, {
  required String title,
  required String message,
  String positiveLabel = 'OK',
  String negativeLabel = 'Cancel',
  VoidCallback? onPositive,
  VoidCallback? onNegative,
  AlertType type = AlertType.info,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AppAlertDialog(
      title: title,
      message: message,
      positiveLabel: positiveLabel,
      negativeLabel: negativeLabel,
      onPositive: () {
        Navigator.pop(context, true);
        onPositive?.call();
      },
      onNegative: () {
        Navigator.pop(context, false);
        onNegative?.call();
      },
      type: type,
    ),
  );
}

/// Bottom sheet helper
Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  required String title,
  required Widget content,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  return showModalBottomSheet<T>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => AppBottomSheet(
      title: title,
      content: content,
      actionLabel: actionLabel,
      onAction: onAction,
    ),
  );
}
