import 'package:equatable/equatable.dart';

/// Clase base para los eventos relacionados con citas
abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para cargar la lista de citas
class AppointmentLoadListEvent extends AppointmentEvent {
  /// Filtros opcionales para la búsqueda
  final Map<String, dynamic>? filters;

  const AppointmentLoadListEvent({this.filters});

  @override
  List<Object?> get props => [filters];
}

/// Evento para cargar los detalles de una cita
class AppointmentLoadDetailsEvent extends AppointmentEvent {
  /// ID de la cita
  final int appointmentId;

  const AppointmentLoadDetailsEvent(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// Evento para crear una nueva cita
class AppointmentCreateEvent extends AppointmentEvent {
  /// Datos de la cita
  final Map<String, dynamic> appointmentData;

  const AppointmentCreateEvent(this.appointmentData);

  @override
  List<Object?> get props => [appointmentData];
}

/// Evento para actualizar una cita existente
class AppointmentUpdateEvent extends AppointmentEvent {
  /// ID de la cita
  final int appointmentId;

  /// Datos actualizados
  final Map<String, dynamic> appointmentData;

  const AppointmentUpdateEvent(this.appointmentId, this.appointmentData);

  @override
  List<Object?> get props => [appointmentId, appointmentData];
}

/// Evento para cancelar una cita
class AppointmentCancelEvent extends AppointmentEvent {
  /// ID de la cita
  final int appointmentId;

  /// Motivo de cancelación
  final String? reason;

  const AppointmentCancelEvent(this.appointmentId, {this.reason});

  @override
  List<Object?> get props => [appointmentId, reason];
}

/// Evento para confirmar una cita (como doctor)
class AppointmentConfirmEvent extends AppointmentEvent {
  /// ID de la cita
  final int appointmentId;

  const AppointmentConfirmEvent(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

/// Evento para marcar una cita como completada
class AppointmentCompleteEvent extends AppointmentEvent {
  /// ID de la cita
  final int appointmentId;

  /// Notas opcionales
  final String? notes;

  const AppointmentCompleteEvent(this.appointmentId, {this.notes});

  @override
  List<Object?> get props => [appointmentId, notes];
}

/// Evento para marcar a un paciente como no asistido
class AppointmentMarkNoShowEvent extends AppointmentEvent {
  /// ID de la cita
  final int appointmentId;

  /// Notas opcionales
  final String? notes;

  const AppointmentMarkNoShowEvent(this.appointmentId, {this.notes});

  @override
  List<Object?> get props => [appointmentId, notes];
}

/// Evento para reprogramar una cita
class AppointmentRescheduleEvent extends AppointmentEvent {
  /// ID de la cita
  final int appointmentId;

  /// Nueva fecha y hora
  final DateTime newDate;

  /// Motivo del cambio
  final String? reason;

  const AppointmentRescheduleEvent(
    this.appointmentId,
    this.newDate, {
    this.reason,
  });

  @override
  List<Object?> get props => [appointmentId, newDate, reason];
}

/// Evento para cargar horarios disponibles
class AppointmentLoadAvailableSlotsEvent extends AppointmentEvent {
  /// ID del doctor
  final int doctorId;

  /// Fecha (YYYY-MM-DD)
  final String? date;

  /// ID de la clínica
  final String? clinicId;

  const AppointmentLoadAvailableSlotsEvent(
    this.doctorId, {
    this.date,
    this.clinicId,
  });

  @override
  List<Object?> get props => [doctorId, date, clinicId];
}

/// Evento para cargar la vista de calendario
class AppointmentLoadCalendarEvent extends AppointmentEvent {
  /// Mes (YYYY-MM)
  final String? month;

  const AppointmentLoadCalendarEvent({this.month});

  @override
  List<Object?> get props => [month];
}

/// Evento para cargar próximas citas
class AppointmentLoadUpcomingEvent extends AppointmentEvent {
  const AppointmentLoadUpcomingEvent();
}

/// Evento para cargar historial de citas
class AppointmentLoadHistoryEvent extends AppointmentEvent {
  const AppointmentLoadHistoryEvent();
}

/// Evento para agendar cita de emergencia
class AppointmentBookEmergencyEvent extends AppointmentEvent {
  /// Datos de la cita de emergencia
  final Map<String, dynamic> emergencyData;

  const AppointmentBookEmergencyEvent(this.emergencyData);

  @override
  List<Object?> get props => [emergencyData];
}

/// Evento para cargar horario de doctor
class AppointmentLoadDoctorScheduleEvent extends AppointmentEvent {
  /// ID del doctor
  final int doctorId;

  /// Fecha de inicio (YYYY-MM-DD)
  final String? startDate;

  /// Fecha de fin (YYYY-MM-DD)
  final String? endDate;

  const AppointmentLoadDoctorScheduleEvent(
    this.doctorId, {
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [doctorId, startDate, endDate];
}
