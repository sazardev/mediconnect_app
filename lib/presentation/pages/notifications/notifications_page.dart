import 'package:flutter/material.dart';
import 'package:mediconnect_app/presentation/widgets/navigation/main_bottom_navigation_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _notifications = [];
  bool _isConnected = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _connectToNotifications();

    // Agregar algunas notificaciones de ejemplo para mostrar la UI
    _loadSampleNotifications();
  }

  @override
  void dispose() {
    // Nada que limpiar por ahora
    super.dispose();
  }

  Future<void> _connectToNotifications() async {
    // En una implementación real, nos conectaríamos al WebSocket
    // pero como es un MVP, simplemente simulamos estar conectados
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isConnected = true;
      _isLoading = false;
    });

    // En una implementación real, escucharíamos eventos así:
    // final authState = context.read<AuthBloc>().state;
    // if (authState.user != null) {
    //   final userId = authState.user!.id;
    //   // Conectar al WebSocket...
    // }
  }

  void _loadSampleNotifications() {
    // Añadimos notificaciones de ejemplo
    setState(() {
      _notifications.addAll([
        NotificationItem(
          id: '1',
          title: 'Cita confirmada',
          body:
              'Su cita con Dr. Juan Pérez ha sido confirmada para el 10 de Junio a las 15:30.',
          type: 'appointment',
          isRead: false,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        NotificationItem(
          id: '2',
          title: 'Nuevo mensaje',
          body: 'Ha recibido un nuevo mensaje de Dr. Carlos Ruiz.',
          type: 'message',
          isRead: true,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NotificationItem(
          id: '3',
          title: 'Resultados disponibles',
          body: 'Los resultados de su análisis de sangre ya están disponibles.',
          type: 'medical_record',
          isRead: true,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ]);
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere(
        (notification) => notification.id == id,
      );
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  void _deleteNotification(String id) {
    setState(() {
      _notifications.removeWhere((notification) => notification.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _connectToNotifications,
            tooltip: 'Reconectar',
          ),
        ],
      ),
      bottomNavigationBar: const MainBottomNavigationBar(currentIndex: 0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes notificaciones',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isConnected
                        ? 'Conectado y listo para recibir notificaciones'
                        : 'No conectado. Toque refrescar para intentar de nuevo',
                    style: TextStyle(
                      fontSize: 14,
                      color: _isConnected ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _NotificationTile(
                  notification: notification,
                  onTap: () => _markAsRead(notification.id),
                  onDelete: () => _deleteNotification(notification.id),
                );
              },
            ),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime timestamp;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.timestamp,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    bool? isRead,
    DateTime? timestamp,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case 'appointment':
        iconData = Icons.calendar_today;
        iconColor = Colors.blue;
        break;
      case 'message':
        iconData = Icons.chat_bubble_outline;
        iconColor = Colors.green;
        break;
      case 'medical_record':
        iconData = Icons.folder_outlined;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColor = Colors.purple;
    }

    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.2),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(notification.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
        onTap: onTap,
        trailing: notification.isRead
            ? null
            : Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Hoy ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day - 1) {
      return 'Ayer ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
