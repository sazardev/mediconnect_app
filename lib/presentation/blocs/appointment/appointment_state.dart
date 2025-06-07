import 'package:equatable/equatable.dart';
import 'package:mediconnect_app/domain/entities/appointment.dart';

/// Estado base para el bloc de citas
abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AppointmentInitialState extends AppointmentState {
  const AppointmentInitialState();
}

/// Estado de carga
class AppointmentLoadingState extends AppointmentState {
  const AppointmentLoadingState();
}

/// Estado de error
class AppointmentErrorState extends AppointmentState {
  /// Mensaje de error
  final String message;

  const AppointmentErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// Estado para la lista de citas cargada
class AppointmentListLoadedState extends AppointmentState {
  /// Lista de citas
  final List<Appointment> appointments;

  const AppointmentListLoadedState(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

/// Estado para los detalles de una cita cargados
class AppointmentDetailsLoadedState extends AppointmentState {
  /// Datos de la cita
  final Appointment appointment;

  const AppointmentDetailsLoadedState(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

/// Estado para una acción completada exitosamente
class AppointmentSuccessState extends AppointmentState {
  /// Mensaje de éxito
  final String message;

  /// Datos adicionales opcionales
  final dynamic data;

  const AppointmentSuccessState(this.message, {this.data});

  @override
  List<Object?> get props => [message, data];
}

/// Estado para horarios disponibles cargados
class AppointmentAvailableSlotsLoadedState extends AppointmentState {
  /// Datos de horarios disponibles
  final AvailableSlotsResponse availableSlots;

  const AppointmentAvailableSlotsLoadedState(this.availableSlots);

  @override
  List<Object?> get props => [availableSlots];
}

/// Estado para vista de calendario cargada
class AppointmentCalendarLoadedState extends AppointmentState {
  /// Datos del calendario
  final CalendarView calendarView;

  const AppointmentCalendarLoadedState(this.calendarView);

  @override
  List<Object?> get props => [calendarView];
}

/// Estado para próximas citas cargadas
class AppointmentUpcomingLoadedState extends AppointmentState {
  /// Lista de próximas citas
  final List<Appointment> appointments;

  const AppointmentUpcomingLoadedState(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

/// Estado para historial de citas cargado
class AppointmentHistoryLoadedState extends AppointmentState {
  /// Lista del historial de citas
  final List<Appointment> appointments;

  const AppointmentHistoryLoadedState(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

/// Estado para horario de doctor cargado
class AppointmentDoctorScheduleLoadedState extends AppointmentState {
  /// Lista de horarios disponibles
  final List<AvailableSlotsResponse> schedules;

  const AppointmentDoctorScheduleLoadedState(this.schedules);

  @override
  List<Object?> get props => [schedules];
}
