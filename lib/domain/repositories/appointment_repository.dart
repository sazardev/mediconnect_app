import 'package:mediconnect_app/domain/entities/appointment.dart';

/// Repositorio para gestionar citas médicas
abstract class AppointmentRepository {
  /// Obtiene todas las citas del usuario actual
  ///
  /// [filters] Filtros opcionales para la búsqueda de citas
  Future<List<Appointment>> getAppointments({Map<String, dynamic>? filters});

  /// Obtiene los detalles de una cita específica
  ///
  /// [appointmentId] ID de la cita
  Future<Appointment> getAppointmentDetails(int appointmentId);

  /// Crea una nueva cita
  ///
  /// [appointmentData] Datos de la cita a crear
  Future<Appointment> createAppointment(Map<String, dynamic> appointmentData);

  /// Actualiza una cita existente
  ///
  /// [appointmentId] ID de la cita a actualizar
  /// [appointmentData] Datos actualizados
  Future<Appointment> updateAppointment(
    int appointmentId,
    Map<String, dynamic> appointmentData,
  );

  /// Cancela una cita
  ///
  /// [appointmentId] ID de la cita a cancelar
  /// [reason] Motivo de la cancelación
  Future<bool> cancelAppointment(int appointmentId, {String? reason});

  /// Confirma una cita (como doctor)
  ///
  /// [appointmentId] ID de la cita a confirmar
  Future<bool> confirmAppointment(int appointmentId);

  /// Marca una cita como completada
  ///
  /// [appointmentId] ID de la cita a completar
  /// [notes] Notas opcionales de la consulta
  Future<bool> completeAppointment(int appointmentId, {String? notes});

  /// Marca a un paciente como no asistido
  ///
  /// [appointmentId] ID de la cita
  /// [notes] Notas opcionales
  Future<bool> markNoShow(int appointmentId, {String? notes});

  /// Reprograma una cita
  ///
  /// [appointmentId] ID de la cita a reprogramar
  /// [newDate] Nueva fecha y hora
  /// [reason] Motivo del cambio
  Future<Appointment> rescheduleAppointment(
    int appointmentId,
    DateTime newDate, {
    String? reason,
  });

  /// Obtiene los horarios disponibles de un doctor
  ///
  /// [doctorId] ID del doctor
  /// [date] Fecha para consultar (YYYY-MM-DD)
  Future<AvailableSlotsResponse> getAvailableSlots(
    int doctorId, {
    String? date,
    String? clinicId,
  });

  /// Obtiene la vista de calendario del usuario
  ///
  /// [month] Mes en formato YYYY-MM
  Future<CalendarView> getCalendarView({String? month});

  /// Obtiene las próximas citas del usuario
  Future<List<Appointment>> getUpcomingAppointments();

  /// Obtiene el historial de citas del usuario
  Future<List<Appointment>> getAppointmentHistory();

  /// Agenda una cita de emergencia
  ///
  /// [emergencyData] Datos de la cita de emergencia
  Future<Appointment> bookEmergencyAppointment(
    Map<String, dynamic> emergencyData,
  );

  /// Obtiene el horario de un doctor específico
  ///
  /// [doctorId] ID del doctor
  /// [startDate] Fecha de inicio (YYYY-MM-DD)
  /// [endDate] Fecha de fin (YYYY-MM-DD)
  Future<List<AvailableSlotsResponse>> getDoctorSchedule(
    int doctorId, {
    String? startDate,
    String? endDate,
  });
}
