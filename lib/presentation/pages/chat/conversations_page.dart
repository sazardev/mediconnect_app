import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconnect_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:mediconnect_app/presentation/pages/chat/chat_page.dart';
import 'package:mediconnect_app/presentation/widgets/navigation/main_bottom_navigation_bar.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversaciones')),
      bottomNavigationBar: const MainBottomNavigationBar(currentIndex: 2),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status != AuthStatus.authenticated || state.user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              // Estos son datos de prueba para demostrar la UI
              // En una implementación real, esto vendría de una API
              _ConversationTile(
                name: 'Dr. Juan Pérez',
                lastMessage: 'Buenos días, ¿cómo se ha sentido?',
                time: '10:30',
                unread: 2,
                conversationId: '1_2', // En formato: {user1_id}_{user2_id}
                onTap: () => _navigateToChat(context, '1_2', 'Dr. Juan Pérez'),
              ),
              _ConversationTile(
                name: 'Paciente: María González',
                lastMessage: 'Gracias doctor, mucho mejor.',
                time: '09:15',
                unread: 0,
                conversationId: '1_3',
                onTap: () => _navigateToChat(context, '1_3', 'María González'),
              ),
              _ConversationTile(
                name: 'Dr. Carlos Ruiz',
                lastMessage: 'Le anexo los resultados de laboratorio.',
                time: 'Ayer',
                unread: 1,
                conversationId: '1_4',
                onTap: () => _navigateToChat(context, '1_4', 'Dr. Carlos Ruiz'),
              ),
              _ConversationTile(
                name: 'Clínica Central - Grupo',
                lastMessage: 'Se ha programado una reunión para el viernes.',
                time: '28/05',
                unread: 0,
                conversationId: 'clinic_1',
                onTap: () => _navigateToChat(
                  context,
                  'clinic_1',
                  'Clínica Central - Grupo',
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _navigateToChat(
    BuildContext context,
    String conversationId,
    String name,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ChatPage(conversationId: conversationId, recipientName: name),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final String conversationId;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    required this.conversationId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          name.substring(0, 1),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: unread > 0 ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: unread > 0 ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
          if (unread > 0) const SizedBox(height: 5),
          if (unread > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Text(
                unread.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
