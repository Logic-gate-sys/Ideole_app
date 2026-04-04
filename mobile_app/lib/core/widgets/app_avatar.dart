import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Ideole avatar widget for user profile images
class AppAvatar extends StatelessWidget {
  final String? image;
  final String initials;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final bool online;

  const AppAvatar({
    super.key,
    this.image,
    required this.initials,
    this.size = 48,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.online = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.primaryContainer;
    final tc = textColor ?? AppColors.onPrimaryContainer;

    Widget avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        image: image != null
            ? DecorationImage(
                image: NetworkImage(image!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: image == null
          ? Center(
              child: Text(
                initials,
                style: AppTextStyles.labelLarge.copyWith(
                  color: tc,
                  fontWeight: FontWeight.w600,
                  fontSize: size * 0.35,
                ),
              ),
            )
          : null,
    );

    if (onTap != null) {
      avatar = GestureDetector(onTap: onTap, child: avatar);
    }

    // Add online indicator
    if (online) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size * 0.3,
              height: size * 0.3,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.surface,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return avatar;
  }
}

/// Medium avatar with text label
class AppAvatarWithLabel extends StatelessWidget {
  final String? image;
  final String initials;
  final String? label;
  final double avatarSize;
  final VoidCallback? onTap;

  const AppAvatarWithLabel({
    super.key,
    this.image,
    required this.initials,
    this.label,
    this.avatarSize = 48,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAvatar(
            image: image,
            initials: initials,
            size: avatarSize,
          ),
          if (label != null) ...[
            SizedBox(height: avatarSize * 0.15),
            Text(
              label!,
              style: AppTextStyles.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
