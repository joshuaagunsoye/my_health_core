import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_health_core/widgets/message_bubble.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return Container(
      color: Colors.black,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found'),
            );
          }
          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          // Print loaded messages
          for (var doc in loadedMessages) {
            final data = doc.data() as Map<String, dynamic>;
          }

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
