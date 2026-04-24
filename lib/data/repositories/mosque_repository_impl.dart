import 'dart:math' show cos, sin, sqrt, atan2, pi;

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/mosque.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/mosque_repository.dart';
import '../datasources/mosque_local_datasource.dart';
import '../datasources/mosque_mock_datasource.dart';

/// Implementation of [MosqueRepository] that consumes
/// [MosqueMockDataSource] instead of any live HTTP client.
///
/// * Applies a 1-second [Future.delayed] to simulate network
///   latency before returning data.
/// * Returns **5 items per page** with explicit pagination logic.
/// * Falls back to local cache / full list on error.
class MosqueRepositoryImpl implements MosqueRepository {
  final MosqueMockDataSource mockDataSource;
  final MosqueLocalDataSource localDataSource;

  MosqueRepositoryImpl({
    required this.mockDataSource,
    required this.localDataSource,
  });

  // ------------------------------------------------------------------
  // getMosques -- with explicit 1 s delay + pagination (5 per page)
  // ------------------------------------------------------------------
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
      // 1. Simulate network latency
      await Future.delayed(const Duration(seconds: 1));

      // 2. Grab the full mock list (5 mosques)
      final allMosques = await mockDataSource.getAllMosques();

      // 3. Filter -- search query
      List<Mosque> filtered = List<Mosque>.from(allMosques);
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        filtered = filtered.where((m) {
          return m.name.toLowerCase().contains(q) ||
              (m.address?.toLowerCase().contains(q) ?? false) ||
              (m.nameAr?.toLowerCase().contains(q) ?? false);
        }).toList();
      }

      // 4. Filter -- verified only
      if (verifiedOnly == true) {
        filtered = filtered.where((m) => m.isVerified).toList();
      }

      // 5. Compute distance & filter by radius
      filtered = filtered.map((m) {
        final dist = _calculateDistance(
          lat1: latitude,
          lng1: longitude,
          lat2: m.latitude,
          lng2: m.longitude,
        );
        if (radiusKm != null && dist > radiusKm) return null;
        return m.copyWith(distanceKm: dist);
      }).whereType<Mosque>().toList();

      // 6. Sort
      switch (sortBy) {
        case 'rating':
          filtered.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case 'reviews':
          filtered.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
          break;
        case 'distance':
        default:
          filtered.sort((a, b) =>
              (a.distanceKm ?? double.infinity)
                  .compareTo(b.distanceKm ?? double.infinity));
      }

      // 7. Paginate -- 5 items per page
      const int itemsPerPage = 5;
      final int p = page ?? 1;
      final int l = limit ?? itemsPerPage;
      final int start = (p - 1) * l;
      final int end = start + l;

      List<Mosque> paginated;
      bool hasMore = false;
      if (start >= filtered.length) {
        paginated = [];
        hasMore = false;
      } else {
        paginated = filtered.sublist(
          start,
          end > filtered.length ? filtered.length : end,
        );
        hasMore = end < filtered.length;
      }

      // 8. Cache first page for offline access
      if (p == 1) {
        try {
          await localDataSource.cacheMosques(paginated);
        } catch (_) {
          // best-effort
        }
      }

      return Right(paginated);
    } on Exception catch (e) {
      return _fallback(e);
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
      await Future.delayed(const Duration(milliseconds: 600));
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

  // ------------------------------------------------------------------
  // searchMosques -- delegates to getMosques
  // ------------------------------------------------------------------
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

  // ------------------------------------------------------------------
  // getCachedMosques
  // ------------------------------------------------------------------
  @override
  Future<Either<Failure, List<Mosque>>> getCachedMosques() async {
    return _fallback(null);
  }

  // ------------------------------------------------------------------
  // Private helpers
  // ------------------------------------------------------------------

  Future<Either<Failure, List<Mosque>>> _fallback(dynamic error) async {
    // Try local cache first
    try {
      final cached = await localDataSource.getCachedMosques();
      return Right(cached);
    } on Exception {
      // Fall back to full mock list
      try {
        final all = await mockDataSource.getAllMosques();
        return Right(all);
      } catch (e) {
        return const Left(CacheFailure(message: 'No cached data available'));
      }
    }
  }

  /// Haversine formula for distance in kilometres.
  double _calculateDistance({
    required double lat1,
    required double lng1,
    required double lat2,
    required double lng2,
  }) {
    const double earthRadius = 6371.0;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLng = _toRadians(lng2 - lng1);
    final double a = _sinSq(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            _sinSq(dLng / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * pi / 180.0;
  double _sinSq(double x) {
    final s = sin(x);
    return s * s;
  }
}
