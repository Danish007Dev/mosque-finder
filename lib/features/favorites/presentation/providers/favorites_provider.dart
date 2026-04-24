import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/mosque_local_datasource.dart';
import '../../../../data/repositories/favorites_repository_impl.dart';
import '../../../../domain/entities/mosque.dart';
import '../../../../domain/repositories/favorites_repository.dart';

/// State for favorites list
class FavoritesState {
  final List<Mosque> favorites;
  final bool isLoading;
  final String? error;
  final List<String> favoriteIds;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
    this.error,
    this.favoriteIds = const [],
  });

  FavoritesState copyWith({
    List<Mosque>? favorites,
    bool? isLoading,
    String? error,
    List<String>? favoriteIds,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      favoriteIds: favoriteIds ?? this.favoriteIds,
    );
  }
}

/// Provider for favorites management
class FavoritesNotifier extends StateNotifier<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesNotifier(this._repository) : super(const FavoritesState());

  /// Load all favorite mosques
  Future<void> loadFavorites() async {
    state = state.copyWith(isLoading: true, error: null);

    final idsResult = await _repository.getFavoriteIds();
    idsResult.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
      },
      (ids) async {
        state = state.copyWith(favoriteIds: ids);

        final mosquesResult = await _repository.getFavoriteMosques();
        mosquesResult.fold(
          (failure) {
            state = state.copyWith(isLoading: false, error: failure.message);
          },
          (mosques) {
            state = state.copyWith(
              favorites: mosques,
              isLoading: false,
            );
          },
        );
      },
    );
  }

  /// Toggle favorite for a mosque
  Future<void> toggleFavorite(String mosqueId) async {
    final result = await _repository.toggleFavorite(mosqueId);
    result.fold(
      (failure) {
        state = state.copyWith(error: failure.message);
      },
      (isFavorited) {
        if (isFavorited) {
          // Add to local state
          // In production, would fetch full mosque data
          state = state.copyWith(
            favoriteIds: [...state.favoriteIds, mosqueId],
          );
        } else {
          // Remove from local state
          state = state.copyWith(
            favoriteIds: state.favoriteIds.where((id) => id != mosqueId).toList(),
            favorites: state.favorites.where((m) => m.id != mosqueId).toList(),
          );
        }
      },
    );
  }

  /// Check if a mosque is favorited
  bool isFavorite(String mosqueId) {
    return state.favoriteIds.contains(mosqueId);
  }

  /// Refresh favorites
  Future<void> refresh() async {
    await loadFavorites();
  }
}

/// Provider for favorites
final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, FavoritesState>((ref) {
  final mosqueLocalDs = MosqueLocalDataSource();
  final repository = FavoritesRepositoryImpl(
    mosqueLocalDataSource: mosqueLocalDs,
  );
  return FavoritesNotifier(repository);
});
