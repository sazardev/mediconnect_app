import 'package:mediconnect_app/domain/entities/appointment.dart';
import 'package:mediconnect_app/domain/repositories/appointment_repository.dart';

/// Caso de uso para obtener todas las citas
class GetAppointmentsUseCase {
  final AppointmentRepository _appointmentRepository;

  GetAppointmentsUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<List<Appointment>> execute({Map<String, dynamic>? filters}) {
    return _appointmentRepository.getAppointments(filters: filters);
  }
}

/// Caso de uso para obtener detalles de una cita
class GetAppointmentDetailsUseCase {
  final AppointmentRepository _appointmentRepository;

  GetAppointmentDetailsUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<Appointment> execute(int appointmentId) {
    return _appointmentRepository.getAppointmentDetails(appointmentId);
  }
}

/// Caso de uso para crear una cita
class CreateAppointmentUseCase {
  final AppointmentRepository _appointmentRepository;

  CreateAppointmentUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<Appointment> execute(Map<String, dynamic> appointmentData) {
    return _appointmentRepository.createAppointment(appointmentData);
  }
}

/// Caso de uso para actualizar una cita
class UpdateAppointmentUseCase {
  final AppointmentRepository _appointmentRepository;

  UpdateAppointmentUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<Appointment> execute(
    int appointmentId,
    Map<String, dynamic> appointmentData,
  ) {
    return _appointmentRepository.updateAppointment(
      appointmentId,
      appointmentData,
    );
  }
}

/// Caso de uso para cancelar una cita
class CancelAppointmentUseCase {
  final AppointmentRepository _appointmentRepository;

  CancelAppointmentUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<bool> execute(int appointmentId, {String? reason}) {
    return _appointmentRepository.cancelAppointment(
      appointmentId,
      reason: reason,
    );
  }
}

/// Caso de uso para confirmar una cita (como doctor)
class ConfirmAppointmentUseCase {
  final AppointmentRepository _appointmentRepository;

  ConfirmAppointmentUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<bool> execute(int appointmentId) {
    return _appointmentRepository.confirmAppointment(appointmentId);
  }
}

/// Caso de uso para marcar una cita como completada
class CompleteAppointmentUseCase {
  final AppointmentRepository _appointmentRepository;

  CompleteAppointmentUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<bool> execute(int appointmentId, {String? notes}) {
    return _appointmentRepository.completeAppointment(
      appointmentId,
      notes: notes,
    );
  }
}

/// Caso de uso para marcar a un paciente como no asistido
class MarkNoShowUseCase {
  final AppointmentRepository _appointmentRepository;

  MarkNoShowUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<bool> execute(int appointmentId, {String? notes}) {
    return _appointmentRepository.markNoShow(appointmentId, notes: notes);
  }
}

/// Caso de uso para reprogramar una cita
class RescheduleAppointmentUseCase {
  final AppointmentRepository _appointmentRepository;

  RescheduleAppointmentUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<Appointment> execute(
    int appointmentId,
    DateTime newDate, {
    String? reason,
  }) {
    return _appointmentRepository.rescheduleAppointment(
      appointmentId,
      newDate,
      reason: reason,
    );
  }
}

/// Caso de uso para obtener los horarios disponibles de un doctor
class GetAvailableSlotsUseCase {
  final AppointmentRepository _appointmentRepository;

  GetAvailableSlotsUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<AvailableSlotsResponse> execute(
    int doctorId, {
    String? date,
    String? clinicId,
  }) {
    return _appointmentRepository.getAvailableSlots(
      doctorId,
      date: date,
      clinicId: clinicId,
    );
  }
}

/// Caso de uso para obtener la vista de calendario del usuario
class GetCalendarViewUseCase {
  final AppointmentRepository _appointmentRepository;

  GetCalendarViewUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<CalendarView> execute({String? month}) {
    return _appointmentRepository.getCalendarView(month: month);
  }
}

/// Caso de uso para obtener las próximas citas del usuario
class GetUpcomingAppointmentsUseCase {
  final AppointmentRepository _appointmentRepository;

  GetUpcomingAppointmentsUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<List<Appointment>> execute() {
    return _appointmentRepository.getUpcomingAppointments();
  }
}

/// Caso de uso para obtener el historial de citas del usuario
class GetAppointmentHistoryUseCase {
  final AppointmentRepository _appointmentRepository;

  GetAppointmentHistoryUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<List<Appointment>> execute() {
    return _appointmentRepository.getAppointmentHistory();
  }
}

/// Caso de uso para agendar una cita de emergencia
class BookEmergencyAppointmentUseCase {
  final AppointmentRepository _appointmentRepository;

  BookEmergencyAppointmentUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<Appointment> execute(Map<String, dynamic> emergencyData) {
    return _appointmentRepository.bookEmergencyAppointment(emergencyData);
  }
}

/// Caso de uso para obtener el horario de un doctor específico
class GetDoctorScheduleUseCase {
  final AppointmentRepository _appointmentRepository;

  GetDoctorScheduleUseCase(this._appointmentRepository);

  /// Ejecuta el caso de uso
  Future<List<AvailableSlotsResponse>> execute(
    int doctorId, {
    String? startDate,
    String? endDate,
  }) {
    return _appointmentRepository.getDoctorSchedule(
      doctorId,
      startDate: startDate,
      endDate: endDate,
    );
  }
}
