import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../domain/entities/mosque.dart';
import '../../../../core/router/route_names.dart';

/// Compact mosque card for the list view
class MosqueCard extends StatelessWidget {
  final Mosque mosque;
  final VoidCallback? onFavoriteToggle;

  const MosqueCard({
    super.key,
    required this.mosque,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(
          '${RouteNames.mosqueDetailPath.replaceFirst(':id', mosque.id)}',
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image section
              _buildImageSection(),
              // Content section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top row: Name + Favorite
                      _buildNameAndFavorite(context),
                      const SizedBox(height: 4),
                      // Address
                      _buildAddress(context),
                      const SizedBox(height: 8),
                      // Bottom row: Rating + Distance + Badge
                      _buildBottomRow(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return SizedBox(
      width: 100,
      child: mosque.imageUrl != null
          ? CachedNetworkImage(
              imageUrl: mosque.imageUrl!,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: AppColors.grey200,
                child: const Icon(Icons.mosque, color: AppColors.grey400),
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.grey200,
                child: const Icon(Icons.mosque, color: AppColors.grey400),
              ),
            )
          : Container(
              color: AppColors.grey200,
              child: const Icon(Icons.mosque, color: AppColors.grey400),
            ),
    );
  }

  Widget _buildNameAndFavorite(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            mosque.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(
            mosque.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: mosque.isFavorite ? AppColors.error : null,
            size: 20,
          ),
          onPressed: onFavoriteToggle,
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _buildAddress(BuildContext context) {
    if (mosque.address == null) return const SizedBox.shrink();
    return Row(
      children: [
        Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            mosque.address!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow(BuildContext context) {
    return Row(
      children: [
        // Rating
        if (mosque.rating > 0)
          Row(
            children: [
              Icon(Icons.star, size: 16, color: AppColors.secondary),
              const SizedBox(width: 2),
              Text(
                mosque.rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                ' (${mosque.reviewCount})',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
            ],
          ),
        const Spacer(),
        // Distance
        if (mosque.distanceKm != null)
          Text(
            DistanceCalculator.formatDistance(mosque.distanceKm!),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        const SizedBox(width: 4),
        // Badge
        if (mosque.isVerified)
          const Icon(Icons.verified, size: 16, color: AppColors.verifiedBadge),
        if (mosque.isCommunityTrusted)
          const Icon(Icons.groups, size: 16, color: AppColors.communityTrustedBadge),
      ],
    );
  }
}
