import 'package:flutter/material.dart';
import 'package:mediconnect_app/presentation/pages/appointments/appointments_page.dart';
import 'package:mediconnect_app/presentation/pages/auth/login_page.dart';
import 'package:mediconnect_app/presentation/pages/chat/conversations_page.dart';
import 'package:mediconnect_app/presentation/pages/home/home_page.dart';
import 'package:mediconnect_app/presentation/pages/notifications/notifications_page.dart';
import 'package:mediconnect_app/presentation/pages/profile/profile_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String appointments = '/appointments';
  static const String medicalRecords = '/medical-records';
  static const String chat = '/chat';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case appointments:
        return MaterialPageRoute(builder: (_) => const AppointmentsPage());
      case medicalRecords:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(child: Text('Expediente médico')),
        );
      case chat:
        return MaterialPageRoute(builder: (_) => const ConversationsPage());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Ruta no encontrada'))),
          settings: const RouteSettings(name: "Ruta desconocida"),
        );
    }
  }
}
