import 'package:flutter/material.dart';
import 'package:mediconnect_app/app/routes/app_routes.dart';
import 'package:mediconnect_app/app/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MediConnect",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
