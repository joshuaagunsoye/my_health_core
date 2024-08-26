import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
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
      // Check if the user is authenticated
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // If the user is not logged in, show a message or handle accordingly
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You need to be logged in to send messages.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Retrieve user data from Firestore
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      // Get the username or set it to 'Unknown' if not found
      final username = userData.data()?['username'] ?? 'Unknown';

      // Add the message to the 'chat' collection in Firestore
      await FirebaseFirestore.instance.collection('chat').add({
        'text': enteredMessage,
        'createdAt': Timestamp.now(),
        'userID': user.uid,
        'username': username,
      });

      FocusScope.of(context).unfocus();

      // Clear the text field after sending the message
      _messageController.clear();
    } catch (error) {
      // Handle any errors that occur during the Firestore operation
      print('Failed to send message: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Set the entire background to white
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(
                labelText: 'Send a message...',
                border: OutlineInputBorder(),
                labelStyle: const TextStyle(
                  color: Colors.white, // Change the label text color to white
                ),
              ),
              style: const TextStyle(
                color: Colors.white, // Change the input text color to white
              ),
            ),
          ),
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.send),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}
