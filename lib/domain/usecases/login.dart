import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case: Login with email and password
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
  }) async {
    return repository.login(email: email, password: password);
  }
}

/// Use case: Login anonymously
class LoginAnonymouslyUseCase {
  final AuthRepository repository;

  LoginAnonymouslyUseCase(this.repository);

  Future<Either<Failure, AppUser>> call() async {
    return repository.loginAnonymously();
  }
}
