import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mediconnect_app/core/env/env_config.dart';
import 'package:mediconnect_app/core/errors/exceptions.dart';
import 'package:mediconnect_app/core/storage/local_storage.dart';

class ApiClient {
  final http.Client _client;
  final LocalStorage _localStorage;

  ApiClient({required http.Client client, required LocalStorage localStorage})
    : _client = client,
      _localStorage = localStorage;

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse(
        '${EnvConfig.apiBaseUrl}$endpoint',
      ).replace(queryParameters: queryParameters);

      final requestHeaders = await _getHeaders(headers, requiresAuth);

      final response = await _client
          .get(uri, headers: requestHeaders)
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No hay conexión a internet');
    } catch (e) {
      throw e is AppException ? e : UnknownException(e.toString());
    }
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('${EnvConfig.apiBaseUrl}$endpoint');
      final requestHeaders = await _getHeaders(headers, requiresAuth);

      final response = await _client
          .post(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No hay conexión a internet');
    } catch (e) {
      throw e is AppException ? e : UnknownException(e.toString());
    }
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('${EnvConfig.apiBaseUrl}$endpoint');
      final requestHeaders = await _getHeaders(headers, requiresAuth);

      final response = await _client
          .put(
            uri,
            headers: requestHeaders,
            body: body != null ? json.encode(body) : null,
          )
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No hay conexión a internet');
    } catch (e) {
      throw e is AppException ? e : UnknownException(e.toString());
    }
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    try {
      final uri = Uri.parse('${EnvConfig.apiBaseUrl}$endpoint');
      final requestHeaders = await _getHeaders(headers, requiresAuth);

      final response = await _client
          .delete(uri, headers: requestHeaders)
          .timeout(const Duration(seconds: 30));

      return _processResponse(response);
    } on SocketException {
      throw NetworkException('No hay conexión a internet');
    } catch (e) {
      throw e is AppException ? e : UnknownException(e.toString());
    }
  }

  Future<Map<String, String>> _getHeaders(
    Map<String, String>? headers,
    bool requiresAuth,
  ) async {
    final defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _localStorage.getAccessToken();
      if (token != null) {
        defaultHeaders['Authorization'] = 'Bearer $token';
      }
    }

    return {...defaultHeaders, ...?headers};
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        try {
          return response.body.isEmpty ? {} : json.decode(response.body);
        } catch (e) {
          return response.body;
        }
      case 400:
        final responseData = json.decode(response.body);
        throw BadRequestException(
          responseData['message'] ?? 'Solicitud inválida',
          responseData['code'] ?? 'bad_request',
          responseData['detail'] ?? '',
        );
      case 401:
        throw UnauthorizedException('No autorizado. Inicie sesión nuevamente.');
      case 403:
        throw ForbiddenException('No tiene permisos para esta acción.');
      case 404:
        throw NotFoundException('Recurso no encontrado.');
      case 500:
        throw ServerException('Error del servidor. Intente más tarde.');
      default:
        throw UnknownException(
          'Error desconocido. Código: ${response.statusCode}',
        );
    }
  }
}
