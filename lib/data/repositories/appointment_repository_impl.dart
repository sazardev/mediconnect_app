import 'package:mediconnect_app/core/errors/exceptions.dart';
import 'package:mediconnect_app/core/network/api_client.dart';
import 'package:mediconnect_app/data/models/appointment_model.dart';
import 'package:mediconnect_app/domain/entities/appointment.dart';
import 'package:mediconnect_app/domain/repositories/appointment_repository.dart';

/// Implementación del repositorio de citas médicas
class AppointmentRepositoryImpl implements AppointmentRepository {
  final ApiClient _apiClient;

  /// Constructor del repositorio
  const AppointmentRepositoryImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<Appointment>> getAppointments({
    Map<String, dynamic>? filters,
  }) async {
    try {
      final response = await _apiClient.get(
        '/api/appointments/',
        queryParameters: filters,
      );

      final List<dynamic> appointmentsJson = response['results'];

      return appointmentsJson
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Appointment> getAppointmentDetails(int appointmentId) async {
    try {
      final response = await _apiClient.get(
        '/api/appointments/$appointmentId/',
      );
      return AppointmentModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Appointment> createAppointment(
    Map<String, dynamic> appointmentData,
  ) async {
    try {
      final response = await _apiClient.post(
        '/api/appointments/',
        data: appointmentData,
      );
      return AppointmentModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Appointment> updateAppointment(
    int appointmentId,
    Map<String, dynamic> appointmentData,
  ) async {
    try {
      final response = await _apiClient.put(
        '/api/appointments/$appointmentId/',
        data: appointmentData,
      );
      return AppointmentModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> cancelAppointment(int appointmentId, {String? reason}) async {
    try {
      final data = reason != null ? {'reason': reason} : null;
      await _apiClient.post(
        '/api/appointments/$appointmentId/cancel/',
        data: data,
      );
      return true;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> confirmAppointment(int appointmentId) async {
    try {
      await _apiClient.post('/api/appointments/$appointmentId/confirm/');
      return true;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> completeAppointment(int appointmentId, {String? notes}) async {
    try {
      final data = notes != null ? {'notes': notes} : null;
      await _apiClient.post(
        '/api/appointments/$appointmentId/complete/',
        data: data,
      );
      return true;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> markNoShow(int appointmentId, {String? notes}) async {
    try {
      final data = notes != null ? {'notes': notes} : null;
      await _apiClient.post(
        '/api/appointments/$appointmentId/no-show/',
        data: data,
      );
      return true;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Appointment> rescheduleAppointment(
    int appointmentId,
    DateTime newDate, {
    String? reason,
  }) async {
    try {
      final data = {
        'new_date': newDate.toIso8601String(),
        if (reason != null) 'reason': reason,
      };
      final response = await _apiClient.post(
        '/api/appointments/$appointmentId/reschedule/',
        data: data,
      );
      return AppointmentModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AvailableSlotsResponse> getAvailableSlots(
    int doctorId, {
    String? date,
    String? clinicId,
  }) async {
    try {
      final queryParams = {
        'doctor': doctorId.toString(),
        if (date != null) 'date': date,
        if (clinicId != null) 'clinic': clinicId,
      };
      final response = await _apiClient.get(
        '/api/appointments/available-slots/',
        queryParameters: queryParams,
      );
      return AvailableSlotsResponseModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CalendarView> getCalendarView({String? month}) async {
    try {
      final queryParams = month != null ? {'month': month} : null;
      final response = await _apiClient.get(
        '/api/appointments/calendar/',
        queryParameters: queryParams,
      );
      return CalendarViewModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Appointment>> getUpcomingAppointments() async {
    try {
      final response = await _apiClient.get('/api/appointments/upcoming/');
      final List<dynamic> appointmentsJson = response['results'];
      return appointmentsJson
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Appointment>> getAppointmentHistory() async {
    try {
      final response = await _apiClient.get('/api/appointments/history/');
      final List<dynamic> appointmentsJson = response['results'];
      return appointmentsJson
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Appointment> bookEmergencyAppointment(
    Map<String, dynamic> emergencyData,
  ) async {
    try {
      final response = await _apiClient.post(
        '/api/appointments/book-emergency/',
        data: emergencyData,
      );
      return AppointmentModel.fromJson(response);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<AvailableSlotsResponse>> getDoctorSchedule(
    int doctorId, {
    String? startDate,
    String? endDate,
  }) async {
    try {
      final queryParams = {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      };
      final response = await _apiClient.get(
        '/api/appointments/doctor-schedule/$doctorId/',
        queryParameters: queryParams,
      );
      final List<dynamic> schedulesJson = response['results'];
      return schedulesJson
          .map((json) => AvailableSlotsResponseModel.fromJson(json))
          .toList();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
