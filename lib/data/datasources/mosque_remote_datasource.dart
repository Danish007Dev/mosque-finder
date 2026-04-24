import '../../core/constants/api_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../core/network/api_client.dart';
import '../models/mosque_model.dart';
import '../models/review_model.dart';

/// Remote data source for mosque data from API
class MosqueRemoteDataSource {
  final ApiClient _apiClient;

  MosqueRemoteDataSource(this._apiClient);

  /// Fetch paginated mosques near a location
  Future<List<MosqueModel>> getMosques({
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
      final queryParams = <String, dynamic>{
        ApiConstants.paramLatitude: latitude,
        ApiConstants.paramLongitude: longitude,
        if (radiusKm != null) ApiConstants.paramRadius: radiusKm,
        if (page != null) ApiConstants.paramPage: page,
        if (limit != null) ApiConstants.paramLimit: limit,
        if (searchQuery != null && searchQuery.isNotEmpty)
          ApiConstants.paramSearch: searchQuery,
        if (verifiedOnly == true) ApiConstants.paramVerified: true,
        if (sortBy != null) ApiConstants.paramSortBy: sortBy,
      };

      final response = await _apiClient.get(
        ApiConstants.mosquesEndpoint,
        queryParameters: queryParams,
      );

      final List<dynamic> data = _extractDataList(response.data);
      return data
          .map((json) => MosqueModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw const AppException(message: 'Failed to fetch mosques');
    }
  }

  /// Fetch detailed information for a single mosque
  Future<MosqueModel> getMosqueDetail(String mosqueId) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.mosqueDetailEndpoint.replaceFirst('{id}', mosqueId),
      );

      final data = _extractData(response.data);
      return MosqueModel.fromJson(data as Map<String, dynamic>);
    } on AppException {
      rethrow;
    } catch (e) {
      throw const AppException(message: 'Failed to fetch mosque details');
    }
  }

  /// Fetch reviews for a mosque
  Future<List<ReviewModel>> getMosqueReviews(
    String mosqueId, {
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        if (page != null) ApiConstants.paramPage: page,
        if (limit != null) ApiConstants.paramLimit: limit,
      };

      final response = await _apiClient.get(
        ApiConstants.reviewsEndpoint.replaceFirst('{id}', mosqueId),
        queryParameters: queryParams,
      );

      final List<dynamic> data = _extractDataList(response.data);
      return data
          .map((json) => ReviewModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw const AppException(message: 'Failed to fetch reviews');
    }
  }

  /// Search mosques by query
  Future<List<MosqueModel>> searchMosques({
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

  /// Extract data list from API response envelope
  List<dynamic> _extractDataList(dynamic response) {
    if (response is List) return response;
    if (response is Map<String, dynamic>) {
      return (response['data'] as List<dynamic>?) ??
          (response['results'] as List<dynamic>?) ??
          (response['mosques'] as List<dynamic>?) ??
          [];
    }
    return [];
  }

  /// Extract single data object from API response envelope
  dynamic _extractData(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response['data'] ?? response['mosque'] ?? response;
    }
    return response;
  }
}
