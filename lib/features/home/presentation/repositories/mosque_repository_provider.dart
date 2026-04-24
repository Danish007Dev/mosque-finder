import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/datasources/mosque_local_datasource.dart';
import '../../../../data/datasources/mosque_mock_datasource.dart';
import '../../../../data/repositories/mosque_repository_impl.dart';
import '../../../../domain/entities/mosque.dart';

/// Simplified wrapper for the providers to reference.
/// Converts Either<Failure, List<Mosque>> into a record with hasMore.
class MosqueRepositoryProvider {
  final MosqueRepositoryImpl _repository;

  MosqueRepositoryProvider(this._repository);

  Future<({List<Mosque> mosques, bool hasMore})> getMosques({
    required double latitude,
    required double longitude,
    double? radiusKm,
    int? page,
    int? limit,
    String? searchQuery,
    String? sortBy,
    bool? verifiedOnly,
  }) async {
    final result = await _repository.getMosques(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      page: page,
      limit: limit,
      searchQuery: searchQuery,
      sortBy: sortBy,
      verifiedOnly: verifiedOnly,
    );

    return result.fold(
      (failure) => throw Exception(failure.message),
      (mosques) => (
        mosques: mosques,
        hasMore: mosques.length >= (limit ?? 5),
      ),
    );
  }
}

/// Shared singleton for mosque mock + local data sources.
final _mockDataSource = MosqueMockDataSource();
final _localDataSource = MosqueLocalDataSource();

/// Provider for the mosque repository — uses mock data source.
final mosqueRepositoryProvider = Provider<MosqueRepositoryProvider>((ref) {
  final repository = MosqueRepositoryImpl(
    mockDataSource: _mockDataSource,
    localDataSource: _localDataSource,
  );

  return MosqueRepositoryProvider(repository);
});
