import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconnect_app/domain/usecases/appointment_usecases.dart';
import 'package:mediconnect_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:mediconnect_app/presentation/blocs/appointment/appointment_state.dart';

/// BLoC para gestionar citas médicas
class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetAppointmentsUseCase _getAppointmentsUseCase;
  final GetAppointmentDetailsUseCase _getAppointmentDetailsUseCase;
  final CreateAppointmentUseCase _createAppointmentUseCase;
  final UpdateAppointmentUseCase _updateAppointmentUseCase;
  final CancelAppointmentUseCase _cancelAppointmentUseCase;
  final ConfirmAppointmentUseCase _confirmAppointmentUseCase;
  final CompleteAppointmentUseCase _completeAppointmentUseCase;
  final MarkNoShowUseCase _markNoShowUseCase;
  final RescheduleAppointmentUseCase _rescheduleAppointmentUseCase;
  final GetAvailableSlotsUseCase _getAvailableSlotsUseCase;
  final GetCalendarViewUseCase _getCalendarViewUseCase;
  final GetUpcomingAppointmentsUseCase _getUpcomingAppointmentsUseCase;
  final GetAppointmentHistoryUseCase _getAppointmentHistoryUseCase;
  final BookEmergencyAppointmentUseCase _bookEmergencyAppointmentUseCase;
  final GetDoctorScheduleUseCase _getDoctorScheduleUseCase;

  /// Constructor del BLoC
  AppointmentBloc({
    required GetAppointmentsUseCase getAppointmentsUseCase,
    required GetAppointmentDetailsUseCase getAppointmentDetailsUseCase,
    required CreateAppointmentUseCase createAppointmentUseCase,
    required UpdateAppointmentUseCase updateAppointmentUseCase,
    required CancelAppointmentUseCase cancelAppointmentUseCase,
    required ConfirmAppointmentUseCase confirmAppointmentUseCase,
    required CompleteAppointmentUseCase completeAppointmentUseCase,
    required MarkNoShowUseCase markNoShowUseCase,
    required RescheduleAppointmentUseCase rescheduleAppointmentUseCase,
    required GetAvailableSlotsUseCase getAvailableSlotsUseCase,
    required GetCalendarViewUseCase getCalendarViewUseCase,
    required GetUpcomingAppointmentsUseCase getUpcomingAppointmentsUseCase,
    required GetAppointmentHistoryUseCase getAppointmentHistoryUseCase,
    required BookEmergencyAppointmentUseCase bookEmergencyAppointmentUseCase,
    required GetDoctorScheduleUseCase getDoctorScheduleUseCase,
  }) : _getAppointmentsUseCase = getAppointmentsUseCase,
       _getAppointmentDetailsUseCase = getAppointmentDetailsUseCase,
       _createAppointmentUseCase = createAppointmentUseCase,
       _updateAppointmentUseCase = updateAppointmentUseCase,
       _cancelAppointmentUseCase = cancelAppointmentUseCase,
       _confirmAppointmentUseCase = confirmAppointmentUseCase,
       _completeAppointmentUseCase = completeAppointmentUseCase,
       _markNoShowUseCase = markNoShowUseCase,
       _rescheduleAppointmentUseCase = rescheduleAppointmentUseCase,
       _getAvailableSlotsUseCase = getAvailableSlotsUseCase,
       _getCalendarViewUseCase = getCalendarViewUseCase,
       _getUpcomingAppointmentsUseCase = getUpcomingAppointmentsUseCase,
       _getAppointmentHistoryUseCase = getAppointmentHistoryUseCase,
       _bookEmergencyAppointmentUseCase = bookEmergencyAppointmentUseCase,
       _getDoctorScheduleUseCase = getDoctorScheduleUseCase,
       super(const AppointmentInitialState()) {
    on<AppointmentLoadListEvent>(_onLoadList);
    on<AppointmentLoadDetailsEvent>(_onLoadDetails);
    on<AppointmentCreateEvent>(_onCreate);
    on<AppointmentUpdateEvent>(_onUpdate);
    on<AppointmentCancelEvent>(_onCancel);
    on<AppointmentConfirmEvent>(_onConfirm);
    on<AppointmentCompleteEvent>(_onComplete);
    on<AppointmentMarkNoShowEvent>(_onMarkNoShow);
    on<AppointmentRescheduleEvent>(_onReschedule);
    on<AppointmentLoadAvailableSlotsEvent>(_onLoadAvailableSlots);
    on<AppointmentLoadCalendarEvent>(_onLoadCalendar);
    on<AppointmentLoadUpcomingEvent>(_onLoadUpcoming);
    on<AppointmentLoadHistoryEvent>(_onLoadHistory);
    on<AppointmentBookEmergencyEvent>(_onBookEmergency);
    on<AppointmentLoadDoctorScheduleEvent>(_onLoadDoctorSchedule);
  }

  Future<void> _onLoadList(
    AppointmentLoadListEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointments = await _getAppointmentsUseCase.execute(
        filters: event.filters,
      );
      emit(AppointmentListLoadedState(appointments));
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onLoadDetails(
    AppointmentLoadDetailsEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointment = await _getAppointmentDetailsUseCase.execute(
        event.appointmentId,
      );
      emit(AppointmentDetailsLoadedState(appointment));
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onCreate(
    AppointmentCreateEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointment = await _createAppointmentUseCase.execute(
        event.appointmentData,
      );
      emit(
        AppointmentSuccessState('Cita creada exitosamente', data: appointment),
      );
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onUpdate(
    AppointmentUpdateEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointment = await _updateAppointmentUseCase.execute(
        event.appointmentId,
        event.appointmentData,
      );
      emit(
        AppointmentSuccessState(
          'Cita actualizada exitosamente',
          data: appointment,
        ),
      );
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onCancel(
    AppointmentCancelEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final success = await _cancelAppointmentUseCase.execute(
        event.appointmentId,
        reason: event.reason,
      );
      if (success) {
        emit(const AppointmentSuccessState('Cita cancelada exitosamente'));
      } else {
        emit(const AppointmentErrorState('No se pudo cancelar la cita'));
      }
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onConfirm(
    AppointmentConfirmEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final success = await _confirmAppointmentUseCase.execute(
        event.appointmentId,
      );
      if (success) {
        emit(const AppointmentSuccessState('Cita confirmada exitosamente'));
      } else {
        emit(const AppointmentErrorState('No se pudo confirmar la cita'));
      }
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onComplete(
    AppointmentCompleteEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final success = await _completeAppointmentUseCase.execute(
        event.appointmentId,
        notes: event.notes,
      );
      if (success) {
        emit(const AppointmentSuccessState('Cita marcada como completada'));
      } else {
        emit(const AppointmentErrorState('No se pudo completar la cita'));
      }
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onMarkNoShow(
    AppointmentMarkNoShowEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final success = await _markNoShowUseCase.execute(
        event.appointmentId,
        notes: event.notes,
      );
      if (success) {
        emit(
          const AppointmentSuccessState('Paciente marcado como no asistido'),
        );
      } else {
        emit(const AppointmentErrorState('No se pudo marcar la inasistencia'));
      }
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onReschedule(
    AppointmentRescheduleEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointment = await _rescheduleAppointmentUseCase.execute(
        event.appointmentId,
        event.newDate,
        reason: event.reason,
      );
      emit(
        AppointmentSuccessState(
          'Cita reprogramada exitosamente',
          data: appointment,
        ),
      );
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onLoadAvailableSlots(
    AppointmentLoadAvailableSlotsEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final availableSlots = await _getAvailableSlotsUseCase.execute(
        event.doctorId,
        date: event.date,
        clinicId: event.clinicId,
      );
      emit(AppointmentAvailableSlotsLoadedState(availableSlots));
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onLoadCalendar(
    AppointmentLoadCalendarEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final calendarView = await _getCalendarViewUseCase.execute(
        month: event.month,
      );
      emit(AppointmentCalendarLoadedState(calendarView));
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onLoadUpcoming(
    AppointmentLoadUpcomingEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointments = await _getUpcomingAppointmentsUseCase.execute();
      emit(AppointmentUpcomingLoadedState(appointments));
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onLoadHistory(
    AppointmentLoadHistoryEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointments = await _getAppointmentHistoryUseCase.execute();
      emit(AppointmentHistoryLoadedState(appointments));
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onBookEmergency(
    AppointmentBookEmergencyEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final appointment = await _bookEmergencyAppointmentUseCase.execute(
        event.emergencyData,
      );
      emit(
        AppointmentSuccessState(
          'Cita de emergencia agendada',
          data: appointment,
        ),
      );
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }

  Future<void> _onLoadDoctorSchedule(
    AppointmentLoadDoctorScheduleEvent event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(const AppointmentLoadingState());
    try {
      final schedules = await _getDoctorScheduleUseCase.execute(
        event.doctorId,
        startDate: event.startDate,
        endDate: event.endDate,
      );
      emit(AppointmentDoctorScheduleLoadedState(schedules));
    } catch (e) {
      emit(AppointmentErrorState(e.toString()));
    }
  }
}
