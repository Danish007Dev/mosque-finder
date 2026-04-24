import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract repository interface for authentication
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  });

  /// Login anonymously
  Future<Either<Failure, AppUser>> loginAnonymously();

  /// Register a new user
  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Get currently cached user
  Future<Either<Failure, AppUser?>> getCurrentUser();

  /// Check if user is authenticated
  Future<Either<Failure, bool>> isAuthenticated();

  /// Refresh authentication token
  Future<Either<Failure, String>> refreshToken();

  /// Stream auth state changes
  Stream<AppUser?> authStateChanges();
}
