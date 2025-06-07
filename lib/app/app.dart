import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconnect_app/app/routes/app_routes.dart';
import 'package:mediconnect_app/app/theme/app_theme.dart';
import 'package:mediconnect_app/core/di/service_locator.dart';
import 'package:mediconnect_app/domain/usecases/auth_usecases.dart';
import 'package:mediconnect_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:mediconnect_app/presentation/blocs/auth/auth_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            loginUseCase: ServiceLocator.instance.get<LoginUseCase>(),
            logoutUseCase: ServiceLocator.instance.get<LogoutUseCase>(),
            isAuthenticatedUseCase: ServiceLocator.instance
                .get<IsAuthenticatedUseCase>(),
            getCurrentUserUseCase: ServiceLocator.instance
                .get<GetCurrentUserUseCase>(),
          )..add(AuthCheckStatusEvent()),
        ),
        BlocProvider<AppointmentBloc>(
          create: (context) => ServiceLocator.instance.get<AppointmentBloc>(),
        ),
      ],
      child: MaterialApp(
        title: "MediConnect",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
