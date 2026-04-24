import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/mosque.dart';

/// Abstract repository interface for favorites management
abstract class FavoritesRepository {
  /// Get all favorite mosque IDs
  Future<Either<Failure, List<String>>> getFavoriteIds();

  /// Get all favorite mosques with full details
  Future<Either<Failure, List<Mosque>>> getFavoriteMosques();

  /// Check if a mosque is favorited
  Future<Either<Failure, bool>> isFavorite(String mosqueId);

  /// Add a mosque to favorites
  Future<Either<Failure, void>> addFavorite(String mosqueId);

  /// Remove a mosque from favorites
  Future<Either<Failure, void>> removeFavorite(String mosqueId);

  /// Toggle favorite status for a mosque
  Future<Either<Failure, bool>> toggleFavorite(String mosqueId);

  /// Stream of favorite IDs for reactive UI updates
  Stream<List<String>> watchFavorites();
}
