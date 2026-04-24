import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../domain/entities/mosque.dart';

/// Bottom sheet shown when tapping a map marker
class MosqueBottomSheet extends StatelessWidget {
  final Mosque mosque;
  final VoidCallback onClose;

  const MosqueBottomSheet({
    super.key,
    required this.mosque,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              // Content row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: mosque.imageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: mosque.imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Container(
                                color: AppColors.grey200,
                                child: const Icon(Icons.mosque),
                              ),
                              errorWidget: (_, __, ___) => Container(
                                color: AppColors.grey200,
                                child: const Icon(Icons.mosque),
                              ),
                            )
                          : Container(
                              color: AppColors.grey200,
                              child: const Icon(Icons.mosque),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                mosque.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (mosque.isVerified)
                              const Icon(Icons.verified,
                                  size: 18, color: AppColors.verifiedBadge),
                          ],
                        ),
                        if (mosque.address != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            mosque.address!,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            // Rating
                            if (mosque.rating > 0) ...[
                              Icon(Icons.star,
                                  size: 16, color: AppColors.secondary),
                              const SizedBox(width: 2),
                              Text(
                                mosque.rating.toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 8),
                            ],
                            // Distance
                            if (mosque.distanceKm != null)
                              Text(
                                DistanceCalculator.formatDistance(
                                    mosque.distanceKm!),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.primary),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Close button
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // View Details button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    onClose();
                    context.push(
                      '${RouteNames.mosqueDetailPath.replaceFirst(':id', mosque.id)}',
                    );
                  },
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
