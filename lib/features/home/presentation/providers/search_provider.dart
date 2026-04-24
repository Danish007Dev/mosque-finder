import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/debouncer.dart';

/// State for search and filter
class SearchState {
  final String query;
  final bool isSearching;
  final List<String> activeFilters;
  final String sortBy;
  final bool verifiedOnly;

  const SearchState({
    this.query = '',
    this.isSearching = false,
    this.activeFilters = const [],
    this.sortBy = 'distance',
    this.verifiedOnly = false,
  });

  SearchState copyWith({
    String? query,
    bool? isSearching,
    List<String>? activeFilters,
    String? sortBy,
    bool? verifiedOnly,
  }) {
    return SearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      activeFilters: activeFilters ?? this.activeFilters,
      sortBy: sortBy ?? this.sortBy,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
    );
  }
}

/// Available filter options
enum MosqueFilter {
  nearest('Nearest', 'distance'),
  highestRated('Highest Rated', 'rating'),
  mostReviewed('Most Reviewed', 'reviews'),
  verified('Verified Only', 'verified');

  final String label;
  final String value;
  const MosqueFilter(this.label, this.value);
}

/// Provider for search and filter functionality
class SearchNotifier extends StateNotifier<SearchState> {
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  SearchNotifier() : super(const SearchState());

  /// Update search query with debouncing
  void onSearchChanged(String query) {
    state = state.copyWith(query: query, isSearching: query.isNotEmpty);
    _debouncer.run(() {
      // Trigger search via mosque list provider
      _onSearchSubmitted();
    });
  }

  /// Submit search
  void _onSearchSubmitted() {
    // The actual search is handled by MosqueListNotifier
    // This state just tracks the search string
    state = state.copyWith(isSearching: false);
  }

  /// Clear search
  void clearSearch() {
    _debouncer.cancel();
    state = const SearchState();
  }

  /// Set sort by option
  void setSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  /// Toggle verified only filter
  void toggleVerifiedOnly() {
    state = state.copyWith(verifiedOnly: !state.verifiedOnly);
  }

  /// Add a filter
  void addFilter(String filter) {
    if (!state.activeFilters.contains(filter)) {
      state = state.copyWith(
        activeFilters: [...state.activeFilters, filter],
      );
    }
  }

  /// Remove a filter
  void removeFilter(String filter) {
    state = state.copyWith(
      activeFilters: state.activeFilters.where((f) => f != filter).toList(),
    );
  }

  /// Clear all filters
  void clearFilters() {
    state = state.copyWith(
      activeFilters: [],
      sortBy: 'distance',
      verifiedOnly: false,
    );
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}

/// Provider for search state
final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});
