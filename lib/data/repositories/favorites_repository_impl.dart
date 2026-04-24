import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/mosque.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/mosque_local_datasource.dart';

/// Implementation of FavoritesRepository using Hive local storage
class FavoritesRepositoryImpl implements FavoritesRepository {
  static const String _favoritesBoxName = 'favorites';

  final MosqueLocalDataSource mosqueLocalDataSource;

  FavoritesRepositoryImpl({required this.mosqueLocalDataSource});

  @override
  Future<Either<Failure, void>> addFavorite(String mosqueId) async {
    try {
      final box = await Hive.openBox<List<String>>(_favoritesBoxName);
      final current = List<String>.from(box.get('favorite_ids') ?? <String>[]);
      if (!current.contains(mosqueId)) {
        current.add(mosqueId);
        await box.put('favorite_ids', current);
      }
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to add favorite'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(String mosqueId) async {
    try {
      final box = await Hive.openBox<List<String>>(_favoritesBoxName);
      final current = List<String>.from(box.get('favorite_ids') ?? <String>[]);
      current.remove(mosqueId);
      await box.put('favorite_ids', current);
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to remove favorite'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleFavorite(String mosqueId) async {
    try {
      final box = await Hive.openBox<List<String>>(_favoritesBoxName);
      final current = List<String>.from(box.get('favorite_ids') ?? <String>[]);

      if (current.contains(mosqueId)) {
        current.remove(mosqueId);
        await box.put('favorite_ids', current);
        return const Right(false);
      } else {
        current.add(mosqueId);
        await box.put('favorite_ids', current);
        return const Right(true);
      }
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to toggle favorite'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getFavoriteIds() async {
    try {
      final box = await Hive.openBox<List<String>>(_favoritesBoxName);
      final ids = List<String>.from(box.get('favorite_ids') ?? <String>[]);
      return Right(ids);
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to get favorites'));
    }
  }

  @override
  Future<Either<Failure, List<Mosque>>> getFavoriteMosques() async {
    try {
      final idsResult = await getFavoriteIds();
      return idsResult.fold(
        (failure) => Left(failure),
        (ids) async {
          if (ids.isEmpty) return const Right([]);

          // Try to get from cache, fallback to empty
          try {
            final cachedEntities = await mosqueLocalDataSource.getCachedMosques();
            final favorites = cachedEntities
                .where((mosque) => ids.contains(mosque.id))
                .toList();
            return Right(favorites);
          } catch (_) {
            return const Right([]);
          }
        },
      );
    } catch (e) {
      return const Left(CacheFailure(message: 'Failed to get favorite mosques'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String mosqueId) async {
    try {
      final box = await Hive.openBox<List<String>>(_favoritesBoxName);
      final current = List<String>.from(box.get('favorite_ids') ?? <String>[]);
      return Right(current.contains(mosqueId));
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Stream<List<String>> watchFavorites() {
    // For simplicity, return a stream that emits on each change
    // In production, use Hive's watch() for reactive updates
    return _favoritesStream();
  }

  Stream<List<String>> _favoritesStream() async* {
    final box = await Hive.openBox<List<String>>(_favoritesBoxName);
    yield List<String>.from(box.get('favorite_ids') ?? <String>[]);
    
    await for (final _ in box.watch()) {
      yield List<String>.from(box.get('favorite_ids') ?? <String>[]);
    }
  }
}
