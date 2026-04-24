import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/mosque.dart';
import '../entities/review.dart';

/// Abstract repository interface for mosque data operations
/// Following the repository pattern for clean architecture
abstract class MosqueRepository {
  /// Get a paginated list of mosques near a location
  Future<Either<Failure, List<Mosque>>> getMosques({
    required double latitude,
    required double longitude,
    double? radiusKm,
    int? page,
    int? limit,
    String? searchQuery,
    bool? verifiedOnly,
    String? sortBy,
  });

  /// Get detailed information for a single mosque
  Future<Either<Failure, Mosque>> getMosqueDetail(String mosqueId);

  /// Get reviews for a specific mosque
  Future<Either<Failure, List<Review>>> getMosqueReviews(
    String mosqueId, {
    int? page,
    int? limit,
  });

  /// Search mosques by name or location
  Future<Either<Failure, List<Mosque>>> searchMosques({
    required String query,
    required double latitude,
    required double longitude,
    double? radiusKm,
  });

  /// Get cached mosques for offline access
  Future<Either<Failure, List<Mosque>>> getCachedMosques();
}
