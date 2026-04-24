import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/mosque.dart';
import '../repositories/mosque_repository_provider.dart';

/// State for the mosque list
class MosqueListState {
  final List<Mosque> mosques;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final bool hasReachedEnd;
  final int currentPage;
  final String sortBy;
  final bool verifiedOnly;
  final String? searchQuery;

  const MosqueListState({
    this.mosques = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.sortBy = 'distance',
    this.verifiedOnly = false,
    this.searchQuery,
  });

  MosqueListState copyWith({
    List<Mosque>? mosques,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    bool? hasReachedEnd,
    int? currentPage,
    String? sortBy,
    bool? verifiedOnly,
    String? searchQuery,
  }) {
    return MosqueListState(
      mosques: mosques ?? this.mosques,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      sortBy: sortBy ?? this.sortBy,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Provider for mosque list with pagination, search, and filter support
class MosqueListNotifier extends StateNotifier<MosqueListState> {
  final MosqueRepositoryProvider _repository;
  final Ref _ref;

  MosqueListNotifier(this._repository, this._ref)
      : super(const MosqueListState());

  /// Initial load of mosques
  Future<void> loadMosques({
    bool refresh = false,
    String? searchQuery,
    String? sortBy,
    bool? verifiedOnly,
  }) async {
    if (!refresh && state.mosques.isNotEmpty) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: refresh ? 1 : state.currentPage,
      sortBy: sortBy ?? state.sortBy,
      verifiedOnly: verifiedOnly ?? state.verifiedOnly,
      searchQuery: refresh ? searchQuery : (searchQuery ?? state.searchQuery),
    );

    // In a real app, get user location here
    // For now, use default location
    final location = _ref.read(locationProvider);

    try {
      final result = await _repository.getMosques(
        latitude: location.latitude,
        longitude: location.longitude,
        page: 1,
        limit: AppConstants.paginationLimit,
        searchQuery: state.searchQuery,
        sortBy: state.sortBy,
        verifiedOnly: state.verifiedOnly,
      );

      state = state.copyWith(
        mosques: result.mosques,
        isLoading: false,
        error: null,
        currentPage: 1,
        hasReachedEnd: !result.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Load next page (infinite scroll / pagination)
  Future<void> loadNextPage() async {
    if (state.isLoadingMore || state.hasReachedEnd) return;

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.currentPage + 1;
    final location = _ref.read(locationProvider);

    try {
      final result = await _repository.getMosques(
        latitude: location.latitude,
        longitude: location.longitude,
        page: nextPage,
        limit: AppConstants.paginationLimit,
        searchQuery: state.searchQuery,
        sortBy: state.sortBy,
        verifiedOnly: state.verifiedOnly,
      );

      state = state.copyWith(
        mosques: [...state.mosques, ...result.mosques],
        isLoadingMore: false,
        currentPage: nextPage,
        hasReachedEnd: !result.hasMore,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Refresh the mosque list
  Future<void> refresh() async {
    await loadMosques(refresh: true);
  }

  /// Set sort order
  void setSortBy(String sortBy) {
    if (state.sortBy == sortBy) return;
    state = state.copyWith(sortBy: sortBy);
    loadMosques(refresh: true, sortBy: sortBy);
  }

  /// Toggle verified only filter
  void toggleVerifiedOnly() {
    final newValue = !state.verifiedOnly;
    state = state.copyWith(verifiedOnly: newValue);
    loadMosques(refresh: true, verifiedOnly: newValue);
  }
}

/// Convenience class for user location
class UserLocation {
  final double latitude;
  final double longitude;

  const UserLocation({
    this.latitude = AppConstants.defaultLatitude,
    this.longitude = AppConstants.defaultLongitude,
  });
}

/// Location provider (will be connected to geolocator)
final locationProvider = Provider<UserLocation>((ref) {
  return const UserLocation();
});

/// Provider for mosque list
final mosqueListProvider =
    StateNotifierProvider<MosqueListNotifier, MosqueListState>((ref) {
  final repository = ref.read(mosqueRepositoryProvider);
  return MosqueListNotifier(repository, ref);
});
