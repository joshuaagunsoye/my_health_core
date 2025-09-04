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
    return Container(
      color: Colors.black,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .where('userIDs', arrayContains: authenticatedUser.uid) // Ensure the authenticated user is part of the conversation
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (chatSnapshots.hasError) {
            // Print error to debug
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
            return chatMessage['userIDs'].contains(recipientUserId); // Filter to ensure the recipient is part of the conversation
          }).toList();

          // Print loaded messages to debug
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
    );
  }
}
