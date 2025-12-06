import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';

class NewMessage extends StatefulWidget {
  final String recipientUserId;

  NewMessage({required this.recipientUserId});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You need to be logged in to send messages.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final username = userData.data()?['username'] ?? 'Unknown';

      // Add the message with the recipientUserId from the widget
      await FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userID': user.uid,
        'recipientID': widget.recipientUserId, // Use the passed recipientUserId
        'username': username,
        'userIDs': [user.uid, widget.recipientUserId],
      });

      FocusScope.of(context).unfocus();
      _messageController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send message. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _messageController,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  enableSuggestions: true,
                  style: TextStyle(color: AppColors.getTextColor(context)),
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(
                      color: AppColors.getTextColor(context).withOpacity(0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.myrtleGreen,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send),
              color: Colors.white,
              onPressed: _submitMessage,
            ),
          ),
        ],
      ),
    );
  }
}
