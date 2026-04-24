import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/distance_calculator.dart';
import '../../../../domain/entities/mosque.dart';
import '../providers/mosque_detail_provider.dart';
import '../widgets/review_card.dart';
import '../widgets/mosque_info_section.dart';
import '../widgets/action_buttons.dart';

/// Full mosque detail screen
class MosqueDetailPage extends ConsumerStatefulWidget {
  final String mosqueId;

  const MosqueDetailPage({super.key, required this.mosqueId});

  @override
  ConsumerState<MosqueDetailPage> createState() => _MosqueDetailPageState();
}

class _MosqueDetailPageState extends ConsumerState<MosqueDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mosqueDetailProvider(widget.mosqueId).notifier)
          .loadMosqueDetail(widget.mosqueId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mosqueDetailProvider(widget.mosqueId));
    final mosque = state.mosque;

    return Scaffold(
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && mosque == null
              ? _buildErrorState()
              : _buildDetailContent(context, mosque!, state),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          const Text('Failed to load mosque details'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              ref.read(mosqueDetailProvider(widget.mosqueId).notifier)
                  .loadMosqueDetail(widget.mosqueId);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailContent(
      BuildContext context, Mosque mosque, MosqueDetailState state) {
    return CustomScrollView(
      slivers: [
        // App Bar with image
        _buildSliverAppBar(context, mosque, state),

        // Body content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic info
              _buildHeader(context, mosque, state),

              // Action buttons (directions, share, favorite)
              ActionButtons(
                mosque: mosque,
                isFavorite: state.isFavorite,
                onFavoriteToggle: () {
                  ref.read(mosqueDetailProvider(widget.mosqueId).notifier)
                      .toggleFavorite();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.isFavorite
                            ? 'Removed from favorites'
                            : 'Added to favorites',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),

              // Info sections
              MosqueInfoSection(mosque: mosque),

              const Divider(height: 32),

              // Reviews section
              _buildReviewsSection(context, state),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Mosque mosque, MosqueDetailState state) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: mosque.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: mosque.imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.primary),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.primary,
                  child: const Center(
                    child: Icon(Icons.mosque, size: 64, color: Colors.white54),
                  ),
                ),
              )
            : Container(
                color: AppColors.primary,
                child: const Center(
                  child: Icon(Icons.mosque, size: 64, color: Colors.white54),
                ),
              ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            state.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: state.isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () {
            ref.read(mosqueDetailProvider(widget.mosqueId).notifier)
                .toggleFavorite();
          },
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, Mosque mosque, MosqueDetailState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and badges
          Row(
            children: [
              Expanded(
                child: Text(
                  mosque.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              if (mosque.isVerified)
                Tooltip(
                  message: 'Verified Mosque',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.verifiedBadge.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified,
                            size: 16, color: AppColors.verifiedBadge),
                        SizedBox(width: 4),
                        Text(
                          'Verified',
                          style: TextStyle(
                            color: AppColors.verifiedBadge,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (mosque.isCommunityTrusted) ...[
                const SizedBox(width: 8),
                Tooltip(
                  message: 'Community Trusted',
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.communityTrustedBadge.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.groups,
                            size: 16, color: AppColors.communityTrustedBadge),
                        SizedBox(width: 4),
                        Text(
                          'Trusted',
                          style: TextStyle(
                            color: AppColors.communityTrustedBadge,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),

          // Rating
          Row(
            children: [
              RatingBarIndicator(
                rating: mosque.rating,
                itemBuilder: (_, __) => const Icon(
                  Icons.star,
                  color: AppColors.secondary,
                ),
                itemCount: 5,
                itemSize: 20,
                direction: Axis.horizontal,
              ),
              const SizedBox(width: 8),
              Text(
                '${mosque.rating.toStringAsFixed(1)} (${mosque.reviewCount} reviews)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Distance
          if (mosque.distanceKm != null)
            Row(
              children: [
                Icon(Icons.near_me, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  '${DistanceCalculator.formatDistance(mosque.distanceKm!)} away',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, MosqueDetailState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviews (${state.reviews.length})',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          if (state.reviews.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text('No reviews yet'),
              ),
            )
          else
            ...state.reviews.map(
              (review) => ReviewCard(review: review),
            ),
        ],
      ),
    );
  }
}
