import 'dart:async';
import 'dart:convert';
import 'package:mediconnect_app/core/env/env_config.dart';
import 'package:mediconnect_app/core/storage/local_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClient {
  final LocalStorage _localStorage;

  WebSocketClient({required LocalStorage localStorage})
    : _localStorage = localStorage;

  /// Establece conexión a un endpoint de WebSocket con autenticación
  Future<WebSocketConnection> connect(String endpoint) async {
    final token = await _localStorage.getAccessToken();
    final url = '${EnvConfig.webSocketUrl}$endpoint';
    final queryParams = token != null ? '?token=$token' : '';
    return WebSocketConnection(url: '$url$queryParams');
  }

  /// Conectar a las notificaciones del usuario
  Future<WebSocketConnection> connectToNotifications(int userId) async {
    return connect('/notifications/$userId/');
  }

  /// Conectar al chat de una conversación específica
  Future<WebSocketConnection> connectToChat(String conversationId) async {
    return connect('/chat/$conversationId/');
  }
}

/// Gestiona una conexión de WebSocket con reconexión automática
class WebSocketConnection {
  final String url;
  WebSocketChannel? _channel;
  bool _isConnected = false;
  final StreamController<dynamic> _messageStreamController =
      StreamController.broadcast();
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;

  int _reconnectAttempts = 0;
  static const int maxReconnectAttempts = 5;

  WebSocketConnection({required this.url});

  Stream<dynamic> get messageStream => _messageStreamController.stream;
  bool get isConnected => _isConnected;

  /// Inicia la conexión al WebSocket
  Future<void> connect() async {
    if (_channel != null) {
      await close();
    }

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      // Configura la escucha de mensajes
      _channel!.stream.listen(
        (dynamic message) {
          try {
            final data = jsonDecode(message);
            _messageStreamController.add(data);
          } catch (e) {
            _messageStreamController.add({
              'error': 'Error parsing message',
              'raw': message,
            });
          }
        },
        onDone: () {
          _isConnected = false;
          _tryReconnect();
        },
        onError: (error) {
          _isConnected = false;
          _tryReconnect();
        },
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      _startHeartbeat();
    } catch (e) {
      _isConnected = false;
      _tryReconnect();
    }
  }

  /// Envía un mensaje al servidor
  Future<void> send(Map<String, dynamic> message) async {
    if (!_isConnected || _channel == null) {
      await connect();
    }

    try {
      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      // Si falla el envío, intentamos reconectar
      _isConnected = false;
      await connect();
      // Reintentamos el envío después de reconectar
      _channel?.sink.add(jsonEncode(message));
    }
  }

  /// Cierra la conexión
  Future<void> close() async {
    _stopReconnect();
    _stopHeartbeat();
    await _channel?.sink.close();
    _channel = null;
    _isConnected = false;
  }

  /// Intenta reconectar con backoff exponencial
  void _tryReconnect() {
    _stopReconnect();

    if (_reconnectAttempts >= maxReconnectAttempts) {
      return;
    }

    _reconnectTimer = Timer(
      Duration(seconds: (_reconnectAttempts + 1) * 2), // Backoff exponencial
      () async {
        _reconnectAttempts++;
        await connect();
      },
    );
  }

  /// Detiene los intentos de reconexión
  void _stopReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  /// Inicia envío de heartbeats para mantener conexión activa
  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_isConnected && _channel != null) {
        try {
          _channel!.sink.add(jsonEncode({'type': 'heartbeat'}));
        } catch (_) {
          // Si falla el heartbeat, intentamos reconectar
          _isConnected = false;
          connect();
        }
      }
    });
  }

  /// Detiene el envío de heartbeats
  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Libera recursos
  void dispose() {
    close();
    _messageStreamController.close();
  }
}

/// Ya no necesitamos esta clase ya que usamos directamente WebSocketChannel
