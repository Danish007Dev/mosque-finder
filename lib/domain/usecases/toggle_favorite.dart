import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/favorites_repository.dart';

/// Use case: Toggle favorite status for a mosque
class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String mosqueId) async {
    return repository.toggleFavorite(mosqueId);
  }
}
