import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:80/api';

  static String get webSocketUrl =>
      dotenv.env['WEB_SOCKET_URL'] ?? 'ws://localhost:8001/ws';
}
