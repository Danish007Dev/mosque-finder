import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/mosque.dart';
import '../entities/review.dart';
import '../repositories/mosque_repository.dart';

/// Use case: Get detailed information for a mosque including reviews
class GetMosqueDetailUseCase {
  final MosqueRepository repository;

  GetMosqueDetailUseCase(this.repository);

  Future<Either<Failure, Mosque>> getDetail(String mosqueId) async {
    return repository.getMosqueDetail(mosqueId);
  }

  Future<Either<Failure, List<Review>>> getReviews(
    String mosqueId, {
    int? page,
    int? limit,
  }) async {
    return repository.getMosqueReviews(mosqueId, page: page, limit: limit);
  }
}
