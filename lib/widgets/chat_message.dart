import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_health_core/widgets/message_bubble.dart';

class ChatMessage extends StatelessWidget {
  final String recipientUserId;

  ChatMessage({required this.recipientUserId});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Column(
      children: [
        // Disclaimer
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          color: Colors.yellow.shade100,
          child: const Text(
            'Important: This chat is not for sharing personal health information. '
                'Please consult a medical professional for health-related concerns.',
            style: TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(height: 0),
        // Chat messages
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('chat')
                .where('userIDs', arrayContains: authenticatedUser.uid)
                .snapshots(),
            builder: (ctx, chatSnapshots) {
              if (chatSnapshots.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (chatSnapshots.hasError) {
                print('Error: ${chatSnapshots.error}');
                return Center(child: Text('Error fetching messages'));
              }
              if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
                return const Center(
                  child: Text('No messages found'),
                );
              }
              final loadedMessages = chatSnapshots.data!.docs.where((doc) {
                final chatMessage = doc.data() as Map<String, dynamic>;
                return chatMessage['userIDs'].contains(recipientUserId);
              }).toList();

              print('Loaded messages: ${loadedMessages.map((doc) => doc.data()).toList()}');

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
                itemCount: loadedMessages.length,
                itemBuilder: (ctx, index) {
                  final chatMessage = loadedMessages[index].data() as Map<String, dynamic>;
                  final nextChatMessage = index + 1 < loadedMessages.length
                      ? loadedMessages[index + 1].data() as Map<String, dynamic>
                      : null;
                  final currentMessageUserId = chatMessage['userID'];
                  final nextMessageUserId = nextChatMessage != null
                      ? nextChatMessage['userID']
                      : null;
                  final nextUserIsSame = nextMessageUserId == currentMessageUserId;
                  return nextUserIsSame
                      ? MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId,
                  )
                      : MessageBubble.first(
                    username: chatMessage['username'] ?? 'Unknown',
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageUserId,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
