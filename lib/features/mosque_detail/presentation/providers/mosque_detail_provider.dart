import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/mosque_local_datasource.dart';
import '../../../../data/datasources/mosque_mock_datasource.dart';
import '../../../../data/repositories/mosque_repository_impl.dart';
import '../../../../domain/entities/mosque.dart';
import '../../../../domain/entities/review.dart';
import '../../../../domain/repositories/mosque_repository.dart';

/// State for mosque detail screen
class MosqueDetailState {
  final Mosque? mosque;
  final List<Review> reviews;
  final bool isLoading;
  final String? error;
  final bool isFavorite;

  const MosqueDetailState({
    this.mosque,
    this.reviews = const [],
    this.isLoading = false,
    this.error,
    this.isFavorite = false,
  });

  MosqueDetailState copyWith({
    Mosque? mosque,
    List<Review>? reviews,
    bool? isLoading,
    String? error,
    bool? isFavorite,
  }) {
    return MosqueDetailState(
      mosque: mosque ?? this.mosque,
      reviews: reviews ?? this.reviews,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

/// Provider for mosque detail
class MosqueDetailNotifier extends StateNotifier<MosqueDetailState> {
  final MosqueRepository _repository;
  final MosqueLocalDataSource _localDataSource;

  MosqueDetailNotifier(this._repository, this._localDataSource)
      : super(const MosqueDetailState());

  /// Load mosque detail and reviews
  Future<void> loadMosqueDetail(String mosqueId) async {
    state = state.copyWith(isLoading: true, error: null);

    final detailResult = await _repository.getMosqueDetail(mosqueId);
    detailResult.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (mosque) async {
        // Check if this mosque is favorited
        // In production, check via FavoritesRepository
        state = state.copyWith(
          mosque: mosque,
          isLoading: false,
          isFavorite: mosque.isFavorite,
        );

        // Load reviews
        _loadReviews(mosqueId);
      },
    );
  }

  /// Load reviews for the mosque
  Future<void> _loadReviews(String mosqueId) async {
    final reviewResult = await _repository.getMosqueReviews(mosqueId);
    reviewResult.fold(
      (failure) {
        // Reviews are supplementary, don't show error for them
      },
      (reviews) {
        state = state.copyWith(reviews: reviews);
      },
    );
  }

  /// Toggle favorite for this mosque
  void toggleFavorite() {
    state = state.copyWith(isFavorite: !state.isFavorite);
    // In production, call FavoritesRepository.toggleFavorite()
  }

  /// Refresh the detail
  Future<void> refresh(String mosqueId) async {
    await loadMosqueDetail(mosqueId);
  }
}

/// Shared instances used by the provider family.
final _mockDataSource = MosqueMockDataSource();
final _localDataSource = MosqueLocalDataSource();

/// Provider for mosque detail — uses mock data source with simulated latency.
final mosqueDetailProvider =
    StateNotifierProvider.family<MosqueDetailNotifier, MosqueDetailState, String>(
  (ref, mosqueId) {
    final repository = MosqueRepositoryImpl(
      mockDataSource: _mockDataSource,
      localDataSource: _localDataSource,
    );

    return MosqueDetailNotifier(repository, _localDataSource);
  },
);
