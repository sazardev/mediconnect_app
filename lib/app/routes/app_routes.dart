import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const Placeholder());
      case login:
        return MaterialPageRoute(builder: (_) => const Placeholder());
      default:
        return MaterialPageRoute(
          builder: (_) => const Placeholder(),
          settings: RouteSettings(name: "Unknown Route"),
        );
    }
  }
}
