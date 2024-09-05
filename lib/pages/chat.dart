import 'package:flutter/material.dart';
import 'package:my_health_core/widgets/chat_message.dart';
import 'package:my_health_core/widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  final String recipientUserId;

  // Declare the constructor as const
  const ChatScreen({required this.recipientUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF561217),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatMessage(recipientUserId: recipientUserId), // Pass the recipientUserId
          ),
          NewMessage(recipientUserId: recipientUserId), // Pass the recipientUserId
        ],
      ),
    );
  }
}
