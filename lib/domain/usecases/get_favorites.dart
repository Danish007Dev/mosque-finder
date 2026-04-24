import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/mosque.dart';
import '../repositories/favorites_repository.dart';

/// Use case: Get all favorite mosques
class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<Mosque>>> call() async {
    return repository.getFavoriteMosques();
  }

  Stream<List<String>> watchFavorites() {
    return repository.watchFavorites();
  }
}
