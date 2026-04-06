import 'package:flutter/material.dart';
import '../../core/design/colors.dart';
import '../../core/design/typography.dart';

/// Rating/Evaluation Modal - Allows users to rate ideas on multiple criteria
class RatingModal extends StatefulWidget {
  final String ideaTitle;
  final Function(Map<String, double>) onSubmit;

  const RatingModal({
    required this.ideaTitle,
    required this.onSubmit,
    super.key,
  });

  @override
  State<RatingModal> createState() => _RatingModalState();
}

class _RatingModalState extends State<RatingModal> {
  late Map<String, double> ratings;
  late Map<String, String> descriptions;

  @override
  void initState() {
    super.initState();
    ratings = {
      'Originality': 5.0,
      'Feasibility': 5.0,
      'Impact': 5.0,
    };
    descriptions = {
      'Originality': 'How unique and innovative is this concept?',
      'Feasibility': 'The technical and economic viability of bringing this idea to life.',
      'Impact': 'The potential scale of positive change this concept could deliver.',
    };
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: SaharaColors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: SaharaColors.outlineVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Evaluate Concept',
                      style: SaharaTypography.headlineLarge.copyWith(
                        color: SaharaColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Reviewing "${widget.ideaTitle}"',
                      style: SaharaTypography.bodySmall.copyWith(
                        color: SaharaColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable rating cards
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: ratings.keys.map((criterion) {
                    return _buildRatingCard(
                      criterion,
                      ratings[criterion]!,
                      descriptions[criterion]!,
                    );
                  }).toList(),
                ),
              ),
              // Submit button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onSubmit(ratings);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SaharaColors.primary,
                      foregroundColor: SaharaColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Submit Evaluation',
                      style: SaharaTypography.labelMedium.copyWith(
                        color: SaharaColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRatingCard(
    String title,
    double value,
    String description,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SaharaColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: SaharaColors.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Criterion',
                    style: SaharaTypography.labelSmall.copyWith(
                      color: SaharaColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: SaharaTypography.headlineSmall.copyWith(
                      color: SaharaColors.onSurface,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value.toStringAsFixed(1),
                    style: SaharaTypography.headlineLarge.copyWith(
                      color: SaharaColors.primary,
                    ),
                  ),
                  Text(
                    '/ 10',
                    style: SaharaTypography.labelSmall.copyWith(
                      color: SaharaColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: SaharaColors.primary,
              inactiveTrackColor: SaharaColors.outlineVariant.withOpacity(0.3),
              thumbColor: SaharaColors.primary,
              overlayColor: SaharaColors.primary.withOpacity(0.2),
            ),
            child: Slider(
              value: value,
              min: 1,
              max: 10,
              divisions: 90,
              onChanged: (newValue) {
                setState(() {
                  ratings[title] = newValue;
                });
              },
            ),
          ),
          const SizedBox(height: 12),
          // Description
          Text(
            description,
            style: SaharaTypography.labelSmall.copyWith(
              color: SaharaColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
