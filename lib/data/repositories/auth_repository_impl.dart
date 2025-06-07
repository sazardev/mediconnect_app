import 'package:mediconnect_app/core/network/api_client.dart';
import 'package:mediconnect_app/core/storage/local_storage.dart';
import 'package:mediconnect_app/data/models/auth_tokens_model.dart';
import 'package:mediconnect_app/data/models/user_model.dart';
import 'package:mediconnect_app/domain/entities/auth_tokens.dart';
import 'package:mediconnect_app/domain/entities/user.dart';
import 'package:mediconnect_app/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  AuthRepositoryImpl({
    required ApiClient apiClient,
    required LocalStorage localStorage,
  }) : _apiClient = apiClient,
       _localStorage = localStorage;

  @override
  Future<(AuthTokens, User)> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        '/auth/login/',
        body: {'email': email, 'password': password},
        requiresAuth: false,
      );

      final tokens = AuthTokensModel.fromJson(response);
      final user = UserModel.fromJson(response['user']);

      // Guardar tokens y datos de usuario
      await _localStorage.saveTokens(
        tokens.accessToken,
        tokens.refreshToken ?? '',
      );
      await _localStorage.saveUser(user);

      return (tokens, user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthTokens> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        '/auth/refresh/',
        body: {'refresh': refreshToken},
        requiresAuth: false,
      );

      final newToken = AuthTokensModel.fromJson(response);

      // Guardar nuevo access token
      await _localStorage.saveTokens(
        newToken.accessToken,
        refreshToken, // Mantener el mismo refresh token
      );

      return newToken;
    } catch (e) {
      // Si falla el refresh, forzamos logout
      await logout();
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await _localStorage.clearAll();
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _localStorage.getAccessToken();
    return token != null;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _localStorage.getUser();
  }
}
