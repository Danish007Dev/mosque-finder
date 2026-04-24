import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/mosque.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/mosque_repository.dart';
import '../datasources/mosque_local_datasource.dart';
import '../datasources/mosque_mock_datasource.dart';

/// Implementation of MosqueRepository using the mock data source.
///
/// Eliminates all live HTTP calls — uses hardcoded data with simulated
/// latency (1-second delay in the data source). Pagination returns
/// 5 items per page by default, controlled by
/// [MosqueMockDataSource.itemsPerPage].
class MosqueRepositoryImpl implements MosqueRepository {
  final MosqueMockDataSource mockDataSource;
  final MosqueLocalDataSource localDataSource;

  MosqueRepositoryImpl({
    required this.mockDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Mosque>>> getMosques({
    required double latitude,
    required double longitude,
    double? radiusKm,
    int? page,
    int? limit,
    String? searchQuery,
    bool? verifiedOnly,
    String? sortBy,
  }) async {
    try {
      final results = await mockDataSource.getMosques(
        latitude: latitude,
        longitude: longitude,
        radiusKm: radiusKm,
        page: page,
        limit: limit,
        searchQuery: searchQuery,
        verifiedOnly: verifiedOnly,
        sortBy: sortBy,
      );

      // Cache first page for offline / favorites lookup
      if (page == null || page == 1) {
        try {
          await localDataSource.cacheMosques(results);
        } catch (_) {
          // Caching is best-effort
        }
      }

      return Right(results);
    } on Exception {
      return _fetchMosquesFromCache();
    } catch (e) {
      return const Left(ServerFailure(message: 'Failed to fetch mosques'));
    }
  }

  @override
  Future<Either<Failure, Mosque>> getMosqueDetail(String mosqueId) async {
    try {
      final mosque = await mockDataSource.getMosqueDetail(mosqueId);
      return Right(mosque);
    } on Exception {
      return const Left(NotFoundFailure(message: 'Mosque not found'));
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Failed to fetch mosque details'),
      );
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getMosqueReviews(
    String mosqueId, {
    int? page,
    int? limit,
  }) async {
    try {
      final reviews = await mockDataSource.getMosqueReviews(
        mosqueId,
        page: page,
        limit: limit,
      );
      return Right(reviews);
    } catch (e) {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, List<Mosque>>> searchMosques({
    required String query,
    required double latitude,
    required double longitude,
    double? radiusKm,
  }) async {
    return getMosques(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      searchQuery: query,
    );
  }

  @override
  Future<Either<Failure, List<Mosque>>> getCachedMosques() async {
    return _fetchMosquesFromCache();
  }

  // ---------------------------------------------------------------------------
  // Private Helpers
  // ---------------------------------------------------------------------------

  Future<Either<Failure, List<Mosque>>> _fetchMosquesFromCache() async {
    try {
      final results = await localDataSource.getCachedMosques();
      return Right(results);
    } on Exception {
      // If cache is empty, fall back to full mock list
      try {
        final all = await mockDataSource.getMosques(
          latitude: 28.7041,
          longitude: 77.1025,
          page: 1,
          limit: 100,
        );
        return Right(all);
      } catch (e) {
        return const Left(CacheFailure(message: 'No cached data available'));
      }
    }
  }
}
