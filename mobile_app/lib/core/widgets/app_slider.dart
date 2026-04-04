import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Ideole slider widget for rating/score input
class AppSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String? label;
  final String Function(double)? labelBuilder;
  final void Function(double)? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const AppSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 10,
    this.divisions = 10,
    this.label,
    this.labelBuilder,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final ac = activeColor ?? AppColors.primary;
    final ic = inactiveColor ?? AppColors.surfaceContainerLowest;
    final displayLabel =
        labelBuilder?.call(value) ?? value.toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 6,
                  thumbShape: RoundSliderThumbShape(
                    elevation: 2,
                    enabledThumbRadius: 12,
                    disabledThumbRadius: 12,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 20,
                  ),
                ),
                child: Slider(
                  value: value,
                  min: min,
                  max: max,
                  divisions: divisions,
                  activeColor: ac,
                  inactiveColor: ic,
                  onChanged: onChanged,
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 40,
              child: Text(
                displayLabel,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: ac,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Range slider for min/max selection
class AppRangeSlider extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final int divisions;
  final String? label;
  final void Function(RangeValues)? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;

  const AppRangeSlider({
    super.key,
    required this.values,
    this.min = 0,
    this.max = 100,
    this.divisions = 100,
    this.label,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final ac = activeColor ?? AppColors.primary;
    final ic = inactiveColor ?? AppColors.surfaceContainerLowest;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label!, style: AppTextStyles.labelMedium),
              Text(
                '${values.start.toStringAsFixed(0)} - ${values.end.toStringAsFixed(0)}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        RangeSlider(
          values: values,
          min: min,
          max: max,
          divisions: divisions,
          activeColor: ac,
          inactiveColor: ic,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Rating slider with star icons
class AppRatingSlider extends StatelessWidget {
  final double rating; // 1-5
  final void Function(double)? onChanged;
  final String? label;
  final bool interactive;

  const AppRatingSlider({
    super.key,
    required this.rating,
    this.onChanged,
    this.label,
    this.interactive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.labelMedium),
          const SizedBox(height: 8),
        ],
        Row(
          children: List.generate(5, (index) {
            final starRating = (index + 1).toDouble();
            final isFilled = rating >= starRating;
            final isHalf = rating > index && rating < starRating;

            return GestureDetector(
              onTap: interactive ? () => onChanged?.call(starRating) : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  isHalf ? Icons.star_half : Icons.star,
                  color: isFilled ? AppColors.primary : AppColors.outlineVariant,
                  size: 32,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          '${rating.toStringAsFixed(1)}/5.0',
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
