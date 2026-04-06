import 'package:flutter/material.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../../../models/community.dart';

/// Community Card - Reusable component to display a community
class CommunityCard extends StatelessWidget {
  final Community community;
  final VoidCallback? onTap;
  final VoidCallback? onJoinPressed;

  const CommunityCard({
    super.key,
    required this.community,
    this.onTap,
    this.onJoinPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Name + Member badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Community name
                        Text(
                          community.name,
                          style: SaharaTypography.titleLarge.copyWith(
                            color: SaharaColors.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        // Member count
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16,
                              color: SaharaColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${community.memberCount} members',
                              style: SaharaTypography.bodySmall.copyWith(
                                color: SaharaColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Status badge
                  if (community.isMember)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Member',
                        style: SaharaTypography.labelSmall.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (community.hasPendingRequest)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Pending',
                        style: SaharaTypography.labelSmall.copyWith(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                community.description,
                style: SaharaTypography.bodyMedium.copyWith(
                  color: SaharaColors.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Status badge
              if (community.status != 'ACTIVE')
                Text(
                  'Status: ${community.status}',
                  style: SaharaTypography.bodySmall.copyWith(
                    color: Colors.orange,
                  ),
                )
              else
                // Join button (if not member and no pending request)
                if (!community.isMember && !community.hasPendingRequest)
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onJoinPressed,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          child: Text(
                            'Request to Join',
                            style: SaharaTypography.labelLarge.copyWith(
                              color: SaharaColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
