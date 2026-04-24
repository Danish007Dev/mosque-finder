import '../../domain/entities/mosque.dart';
import '../../domain/entities/review.dart';

/// Local cache data source that mirrors MosqueMockDataSource.
/// For offline-first support, this wraps the mock data and stores
/// it in Hive boxes so the app can work without network.
class MosqueLocalDataSource {
  /// Cache mosques to local storage
  Future<void> cacheMosques(List<Mosque> mosques) async {
    // In production: write to Hive box
    // For now: no-op (mock data is always available)
  }

  /// Get cached mosques from local storage
  Future<List<Mosque>> getCachedMosques() async {
    // In production: read from Hive box
    // For now: return empty (mock data source handles this)
    return [];
  }

  /// Check if the cache is stale (older than 1 hour)
  Future<bool> isCacheStale() async {
    // In production: check timestamp in shared preferences
    return false;
  }

  /// Clear all cached data
  Future<void> clearCache() async {
    // In production: clear Hive boxes
  }
}
