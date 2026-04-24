import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/mosque.dart';
import '../repositories/mosque_repository.dart';

/// Use case: Search mosques by name or location
class SearchMosquesUseCase {
  final MosqueRepository repository;

  SearchMosquesUseCase(this.repository);

  Future<Either<Failure, List<Mosque>>> call({
    required String query,
    required double latitude,
    required double longitude,
    double? radiusKm,
  }) async {
    return repository.searchMosques(
      query: query,
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }
}
