import 'package:mediconnect_app/domain/entities/auth_tokens.dart';
import 'package:mediconnect_app/domain/entities/user.dart';

abstract class AuthRepository {
  /// Inicia sesión con email y contraseña
  Future<(AuthTokens, User)> login(String email, String password);

  /// Refresca el token de acceso usando el refresh token
  Future<AuthTokens> refreshToken(String refreshToken);

  /// Cierra la sesión del usuario
  Future<void> logout();

  /// Verifica si el usuario está autenticado
  Future<bool> isAuthenticated();

  /// Obtiene el usuario actual
  Future<User?> getCurrentUser();
}
