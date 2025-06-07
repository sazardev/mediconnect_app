import 'package:mediconnect_app/data/models/user_model.dart';
import 'package:mediconnect_app/domain/entities/appointment.dart';

/// Modelo de datos para una cita médica
class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.appointmentNumber,
    required super.patient,
    required super.doctor,
    super.clinic,
    required super.appointmentDate,
    required super.appointmentEnd,
    required super.durationMinutes,
    required super.appointmentType,
    required super.consultationMethod,
    required super.status,
    required super.priority,
    required super.reason,
    required super.symptoms,
    super.notes,
    super.internalNotes,
    required super.fees,
    super.reminders,
    super.followUp,
    super.attachments,
    super.medicationsPrescribed,
    super.vitalsRecorded,
    super.cancellationPolicy,
    required super.createdAt,
    required super.updatedAt,
    required super.createdBy,
    required super.lastModifiedBy,
  });

  /// Crea un modelo de cita desde un mapa JSON
  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      appointmentNumber: json['appointment_number'],
      patient: UserModel.fromJson(json['patient']),
      doctor: UserModel.fromJson(json['doctor']),
      clinic: json['clinic'] != null
          ? ClinicModel.fromJson(json['clinic'])
          : null,
      appointmentDate: DateTime.parse(json['appointment_date']),
      appointmentEnd: DateTime.parse(json['appointment_end']),
      durationMinutes: json['duration_minutes'],
      appointmentType: _parseAppointmentType(json['appointment_type']),
      consultationMethod: _parseConsultationMethod(json['consultation_method']),
      status: _parseAppointmentStatus(json['status']),
      priority: _parseAppointmentPriority(json['priority']),
      reason: json['reason'],
      symptoms: List<String>.from(json['symptoms']),
      notes: json['notes'],
      internalNotes: json['internal_notes'],
      fees: AppointmentFeesModel.fromJson(json['fees']),
      reminders: json['reminders'] != null
          ? AppointmentRemindersModel.fromJson(json['reminders'])
          : null,
      followUp: json['follow_up'] != null
          ? AppointmentFollowUpModel.fromJson(json['follow_up'])
          : null,
      attachments: json['attachments'] != null
          ? List<AppointmentAttachmentModel>.from(
              json['attachments'].map(
                (x) => AppointmentAttachmentModel.fromJson(x),
              ),
            )
          : null,
      medicationsPrescribed: json['medications_prescribed'] != null
          ? List<MedicationPrescribedModel>.from(
              json['medications_prescribed'].map(
                (x) => MedicationPrescribedModel.fromJson(x),
              ),
            )
          : null,
      vitalsRecorded: json['vitals_recorded'] != null
          ? VitalsRecordModel.fromJson(json['vitals_recorded'])
          : null,
      cancellationPolicy: json['cancellation_policy'] != null
          ? CancellationPolicyModel.fromJson(json['cancellation_policy'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['created_by'],
      lastModifiedBy: json['last_modified_by'],
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'appointment_number': appointmentNumber,
      'patient': (patient as UserModel).toJson(),
      'doctor': (doctor as UserModel).toJson(),
      'appointment_date': appointmentDate.toIso8601String(),
      'appointment_end': appointmentEnd.toIso8601String(),
      'duration_minutes': durationMinutes,
      'appointment_type': _appointmentTypeToString(appointmentType),
      'consultation_method': _consultationMethodToString(consultationMethod),
      'status': _appointmentStatusToString(status),
      'priority': _appointmentPriorityToString(priority),
      'reason': reason,
      'symptoms': symptoms,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'last_modified_by': lastModifiedBy,
      'fees': (fees as AppointmentFeesModel).toJson(),
    };

    if (clinic != null) {
      data['clinic'] = (clinic as ClinicModel).toJson();
    }
    if (notes != null) {
      data['notes'] = notes;
    }
    if (internalNotes != null) {
      data['internal_notes'] = internalNotes;
    }
    if (reminders != null) {
      data['reminders'] = (reminders as AppointmentRemindersModel).toJson();
    }
    if (followUp != null) {
      data['follow_up'] = (followUp as AppointmentFollowUpModel).toJson();
    }
    if (attachments != null) {
      data['attachments'] = attachments!
          .map((x) => (x as AppointmentAttachmentModel).toJson())
          .toList();
    }
    if (medicationsPrescribed != null) {
      data['medications_prescribed'] = medicationsPrescribed!
          .map((x) => (x as MedicationPrescribedModel).toJson())
          .toList();
    }
    if (vitalsRecorded != null) {
      data['vitals_recorded'] = (vitalsRecorded as VitalsRecordModel).toJson();
    }
    if (cancellationPolicy != null) {
      data['cancellation_policy'] =
          (cancellationPolicy as CancellationPolicyModel).toJson();
    }

    return data;
  }

  /// Parsea el tipo de cita desde string
  static AppointmentType _parseAppointmentType(String type) {
    switch (type) {
      case 'consultation':
        return AppointmentType.consultation;
      case 'follow_up':
        return AppointmentType.followUp;
      case 'emergency':
        return AppointmentType.emergency;
      case 'check_up':
        return AppointmentType.checkUp;
      default:
        return AppointmentType.consultation;
    }
  }

  /// Convierte el tipo de cita a string
  static String _appointmentTypeToString(AppointmentType type) {
    switch (type) {
      case AppointmentType.consultation:
        return 'consultation';
      case AppointmentType.followUp:
        return 'follow_up';
      case AppointmentType.emergency:
        return 'emergency';
      case AppointmentType.checkUp:
        return 'check_up';
    }
  }

  /// Parsea el método de consulta desde string
  static ConsultationMethod _parseConsultationMethod(String method) {
    switch (method) {
      case 'presencial':
        return ConsultationMethod.inPerson;
      case 'videollamada':
        return ConsultationMethod.videoCall;
      case 'telefono':
        return ConsultationMethod.phone;
      default:
        return ConsultationMethod.inPerson;
    }
  }

  /// Convierte el método de consulta a string
  static String _consultationMethodToString(ConsultationMethod method) {
    switch (method) {
      case ConsultationMethod.inPerson:
        return 'presencial';
      case ConsultationMethod.videoCall:
        return 'videollamada';
      case ConsultationMethod.phone:
        return 'telefono';
    }
  }

  /// Parsea el estado de la cita desde string
  static AppointmentStatus _parseAppointmentStatus(String status) {
    switch (status) {
      case 'scheduled':
        return AppointmentStatus.scheduled;
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
        return AppointmentStatus.cancelled;
      case 'no_show':
        return AppointmentStatus.noShow;
      default:
        return AppointmentStatus.scheduled;
    }
  }

  /// Convierte el estado de la cita a string
  static String _appointmentStatusToString(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'scheduled';
      case AppointmentStatus.confirmed:
        return 'confirmed';
      case AppointmentStatus.completed:
        return 'completed';
      case AppointmentStatus.cancelled:
        return 'cancelled';
      case AppointmentStatus.noShow:
        return 'no_show';
    }
  }

  /// Parsea la prioridad de la cita desde string
  static AppointmentPriority _parseAppointmentPriority(String priority) {
    switch (priority) {
      case 'low':
        return AppointmentPriority.low;
      case 'normal':
        return AppointmentPriority.normal;
      case 'high':
        return AppointmentPriority.high;
      case 'urgent':
        return AppointmentPriority.urgent;
      default:
        return AppointmentPriority.normal;
    }
  }

  /// Convierte la prioridad de la cita a string
  static String _appointmentPriorityToString(AppointmentPriority priority) {
    switch (priority) {
      case AppointmentPriority.low:
        return 'low';
      case AppointmentPriority.normal:
        return 'normal';
      case AppointmentPriority.high:
        return 'high';
      case AppointmentPriority.urgent:
        return 'urgent';
    }
  }
}

/// Modelo de datos para una clínica
class ClinicModel extends Clinic {
  const ClinicModel({
    required super.id,
    required super.name,
    required super.address,
    required super.phone,
  });

  /// Crea un modelo de clínica desde un mapa JSON
  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'address': address, 'phone': phone};
  }
}

/// Modelo de datos para tarifas y pagos
class AppointmentFeesModel extends AppointmentFees {
  const AppointmentFeesModel({
    required super.consultationFee,
    required super.additionalFees,
    required super.totalAmount,
    required super.currency,
    required super.paymentStatus,
    super.paymentMethod,
    required super.discount,
    required super.insuranceCovered,
    required super.patientPays,
  });

  /// Crea un modelo de tarifas desde un mapa JSON
  factory AppointmentFeesModel.fromJson(Map<String, dynamic> json) {
    return AppointmentFeesModel(
      consultationFee: json['consultation_fee'].toDouble(),
      additionalFees: json['additional_fees'].toDouble(),
      totalAmount: json['total_amount'].toDouble(),
      currency: json['currency'],
      paymentStatus: json['payment_status'],
      paymentMethod: json['payment_method'],
      discount: json['discount'].toDouble(),
      insuranceCovered: json['insurance_covered'].toDouble(),
      patientPays: json['patient_pays'].toDouble(),
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'consultation_fee': consultationFee,
      'additional_fees': additionalFees,
      'total_amount': totalAmount,
      'currency': currency,
      'payment_status': paymentStatus,
      'discount': discount,
      'insurance_covered': insuranceCovered,
      'patient_pays': patientPays,
    };

    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod;
    }

    return data;
  }
}

/// Modelo de datos para recordatorios
class AppointmentRemindersModel extends AppointmentReminders {
  const AppointmentRemindersModel({
    required super.email24h,
    required super.sms2h,
    required super.push30m,
  });

  /// Crea un modelo de recordatorios desde un mapa JSON
  factory AppointmentRemindersModel.fromJson(Map<String, dynamic> json) {
    return AppointmentRemindersModel(
      email24h: ReminderStatusModel.fromJson(json['email_24h']),
      sms2h: ReminderStatusModel.fromJson(json['sms_2h']),
      push30m: ReminderStatusModel.fromJson(json['push_30m']),
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'email_24h': (email24h as ReminderStatusModel).toJson(),
      'sms_2h': (sms2h as ReminderStatusModel).toJson(),
      'push_30m': (push30m as ReminderStatusModel).toJson(),
    };
  }
}

/// Modelo de datos para estado de recordatorio
class ReminderStatusModel extends ReminderStatus {
  const ReminderStatusModel({
    required super.sent,
    super.sentAt,
    super.scheduledFor,
  });

  /// Crea un modelo de estado de recordatorio desde un mapa JSON
  factory ReminderStatusModel.fromJson(Map<String, dynamic> json) {
    return ReminderStatusModel(
      sent: json['sent'],
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at']) : null,
      scheduledFor: json['scheduled_for'] != null
          ? DateTime.parse(json['scheduled_for'])
          : null,
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{'sent': sent};

    if (sentAt != null) {
      data['sent_at'] = sentAt!.toIso8601String();
    }
    if (scheduledFor != null) {
      data['scheduled_for'] = scheduledFor!.toIso8601String();
    }

    return data;
  }
}

/// Modelo de datos para seguimiento de cita
class AppointmentFollowUpModel extends AppointmentFollowUp {
  const AppointmentFollowUpModel({
    required super.required,
    super.suggestedDate,
    super.intervalDays,
    super.reason,
  });

  /// Crea un modelo de seguimiento desde un mapa JSON
  factory AppointmentFollowUpModel.fromJson(Map<String, dynamic> json) {
    return AppointmentFollowUpModel(
      required: json['required'],
      suggestedDate: json['suggested_date'] != null
          ? DateTime.parse(json['suggested_date'])
          : null,
      intervalDays: json['interval_days'],
      reason: json['reason'],
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{'required': required};

    if (suggestedDate != null) {
      data['suggested_date'] = suggestedDate!.toIso8601String();
    }
    if (intervalDays != null) {
      data['interval_days'] = intervalDays;
    }
    if (reason != null) {
      data['reason'] = reason;
    }

    return data;
  }
}

/// Modelo de datos para archivos adjuntos
class AppointmentAttachmentModel extends AppointmentAttachment {
  const AppointmentAttachmentModel({
    required super.id,
    required super.type,
    required super.filename,
    required super.url,
    required super.uploadedBy,
    required super.uploadedAt,
  });

  /// Crea un modelo de archivo adjunto desde un mapa JSON
  factory AppointmentAttachmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentAttachmentModel(
      id: json['id'],
      type: json['type'],
      filename: json['filename'],
      url: json['url'],
      uploadedBy: json['uploaded_by'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'filename': filename,
      'url': url,
      'uploaded_by': uploadedBy,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }
}

/// Modelo de datos para medicamentos prescritos
class MedicationPrescribedModel extends MedicationPrescribed {
  const MedicationPrescribedModel({
    required super.medication,
    required super.dosage,
    required super.frequency,
    required super.duration,
    required super.instructions,
  });

  /// Crea un modelo de medicamento prescrito desde un mapa JSON
  factory MedicationPrescribedModel.fromJson(Map<String, dynamic> json) {
    return MedicationPrescribedModel(
      medication: json['medication'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      duration: json['duration'],
      instructions: json['instructions'],
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'medication': medication,
      'dosage': dosage,
      'frequency': frequency,
      'duration': duration,
      'instructions': instructions,
    };
  }
}

/// Modelo de datos para signos vitales
class VitalsRecordModel extends VitalsRecord {
  const VitalsRecordModel({
    super.bloodPressure,
    super.heartRate,
    super.temperature,
    super.weight,
    super.height,
  });

  /// Crea un modelo de signos vitales desde un mapa JSON
  factory VitalsRecordModel.fromJson(Map<String, dynamic> json) {
    return VitalsRecordModel(
      bloodPressure: json['blood_pressure'] != null
          ? BloodPressureModel.fromJson(json['blood_pressure'])
          : null,
      heartRate: json['heart_rate'],
      temperature: json['temperature']?.toDouble(),
      weight: json['weight']?.toDouble(),
      height: json['height']?.toDouble(),
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (bloodPressure != null) {
      data['blood_pressure'] = (bloodPressure as BloodPressureModel).toJson();
    }
    if (heartRate != null) {
      data['heart_rate'] = heartRate;
    }
    if (temperature != null) {
      data['temperature'] = temperature;
    }
    if (weight != null) {
      data['weight'] = weight;
    }
    if (height != null) {
      data['height'] = height;
    }

    return data;
  }
}

/// Modelo de datos para presión arterial
class BloodPressureModel extends BloodPressure {
  const BloodPressureModel({
    required super.systolic,
    required super.diastolic,
    required super.recordedAt,
  });

  /// Crea un modelo de presión arterial desde un mapa JSON
  factory BloodPressureModel.fromJson(Map<String, dynamic> json) {
    return BloodPressureModel(
      systolic: json['systolic'],
      diastolic: json['diastolic'],
      recordedAt: DateTime.parse(json['recorded_at']),
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'systolic': systolic,
      'diastolic': diastolic,
      'recorded_at': recordedAt.toIso8601String(),
    };
  }
}

/// Modelo de datos para política de cancelación
class CancellationPolicyModel extends CancellationPolicy {
  const CancellationPolicyModel({
    required super.canCancelUntil,
    required super.penaltyAmount,
    required super.freeCancellationsRemaining,
  });

  /// Crea un modelo de política de cancelación desde un mapa JSON
  factory CancellationPolicyModel.fromJson(Map<String, dynamic> json) {
    return CancellationPolicyModel(
      canCancelUntil: DateTime.parse(json['can_cancel_until']),
      penaltyAmount: json['penalty_amount'].toDouble(),
      freeCancellationsRemaining: json['free_cancellations_remaining'],
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'can_cancel_until': canCancelUntil.toIso8601String(),
      'penalty_amount': penaltyAmount,
      'free_cancellations_remaining': freeCancellationsRemaining,
    };
  }
}

/// Modelo de datos para horario disponible
class AvailableSlotModel extends AvailableSlot {
  const AvailableSlotModel({
    required super.startTime,
    required super.endTime,
    required super.datetime,
    required super.isAvailable,
    required super.appointmentType,
    required super.consultationMethods,
    required super.slotId,
    super.reason,
    super.appointmentId,
  });

  /// Crea un modelo de horario disponible desde un mapa JSON
  factory AvailableSlotModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotModel(
      startTime: json['start_time'],
      endTime: json['end_time'],
      datetime: DateTime.parse(json['datetime']),
      isAvailable: json['is_available'],
      appointmentType: AppointmentModel._parseAppointmentType(
        json['appointment_type'],
      ),
      consultationMethods: List<ConsultationMethod>.from(
        json['consultation_methods'].map(
          (x) => AppointmentModel._parseConsultationMethod(x),
        ),
      ),
      slotId: json['slot_id'],
      reason: json['reason'],
      appointmentId: json['appointment_id'],
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'start_time': startTime,
      'end_time': endTime,
      'datetime': datetime.toIso8601String(),
      'is_available': isAvailable,
      'appointment_type': AppointmentModel._appointmentTypeToString(
        appointmentType,
      ),
      'consultation_methods': consultationMethods
          .map((x) => AppointmentModel._consultationMethodToString(x))
          .toList(),
      'slot_id': slotId,
    };

    if (reason != null) {
      data['reason'] = reason;
    }
    if (appointmentId != null) {
      data['appointment_id'] = appointmentId;
    }

    return data;
  }
}

/// Modelo de datos para respuesta de horarios disponibles
class AvailableSlotsResponseModel extends AvailableSlotsResponse {
  const AvailableSlotsResponseModel({
    required super.doctorId,
    required super.doctorName,
    super.clinicId,
    super.clinicName,
    required super.date,
    required super.availableSlots,
    required super.totalSlots,
    required super.availableSlotsCount,
    required super.nextAvailable,
    required super.bookingWindow,
  });

  /// Crea un modelo de respuesta de horarios disponibles desde un mapa JSON
  factory AvailableSlotsResponseModel.fromJson(Map<String, dynamic> json) {
    return AvailableSlotsResponseModel(
      doctorId: json['doctor_id'],
      doctorName: json['doctor_name'],
      clinicId: json['clinic_id'],
      clinicName: json['clinic_name'],
      date: json['date'],
      availableSlots: List<AvailableSlotModel>.from(
        json['available_slots'].map((x) => AvailableSlotModel.fromJson(x)),
      ),
      totalSlots: json['total_slots'],
      availableSlotsCount: json['available_slots_count'],
      nextAvailable: DateTime.parse(json['next_available']),
      bookingWindow: BookingWindowModel.fromJson(json['booking_window']),
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'date': date,
      'available_slots': availableSlots
          .map((x) => (x as AvailableSlotModel).toJson())
          .toList(),
      'total_slots': totalSlots,
      'available_slots_count': availableSlotsCount,
      'next_available': nextAvailable.toIso8601String(),
      'booking_window': (bookingWindow as BookingWindowModel).toJson(),
    };

    if (clinicId != null) {
      data['clinic_id'] = clinicId;
    }
    if (clinicName != null) {
      data['clinic_name'] = clinicName;
    }

    return data;
  }
}

/// Modelo de datos para ventana de reserva
class BookingWindowModel extends BookingWindow {
  const BookingWindowModel({
    required super.earliestBooking,
    required super.latestBooking,
  });

  /// Crea un modelo de ventana de reserva desde un mapa JSON
  factory BookingWindowModel.fromJson(Map<String, dynamic> json) {
    return BookingWindowModel(
      earliestBooking: DateTime.parse(json['earliest_booking']),
      latestBooking: DateTime.parse(json['latest_booking']),
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'earliest_booking': earliestBooking.toIso8601String(),
      'latest_booking': latestBooking.toIso8601String(),
    };
  }
}

/// Modelo de datos para vista de calendario
class CalendarViewModel extends CalendarView {
  const CalendarViewModel({
    required super.month,
    required super.userType,
    required super.userId,
    required super.days,
    required super.summary,
  });

  /// Crea un modelo de vista de calendario desde un mapa JSON
  factory CalendarViewModel.fromJson(Map<String, dynamic> json) {
    return CalendarViewModel(
      month: json['month'],
      userType: json['user_type'],
      userId: json['user_id'],
      days: List<CalendarDayModel>.from(
        json['days'].map((x) => CalendarDayModel.fromJson(x)),
      ),
      summary: CalendarSummaryModel.fromJson(json['summary']),
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'user_type': userType,
      'user_id': userId,
      'days': days.map((x) => (x as CalendarDayModel).toJson()).toList(),
      'summary': (summary as CalendarSummaryModel).toJson(),
    };
  }
}

/// Modelo de datos para día en el calendario
class CalendarDayModel extends CalendarDay {
  const CalendarDayModel({
    required super.date,
    required super.appointments,
    required super.hasAppointments,
    required super.appointmentsCount,
  });

  /// Crea un modelo de día en el calendario desde un mapa JSON
  factory CalendarDayModel.fromJson(Map<String, dynamic> json) {
    return CalendarDayModel(
      date: json['date'],
      appointments: List<CalendarAppointmentModel>.from(
        json['appointments'].map((x) => CalendarAppointmentModel.fromJson(x)),
      ),
      hasAppointments: json['has_appointments'],
      appointmentsCount: json['appointments_count'],
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'appointments': appointments
          .map((x) => (x as CalendarAppointmentModel).toJson())
          .toList(),
      'has_appointments': hasAppointments,
      'appointments_count': appointmentsCount,
    };
  }
}

/// Modelo de datos para cita resumida en calendario
class CalendarAppointmentModel extends CalendarAppointment {
  const CalendarAppointmentModel({
    required super.id,
    required super.time,
    required super.duration,
    required super.doctorName,
    required super.status,
    required super.type,
    required super.priority,
  });

  /// Crea un modelo de cita resumida desde un mapa JSON
  factory CalendarAppointmentModel.fromJson(Map<String, dynamic> json) {
    return CalendarAppointmentModel(
      id: json['id'],
      time: json['time'],
      duration: json['duration'],
      doctorName: json['doctor_name'],
      status: AppointmentModel._parseAppointmentStatus(json['status']),
      type: AppointmentModel._parseAppointmentType(json['type']),
      priority: AppointmentModel._parseAppointmentPriority(json['priority']),
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'duration': duration,
      'doctor_name': doctorName,
      'status': AppointmentModel._appointmentStatusToString(status),
      'type': AppointmentModel._appointmentTypeToString(type),
      'priority': AppointmentModel._appointmentPriorityToString(priority),
    };
  }
}

/// Modelo de datos para resumen de calendario
class CalendarSummaryModel extends CalendarSummary {
  const CalendarSummaryModel({
    required super.totalAppointments,
    required super.scheduled,
    required super.completed,
    required super.cancelled,
    required super.upcomingThisWeek,
  });

  /// Crea un modelo de resumen de calendario desde un mapa JSON
  factory CalendarSummaryModel.fromJson(Map<String, dynamic> json) {
    return CalendarSummaryModel(
      totalAppointments: json['total_appointments'],
      scheduled: json['scheduled'],
      completed: json['completed'],
      cancelled: json['cancelled'],
      upcomingThisWeek: json['upcoming_this_week'],
    );
  }

  /// Convierte el modelo a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'total_appointments': totalAppointments,
      'scheduled': scheduled,
      'completed': completed,
      'cancelled': cancelled,
      'upcoming_this_week': upcomingThisWeek,
    };
  }
}
