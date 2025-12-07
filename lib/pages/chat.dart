import 'package:flutter/material.dart';
import 'package:my_health_core/widgets/chat_message.dart';
import 'package:my_health_core/widgets/new_message.dart';
import 'package:my_health_core/styles/app_colors.dart'; // Import the AppColors

class ChatScreen extends StatelessWidget {
  final String recipientUserId;

  // Declare the constructor as const
  const ChatScreen({Key? key, required this.recipientUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(
            color: AppColors.getTextColor(context),
          ),
        ),
        backgroundColor: AppColors.getButtonColor(context),
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