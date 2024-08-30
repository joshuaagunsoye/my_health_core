// bottom-navigation bar

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // For SystemNavigator.pop
import 'package:my_health_core/styles/app_colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  AppBottomNavigationBar({required this.currentIndex});

  Future<void> quickExit(BuildContext context) async {
    try {
      // Get the current user ID
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Update the user's status in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'status': 'offline',
        });

        // Sign out the user from Firebase Authentication
        await FirebaseAuth.instance.signOut();
      }

      // Exit the application
      SystemNavigator.pop(); // Use this to exit the app
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) async {
        // Handle "Quick Exit"
        if (index == 3) {
          await quickExit(context);
          return;
        }

        // Navigate to different pages based on the index
        switch (index) {
          case 0:
            Navigator.pushNamedAndRemoveUntil(
                context, '/home', (route) => false);
            break;
          case 1:
            if (ModalRoute.of(context)?.settings.name != '/saved') {
              Navigator.pushNamed(context, '/saved');
            }
            break;
          case 2:
            if (ModalRoute.of(context)?.settings.name != '/profile') {
              Navigator.pushNamed(context, '/profile');
            }
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.exit_to_app),
          label: 'Quick Exit',
        ),
      ],
      backgroundColor: AppColors.bottomNavigation,
      unselectedItemColor: AppColors.font,
      selectedItemColor: AppColors.white,
      type: BottomNavigationBarType.fixed, // Fixes the background color
      selectedFontSize: 14.0,
      unselectedFontSize: 14.0,
      showUnselectedLabels: true, // Shows all labels
    );
  }
}
