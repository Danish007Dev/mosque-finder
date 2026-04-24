import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/mosque.dart';
import '../repositories/mosque_repository.dart';

/// Use case: Get a paginated list of mosques near a location
class GetMosquesUseCase {
  final MosqueRepository repository;

  GetMosquesUseCase(this.repository);

  Future<Either<Failure, List<Mosque>>> call({
    required double latitude,
    required double longitude,
    double? radiusKm,
    int? page,
    int? limit,
    String? searchQuery,
    bool? verifiedOnly,
    String? sortBy,
  }) async {
    return repository.getMosques(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      page: page,
      limit: limit,
      searchQuery: searchQuery,
      verifiedOnly: verifiedOnly,
      sortBy: sortBy,
    );
  }
}
