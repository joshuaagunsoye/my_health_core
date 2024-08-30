

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_health_core/widgets/chat_message.dart';
import 'package:my_health_core/widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Health Connect',
          style: TextStyle(
            color: Colors.white,  // Change the title text color here
          ),
        ),
        backgroundColor: Color(0xFF561217),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         FirebaseAuth.instance.signOut();
        //       },
        //       icon: Icon (
        //         Icons.exit_to_app,
        //         color: Colors.white,
        //       ),
        //   ),
        // ],
      ),
      body: Column(children: const [
        Expanded(
            child: ChatMessage()
        ),
        NewMessage(),
      ],
      ),
    );
  }
}