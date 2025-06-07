import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconnect_app/domain/entities/user.dart';
import 'package:mediconnect_app/presentation/blocs/auth/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Si no hay usuario autenticado, redirigir a login
        if (state.status != AuthStatus.authenticated || state.user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user!;

        // Mostrar dashboard según tipo de usuario
        if (user.isDoctor) {
          return _DoctorDashboard(user: user);
        } else if (user.isPatient) {
          return _PatientDashboard(user: user);
        } else if (user.isAdmin) {
          return _AdminDashboard(user: user);
        }

        // Opción predeterminada
        return _GenericDashboard(user: user);
      },
    );
  }
}

class _DoctorDashboard extends StatelessWidget {
  final User user;

  const _DoctorDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Médico'),
        actions: [_buildLogoutButton(context)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cabecera
          _buildHeader(context),
          const SizedBox(height: 24),

          // Tarjetas de acceso rápido
          const Text(
            'Accesos rápidos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildQuickAccessGrid(),

          const SizedBox(height: 24),

          // Próximas citas
          const Text(
            'Próximas citas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildUpcomingAppointmentsList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Citas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Pacientes'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
        onTap: (index) {
          // Navigate based on index
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 30,
              backgroundImage: user.avatarUrl != null
                  ? NetworkImage(user.avatarUrl!)
                  : null,
              child: user.avatarUrl == null ? Text(user.firstName[0]) : null,
            ),
            const SizedBox(width: 16),

            // Información
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenido, Dr. ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('${user.email} | ${user.phoneNumber}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [
        _buildQuickAccessCard(Icons.calendar_today, 'Nueva cita', Colors.blue),
        _buildQuickAccessCard(
          Icons.medical_services,
          'Historial médico',
          Colors.green,
        ),
        _buildQuickAccessCard(Icons.chat_bubble, 'Mensajes', Colors.orange),
        _buildQuickAccessCard(Icons.analytics, 'Estadísticas', Colors.purple),
      ],
    );
  }

  Widget _buildQuickAccessCard(IconData icon, String title, Color color) {
    return Card(
      color: color.withValues(alpha: .1),
      child: InkWell(
        onTap: () {
          // TODO: Implementar navegación
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointmentsList() {
    // Datos de ejemplo (en producción se obtendrían de una API)
    final appointments = [
      {
        'patient': 'María López',
        'time': '9:00 AM - 9:30 AM',
        'reason': 'Consulta general',
        'date': 'Hoy',
      },
      {
        'patient': 'Carlos Ruíz',
        'time': '10:15 AM - 10:45 AM',
        'reason': 'Seguimiento',
        'date': 'Hoy',
      },
      {
        'patient': 'Laura González',
        'time': '2:30 PM - 3:00 PM',
        'reason': 'Primera consulta',
        'date': 'Mañana',
      },
    ];

    return Column(
      children: appointments.map((appointment) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(child: Text(appointment['patient']![0])),
            title: Text(appointment['patient']!),
            subtitle: Text('${appointment['time']}: ${appointment['reason']}'),
            trailing: Chip(
              label: Text(appointment['date']!),
              backgroundColor: appointment['date'] == 'Hoy'
                  ? Colors.blue.withValues(alpha: .2)
                  : Colors.grey.withValues(alpha: .2),
            ),
            onTap: () {
              // TODO: Ver detalles de cita
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        context.read<AuthBloc>().add(AuthLogoutEvent());
      },
    );
  }
}

// Dashboard para pacientes (simplificado)
class _PatientDashboard extends StatelessWidget {
  final User user;

  const _PatientDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi salud'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutEvent());
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Bienvenido, ${user.fullName}! (Dashboard Paciente)'),
      ),
    );
  }
}

// Dashboard para administradores (simplificado)
class _AdminDashboard extends StatelessWidget {
  final User user;

  const _AdminDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Administrativo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutEvent());
            },
          ),
        ],
      ),
      body: Center(child: Text('Bienvenido Admin ${user.fullName}!')),
    );
  }
}

// Dashboard genérico
class _GenericDashboard extends StatelessWidget {
  final User user;

  const _GenericDashboard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MediConnect'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutEvent());
            },
          ),
        ],
      ),
      body: Center(child: Text('Bienvenido, ${user.fullName}!')),
    );
  }
}
