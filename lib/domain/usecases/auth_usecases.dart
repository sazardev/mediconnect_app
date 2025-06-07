import 'package:mediconnect_app/domain/entities/auth_tokens.dart';
import 'package:mediconnect_app/domain/entities/user.dart';
import 'package:mediconnect_app/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<(AuthTokens, User)> execute(String email, String password) {
    return _repository.login(email, password);
  }
}

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<void> execute() {
    return _repository.logout();
  }
}

class RefreshTokenUseCase {
  final AuthRepository _repository;

  RefreshTokenUseCase(this._repository);

  Future<AuthTokens> execute(String refreshToken) {
    return _repository.refreshToken(refreshToken);
  }
}

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<User?> execute() {
    return _repository.getCurrentUser();
  }
}

class IsAuthenticatedUseCase {
  final AuthRepository _repository;

  IsAuthenticatedUseCase(this._repository);

  Future<bool> execute() {
    return _repository.isAuthenticated();
  }
}
