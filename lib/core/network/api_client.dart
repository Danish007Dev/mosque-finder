import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../constants/api_constants.dart';
import '../errors/app_exception.dart';

/// Core API client wrapping Dio for HTTP operations
/// Handles base configuration, interceptors, and error mapping
class ApiClient {
  late final Dio _dio;
  final Logger _logger = Logger();

  ApiClient({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          ApiConstants.contentTypeHeader: ApiConstants.contentTypeJson,
        },
      ),
    );

    _dio.interceptors.addAll([
      _loggingInterceptor(),
      _errorInterceptor(),
    ]);

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => _logger.d(obj.toString()),
        ),
      );
    }
  }

  /// GET request
  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// POST request
  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// PUT request
  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// DELETE request
  Future<Response<dynamic>> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  /// Set authorization token
  void setAuthToken(String token) {
    _dio.options.headers[ApiConstants.authHeader] =
        '${ApiConstants.bearerPrefix}$token';
  }

  /// Remove authorization token
  void removeAuthToken() {
    _dio.options.headers.remove(ApiConstants.authHeader);
  }

  /// Set accept language header
  void setLanguage(String languageCode) {
    _dio.options.headers[ApiConstants.acceptLanguageHeader] = languageCode;
  }

  /// Cancel all active requests
  void cancelRequests() {
    // In production, manage cancel tokens per request
  }

  // ---------------------------------------------------------------------------
  // Private Helpers
  // ---------------------------------------------------------------------------

  InterceptorsWrapper _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i('➡️ [${options.method}] ${options.path}');
        handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('⬅️ [${response.statusCode}] ${response.requestOptions.path}');
        handler.next(response);
      },
      onError: (error, handler) {
        _logger.e('❌ [${error.response?.statusCode}] ${error.requestOptions.path}');
        handler.next(error);
      },
    );
  }

  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle token refresh in production
        }
        handler.next(error);
      },
    );
  }

  AppException _mapDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(message: 'Connection timed out');

      case DioExceptionType.connectionError:
        return const NetworkException(message: 'No internet connection');

      case DioExceptionType.badResponse:
        final statusCode = exception.response?.statusCode ?? 0;
        final message = _extractErrorMessage(exception.response) ??
            'Server error occurred';

        if (statusCode >= 500) {
          return ServerException(
            message: message,
            statusCode: statusCode,
          );
        } else if (statusCode == 401) {
          return AuthException(message: message);
        } else if (statusCode == 404) {
          return const AppException(
            message: 'Resource not found',
            statusCode: 404,
          );
        } else {
          return ClientException(
            message: message,
            statusCode: statusCode,
          );
        }

      case DioExceptionType.cancel:
        return const AppException(message: 'Request cancelled', code: 'CANCELLED');

      case DioExceptionType.badCertificate:
        return const NetworkException(message: 'SSL certificate error');

      case DioExceptionType.unknown:
      default:
        return const NetworkException(message: 'Unexpected network error');
    }
  }

  String? _extractErrorMessage(Response<dynamic>? response) {
    try {
      if (response?.data is Map) {
        return (response!.data as Map<String, dynamic>)['message'] as String? ??
            (response.data as Map<String, dynamic>)['error'] as String?;
      }
      return response?.statusMessage;
    } catch (_) {
      return null;
    }
  }
}
