import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/search_provider.dart';
import '../providers/mosque_list_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// Search bar widget with debounced input
class MosqueSearchBar extends ConsumerStatefulWidget {
  const MosqueSearchBar({super.key});

  @override
  ConsumerState<MosqueSearchBar> createState() => _MosqueSearchBarState();
}

class _MosqueSearchBarState extends ConsumerState<MosqueSearchBar> {
  final _controller = TextEditingController();
  bool _showClear = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() => _showClear = value.isNotEmpty);
                ref.read(searchProvider.notifier).onSearchChanged(value);
                // Trigger search in mosque list
                ref.read(mosqueListProvider.notifier).loadMosques(
                      refresh: true,
                      searchQuery: value.isEmpty ? null : value,
                    );
              },
              decoration: InputDecoration(
                hintText: 'Search mosques...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _showClear
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => _showClear = false);
                          ref.read(searchProvider.notifier).clearSearch();
                          ref.read(mosqueListProvider.notifier).loadMosques(
                                refresh: true,
                              );
                        },
                      )
                    : null,
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? AppColors.grey100
                    : AppColors.darkCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Filter button
          Consumer(
            builder: (context, ref, child) {
              final activeFilters = ref.watch(searchProvider).activeFilters;
              return Badge(
                isLabelVisible: activeFilters.isNotEmpty,
                child: IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterSheet(context),
                  tooltip: 'Filters',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterSheet(),
    );
  }
}

/// Filter bottom sheet
class FilterSheet extends ConsumerWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  ref.read(searchProvider.notifier).clearFilters();
                  ref.read(mosqueListProvider.notifier).loadMosques(refresh: true);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Sort By',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: MosqueFilter.values.map((filter) {
              final isSelected = searchState.sortBy == filter.value;
              return ChoiceChip(
                label: Text(filter.label),
                selected: isSelected,
                onSelected: (_) {
                  ref.read(searchProvider.notifier).setSortBy(filter.value);
                  ref.read(mosqueListProvider.notifier).loadMosques(
                        refresh: true,
                        sortBy: filter.value,
                      );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Verified Mosques Only'),
            subtitle: const Text('Show only verified mosques'),
            value: searchState.verifiedOnly,
            onChanged: (value) {
              ref.read(searchProvider.notifier).toggleVerifiedOnly();
              ref.read(mosqueListProvider.notifier).loadMosques(
                    refresh: true,
                    verifiedOnly: value,
                  );
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply Filters'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// Filter chips displayed below search bar
class FilterChips extends ConsumerWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (searchState.verifiedOnly)
              Chip(
                label: const Text('Verified'),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  ref.read(searchProvider.notifier).toggleVerifiedOnly();
                },
              ),
            ...searchState.activeFilters.map((filter) {
              return Chip(
                label: Text(filter),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  ref.read(searchProvider.notifier).removeFilter(filter);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
