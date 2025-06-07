import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconnect_app/app/theme/app_theme.dart';
import 'package:mediconnect_app/domain/entities/user.dart';
import 'package:mediconnect_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:mediconnect_app/presentation/widgets/navigation/main_bottom_navigation_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state.status != AuthStatus.authenticated || state.user == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user!;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Cerrar sesión',
                onPressed: () => _confirmLogout(context),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileHeader(context, user),
              const SizedBox(height: 24),
              _buildProfileInfo(context, user),
              const SizedBox(height: 32),
              if (user.isDoctor) _buildDoctorInfo(context),
              if (user.isPatient) _buildPatientInfo(context),
              const SizedBox(height: 32),
              _buildAccountSettings(context),
            ],
          ),
          bottomNavigationBar: const MainBottomNavigationBar(currentIndex: 3),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context, User user) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryColor.withValues(alpha: .1),
              border: Border.all(color: AppTheme.primaryColor, width: 2),
              image: user.avatarUrl != null
                  ? DecorationImage(
                      image: NetworkImage(user.avatarUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: user.avatarUrl == null
                ? Center(
                    child: Text(
                      '${user.firstName[0]}${user.lastName[0]}',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            _getUserTypeLabel(user),
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, User user) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información personal',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow(Icons.email_outlined, 'Email', user.email),
            _buildInfoRow(Icons.phone_outlined, 'Teléfono', user.phoneNumber),
            _buildInfoRow(
              Icons.verified_user_outlined,
              'Estado de cuenta',
              user.isVerified ? 'Verificado' : 'Pendiente de verificación',
              valueColor: user.isVerified ? Colors.green : Colors.orange,
            ),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              'Miembro desde',
              '${user.dateJoined.day}/${user.dateJoined.month}/${user.dateJoined.year}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorInfo(BuildContext context) {
    // En una implementación real, estos datos vendrían de un repositorio
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información profesional',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow(
              Icons.medical_services_outlined,
              'Especialidad',
              'Cardiología',
            ),
            _buildInfoRow(Icons.work_outline, 'Licencia', 'MED-12345'),
            _buildInfoRow(
              Icons.home_work_outlined,
              'Clínica',
              'Hospital Central',
            ),
            _buildInfoRow(Icons.schedule, 'Pacientes atendidos', '543'),
            _buildInfoRow(Icons.star_outlined, 'Calificación', '4.8/5.0'),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfo(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información médica',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow(
              Icons.medical_information_outlined,
              'Grupo sanguíneo',
              'O+',
            ),
            _buildInfoRow(Icons.medication_outlined, 'Alergias', 'Ninguna'),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              'Fecha de nacimiento',
              '12/05/1985',
            ),
            _buildInfoRow(
              Icons.access_time_filled_outlined,
              'Última cita',
              '28/05/2023',
            ),
            _buildInfoRow(
              Icons.person_outline,
              'Médico principal',
              'Dr. Juan Pérez',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuración de cuenta',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Cambiar contraseña'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications_outlined),
              title: const Text('Preferencias de notificaciones'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacidad y seguridad'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Ayuda y soporte'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getUserTypeLabel(User user) {
    if (user.isDoctor) return 'Médico';
    if (user.isPatient) return 'Paciente';
    if (user.isAdmin) return 'Administrador';
    return 'Usuario';
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
            ),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<AuthBloc>().add(AuthLogoutEvent());
    }
  }
}
