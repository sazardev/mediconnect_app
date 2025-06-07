import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mediconnect_app/app/app.dart';
import 'package:mediconnect_app/core/di/service_locator.dart';

void main() async {
  // Asegurarse de que Flutter esté inicializado
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: '.env');

  // Inicializar inyección de dependencias
  await ServiceLocator.instance.init();

  runApp(const App());
}
