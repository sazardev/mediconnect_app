import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediconnect_app/core/di/service_locator.dart';
import 'package:mediconnect_app/core/websocket/websocket_client.dart';
import 'package:mediconnect_app/domain/entities/user.dart';
import 'package:mediconnect_app/presentation/blocs/auth/auth_bloc.dart';

class ChatPage extends StatefulWidget {
  final String conversationId;
  final String recipientName;

  const ChatPage({
    super.key,
    required this.conversationId,
    required this.recipientName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  WebSocketConnection? _wsConnection;
  late User _currentUser;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _connectToChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _wsConnection?.dispose();
    super.dispose();
  }

  Future<void> _connectToChat() async {
    final authState = context.read<AuthBloc>().state;
    if (authState.user == null) return;

    _currentUser = authState.user!;

    final wsClient = ServiceLocator.instance.get<WebSocketClient>();
    _wsConnection = await wsClient.connectToChat(widget.conversationId);
    await _wsConnection?.connect();

    setState(() {
      _isConnected = true;
    });

    _wsConnection?.messageStream.listen((data) {
      if (data['type'] == 'message') {
        final message = ChatMessage(
          text: data['message'],
          isMe: data['sender_id'] == _currentUser.id.toString(),
          timestamp: DateTime.now(),
          senderName: data['sender_name'] ?? 'Usuario',
        );

        setState(() {
          _messages.add(message);
        });

        _scrollToBottom();
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || !_isConnected) return;

    final message = {
      'type': 'message',
      'message': _messageController.text.trim(),
      'conversation_id': widget.conversationId,
      'sender_id': _currentUser.id.toString(),
      'sender_name': _currentUser.fullName,
    };

    await _wsConnection?.send(message);
    _messageController.clear();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.recipientName),
            Text(
              _isConnected ? 'Conectado' : 'Conectando...',
              style: TextStyle(
                fontSize: 12,
                color: _isConnected ? Colors.green[300] : Colors.orange,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _connectToChat,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text(
                      'No hay mensajes aún. Envía el primero!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ChatBubble(message: message);
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withValues(alpha: .1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String senderName;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.senderName,
  });
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final alignment = message.isMe
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    final bubbleColor = message.isMe
        ? Theme.of(context).primaryColor
        : Theme.of(context).cardColor;
    final textColor = message.isMe
        ? Colors.white
        : Theme.of(context).textTheme.bodyLarge?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (!message.isMe)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 2),
              child: Text(
                message.senderName,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          Container(
            margin: EdgeInsets.only(
              left: message.isMe ? 64 : 0,
              right: message.isMe ? 0 : 64,
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black.withValues(alpha: .1),
                ),
              ],
            ),
            child: Text(message.text, style: TextStyle(color: textColor)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
            child: Text(
              '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
