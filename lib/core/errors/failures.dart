import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Abstract Failure class for domain layer error handling
/// Using dartz Either<Failure, T> pattern
@immutable
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;
  final String? code;

  const Failure({
    required this.message,
    this.statusCode,
    this.code,
  });

  @override
  List<Object?> get props => [message, statusCode, code];
}

/// Failure for server-related errors
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error',
    super.statusCode,
    super.code = 'SERVER_ERROR',
  });
}

/// Failure for network/connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
  });
}

/// Failure for cache/offline data issues
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache read failed',
    super.code = 'CACHE_ERROR',
  });
}

/// Failure for authentication issues
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed',
    super.statusCode = 401,
    super.code = 'AUTH_ERROR',
  });
}

/// Failure for location permission issues
class LocationFailure extends Failure {
  const LocationFailure({
    super.message = 'Location permission not granted',
    super.code = 'LOCATION_ERROR',
  });
}

/// Failure for not found
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.statusCode = 404,
    super.code = 'NOT_FOUND',
  });
}

/// Failure for generic/unknown errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred',
    super.code = 'UNKNOWN_ERROR',
  });
}
