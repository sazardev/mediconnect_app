import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mediconnect_app/domain/entities/appointment.dart';
import 'package:mediconnect_app/presentation/blocs/appointment/appointment_bloc.dart';
import 'package:mediconnect_app/presentation/blocs/appointment/appointment_event.dart';
import 'package:mediconnect_app/presentation/blocs/appointment/appointment_state.dart';
import 'package:mediconnect_app/presentation/widgets/empty_state.dart';
import 'package:mediconnect_app/presentation/widgets/error_state.dart';
import 'package:mediconnect_app/presentation/widgets/loading_indicator.dart';

/// Página principal de citas médicas
class AppointmentsPage extends StatefulWidget {
  /// Constructor
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Cargar datos iniciales
    _loadUpcomingAppointments();
  }

  /// Carga las próximas citas
  void _loadUpcomingAppointments() {
    context.read<AppointmentBloc>().add(const AppointmentLoadUpcomingEvent());
  }

  /// Carga el historial de citas
  void _loadAppointmentHistory() {
    context.read<AppointmentBloc>().add(const AppointmentLoadHistoryEvent());
  }

  /// Carga la vista de calendario
  void _loadCalendarView() {
    final now = DateTime.now();
    final month = DateFormat('yyyy-MM').format(now);
    context.read<AppointmentBloc>().add(
      AppointmentLoadCalendarEvent(month: month),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas Médicas'),
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState(() {
              if (index == 0) {
                _loadUpcomingAppointments();
              } else if (index == 1) {
                _loadAppointmentHistory();
              } else if (index == 2) {
                _loadCalendarView();
              }
            });
          },
          tabs: const [
            Tab(text: 'Próximas'),
            Tab(text: 'Historial'),
            Tab(text: 'Calendario'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _UpcomingAppointmentsTab(),
          _AppointmentHistoryTab(),
          _CalendarViewTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateAppointmentPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Tab para mostrar próximas citas
class _UpcomingAppointmentsTab extends StatelessWidget {
  const _UpcomingAppointmentsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoadingState) {
          return const LoadingIndicator();
        } else if (state is AppointmentUpcomingLoadedState) {
          return _buildAppointmentList(context, state.appointments);
        } else if (state is AppointmentErrorState) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () {
              context.read<AppointmentBloc>().add(
                const AppointmentLoadUpcomingEvent(),
              );
            },
          );
        } else {
          return const Center(child: Text('Cargue las citas próximas'));
        }
      },
    );
  }

  Widget _buildAppointmentList(
    BuildContext context,
    List<Appointment> appointments,
  ) {
    if (appointments.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.calendar_today,
        title: 'No hay citas próximas',
        message: 'Toca el botón "+" para agendar una nueva cita',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<AppointmentBloc>().add(
          const AppointmentLoadUpcomingEvent(),
        );
      },
      child: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _AppointmentCard(appointment: appointment);
        },
      ),
    );
  }
}

/// Tab para mostrar historial de citas
class _AppointmentHistoryTab extends StatelessWidget {
  const _AppointmentHistoryTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoadingState) {
          return const LoadingIndicator();
        } else if (state is AppointmentHistoryLoadedState) {
          return _buildAppointmentList(context, state.appointments);
        } else if (state is AppointmentErrorState) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () {
              context.read<AppointmentBloc>().add(
                const AppointmentLoadHistoryEvent(),
              );
            },
          );
        } else {
          return const Center(child: Text('Cargue el historial de citas'));
        }
      },
    );
  }

  Widget _buildAppointmentList(
    BuildContext context,
    List<Appointment> appointments,
  ) {
    if (appointments.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.history,
        title: 'No hay historial de citas',
        message: 'Aquí se mostrarán sus citas pasadas',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<AppointmentBloc>().add(
          const AppointmentLoadHistoryEvent(),
        );
      },
      child: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return _AppointmentCard(appointment: appointment, isHistory: true);
        },
      ),
    );
  }
}

/// Tab para mostrar vista de calendario
class _CalendarViewTab extends StatelessWidget {
  const _CalendarViewTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoadingState) {
          return const LoadingIndicator();
        } else if (state is AppointmentCalendarLoadedState) {
          return _buildCalendarView(context, state.calendarView);
        } else if (state is AppointmentErrorState) {
          return ErrorStateWidget(
            message: state.message,
            onRetry: () {
              final now = DateTime.now();
              final month = DateFormat('yyyy-MM').format(now);
              context.read<AppointmentBloc>().add(
                AppointmentLoadCalendarEvent(month: month),
              );
            },
          );
        } else {
          return const Center(child: Text('Cargue el calendario'));
        }
      },
    );
  }

  Widget _buildCalendarView(BuildContext context, CalendarView calendarView) {
    return Column(
      children: [
        _CalendarHeader(month: calendarView.month),
        Expanded(
          child: ListView.builder(
            itemCount: calendarView.days.length,
            itemBuilder: (context, index) {
              final day = calendarView.days[index];
              return _CalendarDayCard(day: day);
            },
          ),
        ),
        _CalendarSummary(summary: calendarView.summary),
      ],
    );
  }
}

/// Encabezado del calendario
class _CalendarHeader extends StatelessWidget {
  final String month;

  const _CalendarHeader({required this.month});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final currentMonth = DateFormat('yyyy-MM').format(now);

    final dateFormat = DateFormat('MMMM yyyy', 'es_ES');
    final date = DateFormat('yyyy-MM').parse(month);
    final formattedMonth = dateFormat.format(date);

    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.primaryColor.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              final previousMonth = DateTime(date.year, date.month - 1);
              final formattedPreviousMonth = DateFormat(
                'yyyy-MM',
              ).format(previousMonth);
              context.read<AppointmentBloc>().add(
                AppointmentLoadCalendarEvent(month: formattedPreviousMonth),
              );
            },
          ),
          Text(
            formattedMonth,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: month == currentMonth
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              final nextMonth = DateTime(date.year, date.month + 1);
              final formattedNextMonth = DateFormat(
                'yyyy-MM',
              ).format(nextMonth);
              context.read<AppointmentBloc>().add(
                AppointmentLoadCalendarEvent(month: formattedNextMonth),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de día en el calendario
class _CalendarDayCard extends StatelessWidget {
  final CalendarDay day;

  const _CalendarDayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final isToday = day.date == today;

    return Card(
      elevation: isToday ? 4 : 1,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isToday
                ? theme.primaryColor
                : theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              DateFormat('dd').format(DateFormat('yyyy-MM-dd').parse(day.date)),
              style: theme.textTheme.titleMedium?.copyWith(
                color: isToday ? Colors.white : null,
                fontWeight: isToday ? FontWeight.bold : null,
              ),
            ),
          ),
        ),
        title: Text(
          DateFormat(
            'EEEE',
            'es_ES',
          ).format(DateFormat('yyyy-MM-dd').parse(day.date)),
          style: theme.textTheme.titleSmall,
        ),
        subtitle: Text(
          day.appointmentsCount > 0
              ? '${day.appointmentsCount} citas'
              : 'No hay citas',
          style: theme.textTheme.bodySmall,
        ),
        trailing: day.hasAppointments
            ? Badge(
                label: Text(day.appointmentsCount.toString()),
                child: const Icon(Icons.event),
              )
            : const Icon(Icons.event_outlined),
        children: day.appointments.isEmpty
            ? [
                const ListTile(
                  title: Text('No hay citas para este día'),
                  leading: Icon(Icons.calendar_today),
                ),
              ]
            : day.appointments.map((appointment) {
                return ListTile(
                  leading: _getAppointmentStatusIcon(appointment.status),
                  title: Text(
                    '${appointment.time} - Dr(a). ${appointment.doctorName}',
                  ),
                  subtitle: Text(_getAppointmentTypeText(appointment.type)),
                  trailing: _getAppointmentPriorityIndicator(
                    appointment.priority,
                  ),
                  onTap: () {
                    // Navegar a detalles de cita
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AppointmentDetailsPage(
                          appointmentId: appointment.id,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
      ),
    );
  }

  Widget _getAppointmentStatusIcon(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return const Icon(Icons.schedule, color: Colors.blue);
      case AppointmentStatus.confirmed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case AppointmentStatus.completed:
        return const Icon(Icons.task_alt, color: Colors.purple);
      case AppointmentStatus.cancelled:
        return const Icon(Icons.cancel, color: Colors.red);
      case AppointmentStatus.noShow:
        return const Icon(Icons.person_off, color: Colors.orange);
    }
  }

  String _getAppointmentTypeText(AppointmentType type) {
    switch (type) {
      case AppointmentType.consultation:
        return 'Consulta';
      case AppointmentType.followUp:
        return 'Seguimiento';
      case AppointmentType.emergency:
        return 'Emergencia';
      case AppointmentType.checkUp:
        return 'Chequeo';
    }
  }

  Widget _getAppointmentPriorityIndicator(AppointmentPriority priority) {
    Color color;
    switch (priority) {
      case AppointmentPriority.low:
        color = Colors.blue;
        break;
      case AppointmentPriority.normal:
        color = Colors.green;
        break;
      case AppointmentPriority.high:
        color = Colors.orange;
        break;
      case AppointmentPriority.urgent:
        color = Colors.red;
        break;
    }

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Resumen del calendario
class _CalendarSummary extends StatelessWidget {
  final CalendarSummary summary;

  const _CalendarSummary({required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      color: theme.primaryColor.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen del Mes', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryItem(
                icon: Icons.schedule,
                color: Colors.blue,
                label: 'Programadas',
                value: summary.scheduled,
              ),
              _SummaryItem(
                icon: Icons.check_circle,
                color: Colors.green,
                label: 'Completadas',
                value: summary.completed,
              ),
              _SummaryItem(
                icon: Icons.cancel,
                color: Colors.red,
                label: 'Canceladas',
                value: summary.cancelled,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Próximas esta semana: ${summary.upcomingThisWeek}',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

/// Ítem en el resumen
class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final int value;

  const _SummaryItem({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text('$label: $value'),
      ],
    );
  }
}

/// Tarjeta de cita
class _AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final bool isHistory;

  const _AppointmentCard({required this.appointment, this.isHistory = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormatter = DateFormat('dd MMM yyyy', 'es_ES');
    final timeFormatter = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // Navegar a detalles de cita
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  AppointmentDetailsPage(appointmentId: appointment.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateFormatter.format(appointment.appointmentDate),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildStatusBadge(appointment.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${timeFormatter.format(appointment.appointmentDate)} - '
                    '${timeFormatter.format(appointment.appointmentEnd)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Text(
                    '${appointment.durationMinutes} min',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  ClipOval(
                    child: appointment.doctor.avatar != null
                        ? Image.network(
                            appointment.doctor.avatar!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildAvatarPlaceholder(),
                          )
                        : _buildAvatarPlaceholder(),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctor.fullName,
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        appointment.doctor.specialties?.join(', ') ?? '',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Motivo: ${appointment.reason}',
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              _buildAppointmentTypeChip(
                appointment.appointmentType,
                appointment.consultationMethod,
              ),
              if (!isHistory &&
                  appointment.status != AppointmentStatus.cancelled)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          _showCancelDialog(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          _showRescheduleDialog(context);
                        },
                        child: const Text('Reprogramar'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(AppointmentStatus status) {
    String text;
    Color color;

    switch (status) {
      case AppointmentStatus.scheduled:
        text = 'Programada';
        color = Colors.blue;
        break;
      case AppointmentStatus.confirmed:
        text = 'Confirmada';
        color = Colors.green;
        break;
      case AppointmentStatus.completed:
        text = 'Completada';
        color = Colors.purple;
        break;
      case AppointmentStatus.cancelled:
        text = 'Cancelada';
        color = Colors.red;
        break;
      case AppointmentStatus.noShow:
        text = 'No asistió';
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      width: 40,
      height: 40,
      color: Colors.grey.shade300,
      child: const Icon(Icons.person, color: Colors.grey),
    );
  }

  Widget _buildAppointmentTypeChip(
    AppointmentType type,
    ConsultationMethod method,
  ) {
    String typeText;
    String methodText;
    IconData typeIcon;
    IconData methodIcon;

    switch (type) {
      case AppointmentType.consultation:
        typeText = 'Consulta';
        typeIcon = Icons.medical_services;
        break;
      case AppointmentType.followUp:
        typeText = 'Seguimiento';
        typeIcon = Icons.restore;
        break;
      case AppointmentType.emergency:
        typeText = 'Emergencia';
        typeIcon = Icons.emergency;
        break;
      case AppointmentType.checkUp:
        typeText = 'Chequeo';
        typeIcon = Icons.health_and_safety;
        break;
    }

    switch (method) {
      case ConsultationMethod.inPerson:
        methodText = 'Presencial';
        methodIcon = Icons.person;
        break;
      case ConsultationMethod.videoCall:
        methodText = 'Videollamada';
        methodIcon = Icons.videocam;
        break;
      case ConsultationMethod.phone:
        methodText = 'Teléfono';
        methodIcon = Icons.phone;
        break;
    }

    return Row(
      children: [
        Chip(
          avatar: Icon(typeIcon, size: 16),
          label: Text(typeText),
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 8),
        Chip(
          avatar: Icon(methodIcon, size: 16),
          label: Text(methodText),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Cita'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('¿Está seguro de que desea cancelar esta cita?'),
            if (appointment.cancellationPolicy != null) ...[
              const SizedBox(height: 16),
              Text('Política de cancelación:'),
              Text(
                'Puede cancelar sin cargo hasta ${DateFormat('dd MMM yyyy HH:mm', 'es_ES').format(appointment.cancellationPolicy!.canCancelUntil)}',
              ),
              if (appointment.cancellationPolicy!.penaltyAmount > 0)
                Text(
                  'Cargo por cancelación tardía: ${appointment.cancellationPolicy!.penaltyAmount} ${appointment.fees.currency}',
                ),
              Text(
                'Cancelaciones gratuitas restantes: ${appointment.cancellationPolicy!.freeCancellationsRemaining}',
              ),
            ],
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Motivo de cancelación',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Cancelar cita
              context.read<AppointmentBloc>().add(
                AppointmentCancelEvent(
                  appointment.id,
                  reason: 'Motivo ingresado por el usuario',
                ),
              );
              Navigator.of(context).pop();
              // Mostrar snackbar de confirmación
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cita cancelada exitosamente')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showRescheduleDialog(BuildContext context) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(
      appointment.appointmentDate,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reprogramar Cita'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Seleccione una nueva fecha y hora:'),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Fecha'),
                subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                  );
                  if (date != null) {
                    selectedDate = date;
                  }
                },
              ),
              ListTile(
                title: const Text('Hora'),
                subtitle: Text(
                  '${selectedTime.hour}:${selectedTime.minute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) {
                    selectedTime = time;
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Motivo del cambio',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Crear fecha completa combinando fecha y hora
              final newDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );

              // Reprogramar cita
              context.read<AppointmentBloc>().add(
                AppointmentRescheduleEvent(
                  appointment.id,
                  newDateTime,
                  reason: 'Motivo ingresado por el usuario',
                ),
              );
              Navigator.of(context).pop();
              // Mostrar snackbar de confirmación
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cita reprogramada exitosamente')),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

/// Placeholder para la página de detalles de cita
class AppointmentDetailsPage extends StatelessWidget {
  final int appointmentId;

  const AppointmentDetailsPage({super.key, required this.appointmentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cita #$appointmentId')),
      body: Center(child: Text('Detalles de la cita $appointmentId')),
    );
  }
}

/// Placeholder para la página de creación de cita
class CreateAppointmentPage extends StatelessWidget {
  const CreateAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Cita')),
      body: const Center(child: Text('Formulario de creación de cita')),
    );
  }
}
