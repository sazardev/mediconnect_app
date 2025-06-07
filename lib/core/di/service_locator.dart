import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mediconnect_app/core/network/api_client.dart';
import 'package:mediconnect_app/core/storage/local_storage.dart';
import 'package:mediconnect_app/core/websocket/websocket_client.dart';
import 'package:mediconnect_app/data/repositories/appointment_repository_impl.dart';
import 'package:mediconnect_app/data/repositories/auth_repository_impl.dart';
import 'package:mediconnect_app/domain/repositories/appointment_repository.dart';
import 'package:mediconnect_app/domain/repositories/auth_repository.dart';
import 'package:mediconnect_app/domain/usecases/appointment_usecases.dart';
import 'package:mediconnect_app/domain/usecases/auth_usecases.dart';
import 'package:mediconnect_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:mediconnect_app/presentation/blocs/auth/auth_bloc.dart';

/// Clase que gestiona la inyección de dependencias de la aplicación
class ServiceLocator {
  ServiceLocator._();

  /// Instancia singleton
  static final ServiceLocator instance = ServiceLocator._();

  /// Caché de instancias
  final Map<Type, Object> _instances = {};

  /// Inicializa todas las dependencias
  Future<void> init() async {
    // Shared Preferences
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    _instances[SharedPreferences] = sharedPreferences;

    // Core
    _instances[LocalStorage] = LocalStorage(sharedPreferences);
    _instances[ApiClient] = ApiClient(
      client: http.Client(),
      localStorage: get<LocalStorage>(),
    );
    _instances[WebSocketClient] = WebSocketClient(
      localStorage: _instances[LocalStorage] as LocalStorage,
    );

    // Repositories
    _instances[AuthRepository] = AuthRepositoryImpl(
      apiClient: get<ApiClient>(),
      localStorage: get<LocalStorage>(),
    );

    // Registrar el AppointmentRepository
    _instances[AppointmentRepository] = AppointmentRepositoryImpl(
      apiClient: get<ApiClient>(),
    );

    // Use cases - Auth
    _instances[LoginUseCase] = LoginUseCase(get<AuthRepository>());
    _instances[LogoutUseCase] = LogoutUseCase(get<AuthRepository>());
    _instances[RefreshTokenUseCase] = RefreshTokenUseCase(
      get<AuthRepository>(),
    );
    _instances[GetCurrentUserUseCase] = GetCurrentUserUseCase(
      get<AuthRepository>(),
    );
    _instances[IsAuthenticatedUseCase] = IsAuthenticatedUseCase(
      get<AuthRepository>(),
    );

    // Use cases - Appointments
    _instances[GetAppointmentsUseCase] = GetAppointmentsUseCase(
      get<AppointmentRepository>(),
    );
    _instances[GetAppointmentDetailsUseCase] = GetAppointmentDetailsUseCase(
      get<AppointmentRepository>(),
    );
    _instances[CreateAppointmentUseCase] = CreateAppointmentUseCase(
      get<AppointmentRepository>(),
    );
    _instances[UpdateAppointmentUseCase] = UpdateAppointmentUseCase(
      get<AppointmentRepository>(),
    );
    _instances[CancelAppointmentUseCase] = CancelAppointmentUseCase(
      get<AppointmentRepository>(),
    );
    _instances[ConfirmAppointmentUseCase] = ConfirmAppointmentUseCase(
      get<AppointmentRepository>(),
    );
    _instances[CompleteAppointmentUseCase] = CompleteAppointmentUseCase(
      get<AppointmentRepository>(),
    );
    _instances[MarkNoShowUseCase] = MarkNoShowUseCase(
      get<AppointmentRepository>(),
    );
    _instances[RescheduleAppointmentUseCase] = RescheduleAppointmentUseCase(
      get<AppointmentRepository>(),
    );
    _instances[GetAvailableSlotsUseCase] = GetAvailableSlotsUseCase(
      get<AppointmentRepository>(),
    );
    _instances[GetCalendarViewUseCase] = GetCalendarViewUseCase(
      get<AppointmentRepository>(),
    );
    _instances[GetUpcomingAppointmentsUseCase] = GetUpcomingAppointmentsUseCase(
      get<AppointmentRepository>(),
    );
    _instances[GetAppointmentHistoryUseCase] = GetAppointmentHistoryUseCase(
      get<AppointmentRepository>(),
    );
    _instances[BookEmergencyAppointmentUseCase] =
        BookEmergencyAppointmentUseCase(get<AppointmentRepository>());
    _instances[GetDoctorScheduleUseCase] = GetDoctorScheduleUseCase(
      get<AppointmentRepository>(),
    );

    // BLoCs
    _instances[AuthBloc] = AuthBloc(
      loginUseCase: get<LoginUseCase>(),
      logoutUseCase: get<LogoutUseCase>(),
      isAuthenticatedUseCase: get<IsAuthenticatedUseCase>(),
      getCurrentUserUseCase: get<GetCurrentUserUseCase>(),
    );

    // Appointments BLoC
    _instances[AppointmentBloc] = AppointmentBloc(
      getAppointmentsUseCase: get<GetAppointmentsUseCase>(),
      getAppointmentDetailsUseCase: get<GetAppointmentDetailsUseCase>(),
      createAppointmentUseCase: get<CreateAppointmentUseCase>(),
      updateAppointmentUseCase: get<UpdateAppointmentUseCase>(),
      cancelAppointmentUseCase: get<CancelAppointmentUseCase>(),
      confirmAppointmentUseCase: get<ConfirmAppointmentUseCase>(),
      completeAppointmentUseCase: get<CompleteAppointmentUseCase>(),
      markNoShowUseCase: get<MarkNoShowUseCase>(),
      rescheduleAppointmentUseCase: get<RescheduleAppointmentUseCase>(),
      getAvailableSlotsUseCase: get<GetAvailableSlotsUseCase>(),
      getCalendarViewUseCase: get<GetCalendarViewUseCase>(),
      getUpcomingAppointmentsUseCase: get<GetUpcomingAppointmentsUseCase>(),
      getAppointmentHistoryUseCase: get<GetAppointmentHistoryUseCase>(),
      bookEmergencyAppointmentUseCase: get<BookEmergencyAppointmentUseCase>(),
      getDoctorScheduleUseCase: get<GetDoctorScheduleUseCase>(),
    );
  }

  /// Obtiene una instancia registrada por su tipo
  T get<T>() {
    final instance = _instances[T];
    if (instance == null) {
      throw Exception('No se encontró una instancia registrada para $T');
    }
    return instance as T;
  }

  /// Registra una instancia manualmente
  void register<T>(T instance) {
    _instances[T] = instance as Object;
  }
}
