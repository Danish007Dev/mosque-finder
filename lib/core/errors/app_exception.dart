import 'package:equatable/equatable.dart';

/// Base exception class for application-specific errors
class AppException extends Equatable implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  const AppException({
    required this.message,
    this.statusCode,
    this.code,
  });

  @override
  List<Object?> get props => [message, statusCode, code];

  @override
  String toString() =>
      'AppException(code: $code, statusCode: $statusCode, message: $message)';
}

/// Exception for network-related errors
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network error occurred',
    super.statusCode,
    super.code = 'NETWORK_ERROR',
  });
}

/// Exception for server errors (5xx)
class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error occurred',
    super.statusCode,
    super.code = 'SERVER_ERROR',
  });
}

/// Exception for client errors (4xx)
class ClientException extends AppException {
  const ClientException({
    super.message = 'Client error occurred',
    super.statusCode,
    super.code = 'CLIENT_ERROR',
  });
}

/// Exception for cache errors
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error occurred',
    super.code = 'CACHE_ERROR',
  });
}

/// Exception for authentication errors
class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication failed',
    super.statusCode = 401,
    super.code = 'AUTH_ERROR',
  });
}

/// Exception for location permission errors
class LocationException extends AppException {
  const LocationException({
    super.message = 'Location permission denied',
    super.code = 'LOCATION_ERROR',
  });
}

/// Exception for parsing errors
class ParseException extends AppException {
  const ParseException({
    super.message = 'Data parsing error occurred',
    super.code = 'PARSE_ERROR',
  });
}
