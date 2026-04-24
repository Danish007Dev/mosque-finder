import 'dart:convert';

import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../core/network/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

/// Implementation of AuthRepository with mock JWT authentication
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required ApiClient apiClient,
    required AuthLocalDataSource localDataSource,
  })  : _apiClient = apiClient,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, AppUser>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Mock authentication - in production, this hits the API
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      // Mock validation
      if (email.isEmpty || password.isEmpty) {
        return const Left(AuthFailure(message: 'Email and password are required'));
      }

      // Mock successful login
      final user = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email,
        createdAt: DateTime.now(),
        lastLoginAt: DateTime.now(),
        token: _generateMockJwt(email),
        refreshToken: _generateMockJwt('refresh_$email'),
      );

      // Save locally
      await _localDataSource.saveUser(UserModel.fromEntity(user));
      _apiClient.setAuthToken(user.token!);

      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: 'Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> loginAnonymously() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final user = AppUser(
        id: 'anon_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Guest User',
        email: 'guest@mosquefinder.app',
        createdAt: DateTime.now(),
        token: _generateMockJwt('guest'),
      );

      await _localDataSource.saveUser(UserModel.fromEntity(user));
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: 'Anonymous login failed'));
    }
  }

  @override
  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        return const Left(AuthFailure(message: 'All fields are required'));
      }

      if (password.length < 6) {
        return const Left(
            AuthFailure(message: 'Password must be at least 6 characters'));
      }

      final user = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        createdAt: DateTime.now(),
        token: _generateMockJwt(email),
      );

      await _localDataSource.saveUser(UserModel.fromEntity(user));
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: 'Registration failed'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearAuth();
      _apiClient.removeAuthToken();
      return const Right(null);
    } catch (e) {
      return const Left(AuthFailure(message: 'Logout failed'));
    }
  }

  @override
  Future<Either<Failure, AppUser?>> getCurrentUser() async {
    try {
      final user = await _localDataSource.getUser();
      return Right(user?.toEntity());
    } catch (e) {
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final isAuth = await _localDataSource.isAuthenticated();
      return Right(isAuth);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      // Mock token refresh
      await Future.delayed(const Duration(milliseconds: 200));
      final currentUser = await _localDataSource.getUser();
      if (currentUser?.token == null) {
        return const Left(AuthFailure(message: 'No token to refresh'));
      }
      final newToken = _generateMockJwt(
          currentUser!.email); // In real app, call refresh endpoint
      await _localDataSource.saveToken(newToken);
      return Right(newToken);
    } catch (e) {
      return Left(AuthFailure(message: 'Token refresh failed'));
    }
  }

  @override
  Stream<AppUser?> authStateChanges() async* {
    yield await _localDataSource.getUser().then((u) => u?.toEntity());
    // In production, use a proper auth state listener
  }

  /// Generate a mock JWT token for development
  String _generateMockJwt(String payload) {
    final header = _base64Encode('{"alg":"HS256","typ":"JWT"}');
    final body = _base64Encode(
      '{"sub":"$payload","iat":${DateTime.now().millisecondsSinceEpoch ~/ 1000},"exp":${DateTime.now().add(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000}}',
    );
    final signature = _base64Encode('mock_signature_${payload}_mosque_finder');
    return '$header.$body.$signature';
  }

  String _base64Encode(String str) {
    return base64Encode(utf8.encode(str));
  }
}
