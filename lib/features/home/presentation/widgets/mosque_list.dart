import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entities/mosque.dart';
import '../providers/mosque_list_provider.dart';
import 'mosque_card.dart';

/// List view of mosques with efficient rendering and pagination controls.
///
/// Shows a scroll-triggered loading indicator at the bottom when more
/// items are being fetched, and a [Load More] button when the list is
/// short enough that the user cannot scroll to trigger pagination.
class MosqueListView extends ConsumerWidget {
  final List<Mosque> mosques;

  const MosqueListView({super.key, required this.mosques});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(mosqueListProvider);

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      // +2: one for scroll-loading indicator, one for "Load More" button
      itemCount: mosques.length + 2,
      itemBuilder: (context, index) {
        // --- Loading indicator (shown during infinite-scroll) ---
        if (index == mosques.length) {
          return _buildScrollLoadingIndicator(state);
        }

        // --- "Load More" button (shown when list is too short to scroll) ---
        if (index == mosques.length + 1) {
          return _buildLoadMoreButton(context, ref, state);
        }

        final mosque = mosques[index];
        return MosqueCard(
          mosque: mosque,
          onFavoriteToggle: () {
            // Toggle favorite via provider
            ref.read(mosqueListProvider.notifier).loadMosques(refresh: true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  mosque.isFavorite
                      ? 'Removed from favorites'
                      : 'Added to favorites',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        );
      },
    );
  }

  /// Spinner shown at the bottom while [loadNextPage] is in progress
  /// (triggered by the scroll listener in [home_page.dart]).
  Widget _buildScrollLoadingIndicator(MosqueListState state) {
    if (!state.isLoadingMore || state.hasReachedEnd) {
      return const SizedBox.shrink();
    }

    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Explicit [Load More] button so pagination works even when the
  /// current items all fit on screen and no scroll notification fires.
  Widget _buildLoadMoreButton(
      BuildContext context, WidgetRef ref, MosqueListState state) {
    // Show nothing when loading or at the end
    if (state.isLoadingMore || state.hasReachedEnd || state.mosques.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () =>
              ref.read(mosqueListProvider.notifier).loadNextPage(),
          icon: const Icon(Icons.expand_more),
          label: const Text('Load more mosques'),
        ),
      ),
    );
  }
}
