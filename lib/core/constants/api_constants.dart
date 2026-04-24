/// API Constants for mosque data endpoints
class ApiConstants {
  ApiConstants._();

  // Base URL - configurable via env
  static const String baseUrlKey = 'API_BASE_URL';
  static const String defaultBaseUrl = 'https://api.mosquefinder.dev';

  // Endpoints
  static const String mosquesEndpoint = '/api/v1/mosques';
  static const String mosqueDetailEndpoint = '/api/v1/mosques/{id}';
  static const String reviewsEndpoint = '/api/v1/mosques/{id}/reviews';
  static const String authLoginEndpoint = '/api/v1/auth/login';
  static const String authRefreshEndpoint = '/api/v1/auth/refresh';

  // Query Parameters
  static const String paramLatitude = 'lat';
  static const String paramLongitude = 'lng';
  static const String paramRadius = 'radius';
  static const String paramPage = 'page';
  static const String paramLimit = 'limit';
  static const String paramSearch = 'search';
  static const String paramVerified = 'verified';
  static const String paramSortBy = 'sort_by';

  // Headers
  static const String authHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String contentTypeHeader = 'Content-Type';
  static const String contentTypeJson = 'application/json';
  static const String acceptLanguageHeader = 'Accept-Language';

  // Cache Keys
  static const String cachedMosquesKey = 'CACHED_MOSQUES';
  static const String cachedMosqueDetailKey = 'CACHED_MOSQUE_DETAIL_';
  static const String lastFetchTimeKey = 'LAST_FETCH_TIME';

  // Cache duration
  static const Duration cacheDuration = Duration(hours: 1);

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
