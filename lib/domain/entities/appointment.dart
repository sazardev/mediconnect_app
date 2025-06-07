import 'package:mediconnect_app/domain/entities/user.dart';

/// Estado de la cita
enum AppointmentStatus {
  /// Cita agendada, esperando confirmación
  scheduled,

  /// Cita confirmada por el médico
  confirmed,

  /// Cita completada
  completed,

  /// Cita cancelada
  cancelled,

  /// Paciente no asistió
  noShow,
}

/// Tipo de cita médica
enum AppointmentType {
  /// Consulta regular
  consultation,

  /// Seguimiento de tratamiento
  followUp,

  /// Consulta de emergencia
  emergency,

  /// Chequeo rutinario
  checkUp,
}

/// Método de consulta
enum ConsultationMethod {
  /// Consulta presencial
  inPerson,

  /// Consulta por videollamada
  videoCall,

  /// Consulta telefónica
  phone,
}

/// Prioridad de la cita
enum AppointmentPriority {
  /// Prioridad baja
  low,

  /// Prioridad normal
  normal,

  /// Prioridad alta
  high,

  /// Prioridad urgente
  urgent,
}

/// Entidad que representa una cita médica
class Appointment {
  /// ID único de la cita
  final int id;

  /// Número de cita formateado
  final String appointmentNumber;

  /// Información del paciente
  final User patient;

  /// Información del doctor
  final User doctor;

  /// Clínica donde se realizará la cita
  final Clinic? clinic;

  /// Fecha y hora de inicio de la cita
  final DateTime appointmentDate;

  /// Fecha y hora de fin de la cita
  final DateTime appointmentEnd;

  /// Duración de la cita en minutos
  final int durationMinutes;

  /// Tipo de cita
  final AppointmentType appointmentType;

  /// Método de consulta
  final ConsultationMethod consultationMethod;

  /// Estado actual de la cita
  final AppointmentStatus status;

  /// Prioridad de la cita
  final AppointmentPriority priority;

  /// Motivo de la consulta
  final String reason;

  /// Síntomas reportados por el paciente
  final List<String> symptoms;

  /// Notas generales de la cita
  final String? notes;

  /// Notas internas (solo visibles para médico/admin)
  final String? internalNotes;

  /// Información de tarifas y pagos
  final AppointmentFees fees;

  /// Recordatorios configurados para la cita
  final AppointmentReminders? reminders;

  /// Información de seguimiento
  final AppointmentFollowUp? followUp;

  /// Archivos adjuntos
  final List<AppointmentAttachment>? attachments;

  /// Medicamentos prescritos
  final List<MedicationPrescribed>? medicationsPrescribed;

  /// Signos vitales registrados
  final VitalsRecord? vitalsRecorded;

  /// Política de cancelación
  final CancellationPolicy? cancellationPolicy;

  /// Fecha de creación
  final DateTime createdAt;

  /// Última actualización
  final DateTime updatedAt;

  /// Creado por (paciente, doctor, admin)
  final String createdBy;

  /// Última modificación por
  final String lastModifiedBy;

  const Appointment({
    required this.id,
    required this.appointmentNumber,
    required this.patient,
    required this.doctor,
    this.clinic,
    required this.appointmentDate,
    required this.appointmentEnd,
    required this.durationMinutes,
    required this.appointmentType,
    required this.consultationMethod,
    required this.status,
    required this.priority,
    required this.reason,
    required this.symptoms,
    this.notes,
    this.internalNotes,
    required this.fees,
    this.reminders,
    this.followUp,
    this.attachments,
    this.medicationsPrescribed,
    this.vitalsRecorded,
    this.cancellationPolicy,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.lastModifiedBy,
  });
}

/// Información de una clínica
class Clinic {
  /// ID único de la clínica
  final int id;

  /// Nombre de la clínica
  final String name;

  /// Dirección
  final String address;

  /// Teléfono
  final String phone;

  const Clinic({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
  });
}

/// Información de tarifas y pagos
class AppointmentFees {
  /// Tarifa de consulta
  final double consultationFee;

  /// Tarifa adicional
  final double additionalFees;

  /// Monto total
  final double totalAmount;

  /// Moneda
  final String currency;

  /// Estado del pago
  final String paymentStatus;

  /// Método de pago
  final String? paymentMethod;

  /// Descuento aplicado
  final double discount;

  /// Monto cubierto por seguro
  final double insuranceCovered;

  /// Monto que paga el paciente
  final double patientPays;

  const AppointmentFees({
    required this.consultationFee,
    required this.additionalFees,
    required this.totalAmount,
    required this.currency,
    required this.paymentStatus,
    this.paymentMethod,
    required this.discount,
    required this.insuranceCovered,
    required this.patientPays,
  });
}

/// Información de recordatorios
class AppointmentReminders {
  /// Recordatorio por email 24h antes
  final ReminderStatus email24h;

  /// Recordatorio por SMS 2h antes
  final ReminderStatus sms2h;

  /// Recordatorio push 30min antes
  final ReminderStatus push30m;

  const AppointmentReminders({
    required this.email24h,
    required this.sms2h,
    required this.push30m,
  });
}

/// Estado de un recordatorio
class ReminderStatus {
  /// Si fue enviado
  final bool sent;

  /// Cuándo fue enviado o está programado
  final DateTime? sentAt;
  final DateTime? scheduledFor;

  const ReminderStatus({required this.sent, this.sentAt, this.scheduledFor});
}

/// Información de seguimiento
class AppointmentFollowUp {
  /// Si se requiere seguimiento
  final bool required;

  /// Fecha sugerida
  final DateTime? suggestedDate;

  /// Intervalo en días
  final int? intervalDays;

  /// Motivo del seguimiento
  final String? reason;

  const AppointmentFollowUp({
    required this.required,
    this.suggestedDate,
    this.intervalDays,
    this.reason,
  });
}

/// Archivos adjuntos
class AppointmentAttachment {
  /// ID del adjunto
  final int id;

  /// Tipo de adjunto
  final String type;

  /// Nombre del archivo
  final String filename;

  /// URL del archivo
  final String url;

  /// Subido por
  final String uploadedBy;

  /// Fecha de subida
  final DateTime uploadedAt;

  const AppointmentAttachment({
    required this.id,
    required this.type,
    required this.filename,
    required this.url,
    required this.uploadedBy,
    required this.uploadedAt,
  });
}

/// Medicamento prescrito
class MedicationPrescribed {
  /// Nombre del medicamento
  final String medication;

  /// Dosis
  final String dosage;

  /// Frecuencia
  final String frequency;

  /// Duración
  final String duration;

  /// Instrucciones
  final String instructions;

  const MedicationPrescribed({
    required this.medication,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
  });
}

/// Registro de signos vitales
class VitalsRecord {
  /// Presión arterial
  final BloodPressure? bloodPressure;

  /// Frecuencia cardiaca
  final int? heartRate;

  /// Temperatura
  final double? temperature;

  /// Peso
  final double? weight;

  /// Altura
  final double? height;

  const VitalsRecord({
    this.bloodPressure,
    this.heartRate,
    this.temperature,
    this.weight,
    this.height,
  });
}

/// Presión arterial
class BloodPressure {
  /// Sistólica
  final int systolic;

  /// Diastólica
  final int diastolic;

  /// Fecha de registro
  final DateTime recordedAt;

  const BloodPressure({
    required this.systolic,
    required this.diastolic,
    required this.recordedAt,
  });
}

/// Política de cancelación
class CancellationPolicy {
  /// Fecha límite para cancelar sin penalización
  final DateTime canCancelUntil;

  /// Monto de penalización
  final double penaltyAmount;

  /// Cancelaciones gratuitas restantes
  final int freeCancellationsRemaining;

  const CancellationPolicy({
    required this.canCancelUntil,
    required this.penaltyAmount,
    required this.freeCancellationsRemaining,
  });
}

/// Horario disponible
class AvailableSlot {
  /// Hora de inicio
  final String startTime;

  /// Hora de fin
  final String endTime;

  /// Fecha y hora completa
  final DateTime datetime;

  /// Si está disponible
  final bool isAvailable;

  /// Tipo de cita permitido
  final AppointmentType appointmentType;

  /// Métodos de consulta permitidos
  final List<ConsultationMethod> consultationMethods;

  /// ID del slot
  final String slotId;

  /// Razón por la que no está disponible (si aplica)
  final String? reason;

  /// ID de la cita que ocupa este slot (si aplica)
  final int? appointmentId;

  const AvailableSlot({
    required this.startTime,
    required this.endTime,
    required this.datetime,
    required this.isAvailable,
    required this.appointmentType,
    required this.consultationMethods,
    required this.slotId,
    this.reason,
    this.appointmentId,
  });
}

/// Respuesta de horarios disponibles
class AvailableSlotsResponse {
  /// ID del doctor
  final int doctorId;

  /// Nombre del doctor
  final String doctorName;

  /// ID de la clínica
  final int? clinicId;

  /// Nombre de la clínica
  final String? clinicName;

  /// Fecha
  final String date;

  /// Horarios disponibles
  final List<AvailableSlot> availableSlots;

  /// Total de horarios
  final int totalSlots;

  /// Cantidad de horarios disponibles
  final int availableSlotsCount;

  /// Próximo horario disponible
  final DateTime nextAvailable;

  /// Ventana de reserva
  final BookingWindow bookingWindow;

  const AvailableSlotsResponse({
    required this.doctorId,
    required this.doctorName,
    this.clinicId,
    this.clinicName,
    required this.date,
    required this.availableSlots,
    required this.totalSlots,
    required this.availableSlotsCount,
    required this.nextAvailable,
    required this.bookingWindow,
  });
}

/// Ventana de reserva
class BookingWindow {
  /// Fecha más temprana para reservar
  final DateTime earliestBooking;

  /// Fecha más tardía para reservar
  final DateTime latestBooking;

  const BookingWindow({
    required this.earliestBooking,
    required this.latestBooking,
  });
}

/// Vista de calendario
class CalendarView {
  /// Mes (formato YYYY-MM)
  final String month;

  /// Tipo de usuario consultando
  final String userType;

  /// ID del usuario
  final int userId;

  /// Días del mes
  final List<CalendarDay> days;

  /// Resumen de citas
  final CalendarSummary summary;

  const CalendarView({
    required this.month,
    required this.userType,
    required this.userId,
    required this.days,
    required this.summary,
  });
}

/// Día en el calendario
class CalendarDay {
  /// Fecha (formato YYYY-MM-DD)
  final String date;

  /// Lista de citas ese día
  final List<CalendarAppointment> appointments;

  /// Si hay citas ese día
  final bool hasAppointments;

  /// Cantidad de citas ese día
  final int appointmentsCount;

  const CalendarDay({
    required this.date,
    required this.appointments,
    required this.hasAppointments,
    required this.appointmentsCount,
  });
}

/// Cita resumida para vista de calendario
class CalendarAppointment {
  /// ID de la cita
  final int id;

  /// Hora (formato HH:MM)
  final String time;

  /// Duración en minutos
  final int duration;

  /// Nombre del doctor
  final String doctorName;

  /// Estado de la cita
  final AppointmentStatus status;

  /// Tipo de cita
  final AppointmentType type;

  /// Prioridad
  final AppointmentPriority priority;

  const CalendarAppointment({
    required this.id,
    required this.time,
    required this.duration,
    required this.doctorName,
    required this.status,
    required this.type,
    required this.priority,
  });
}

/// Resumen de calendario
class CalendarSummary {
  /// Total de citas
  final int totalAppointments;

  /// Citas programadas
  final int scheduled;

  /// Citas completadas
  final int completed;

  /// Citas canceladas
  final int cancelled;

  /// Próximas citas esta semana
  final int upcomingThisWeek;

  const CalendarSummary({
    required this.totalAppointments,
    required this.scheduled,
    required this.completed,
    required this.cancelled,
    required this.upcomingThisWeek,
  });
}
