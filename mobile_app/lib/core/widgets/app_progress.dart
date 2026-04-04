import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Circular progress indicator with percentage display
class AppCircularProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String? label;
  final Color? color;
  final Color? backgroundColor;
  final double size;
  final double strokeWidth;

  const AppCircularProgress({
    super.key,
    required this.value,
    this.label,
    this.color,
    this.backgroundColor,
    this.size = 80,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value * 100).toStringAsFixed(0);
    final bgColor = backgroundColor ?? AppColors.surfaceContainerLowest;
    final fgColor = color ?? AppColors.primary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            color: fgColor,
            backgroundColor: bgColor,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                percentage,
                style: AppTextStyles.headlineSmall.copyWith(
                  color: fgColor,
                  fontSize: size * 0.3,
                ),
              ),
              if (label != null)
                Text(
                  label!,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: size * 0.15,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Linear progress indicator
class AppLinearProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final String? label;
  final String? sublabel;
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final bool showPercentage;

  const AppLinearProgress({
    super.key,
    required this.value,
    this.label,
    this.sublabel,
    this.color,
    this.backgroundColor,
    this.height = 6,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.surfaceContainerLowest;
    final fgColor = color ?? AppColors.primary;
    final percentage = (value * 100).toStringAsFixed(0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label!,
                style: AppTextStyles.labelMedium,
              ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: value,
            minHeight: height,
            color: fgColor,
            backgroundColor: bgColor,
          ),
        ),
        if (sublabel != null) ...[
          const SizedBox(height: 4),
          Text(
            sublabel!,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// Meter widget (similar to circular progress but with 3-color indicator)
class AppMeter extends StatelessWidget {
  final double originality; // 0-100
  final double feasibility; // 0-100
  final double impact; // 0-100
  final double size;

  const AppMeter({
    super.key,
    required this.originality,
    required this.feasibility,
    required this.impact,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MeterPainter(
          originality: originality,
          feasibility: feasibility,
          impact: impact,
        ),
      ),
    );
  }
}

class _MeterPainter extends CustomPainter {
  final double originality;
  final double feasibility;
  final double impact;

  _MeterPainter({
    required this.originality,
    required this.feasibility,
    required this.impact,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    const bgColor = Color.fromARGB(31, 0, 0, 0);

    // Background circle
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.fill,
    );

    // Three indicator segments
    const startAngle = -3.14159265359 / 2; // Top center

    // Originality (primary orange) - top
    _drawSegment(
      canvas,
      center,
      radius,
      startAngle,
      2.0944, // 120 degrees in radians
      AppColors.primary,
      originality / 100,
    );

    // Feasibility (secondary) - bottom right
    _drawSegment(
      canvas,
      center,
      radius,
      startAngle + 2.0944,
      2.0944,
      AppColors.secondary,
      feasibility / 100,
    );

    // Impact (tertiary) - bottom left
    _drawSegment(
      canvas,
      center,
      radius,
      startAngle + 4.1888,
      2.0944,
      AppColors.tertiary,
      impact / 100,
    );

    // Center circle (white)
    canvas.drawCircle(
      center,
      radius * 0.5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill,
    );
  }

  void _drawSegment(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    Color color,
    double fill,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * fill,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_MeterPainter oldDelegate) {
    return oldDelegate.originality != originality ||
        oldDelegate.feasibility != feasibility ||
        oldDelegate.impact != impact;
  }
}

/// Step progress indicator
class AppStepProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const AppStepProgress({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isCompleted = index < currentStep;
            final isCurrent = index == currentStep;

            return Expanded(
              child: Row(
                children: [
                  // Step indicator
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isCompleted || isCurrent
                          ? AppColors.primary
                          : AppColors.surfaceContainerLowest,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check,
                              color: Colors.white, size: 18)
                          : Text(
                              '${index + 1}',
                              style: AppTextStyles.labelMedium.copyWith(
                                color: isCurrent
                                    ? Colors.white
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                    ),
                  ),
                  // Connector line
                  if (index < totalSteps - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        if (labels.isNotEmpty)
          Text(
            labels[currentStep.clamp(0, labels.length - 1)],
            style: AppTextStyles.labelMedium,
          ),
      ],
    );
  }
}
