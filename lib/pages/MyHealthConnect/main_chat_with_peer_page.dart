import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this to get the current user
import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/pages/chat.dart';

class MainChatWithPeerPage extends StatelessWidget {
  // List of specific user IDs to display
  final List<String> specificUserIds = [
    'user_id_1', // Replace with actual user IDs
    'user_id_2',
    'user_id_3',
    'user_id_4',
  ];

  @override
  Widget build(BuildContext context) {
    // Retrieve the current authenticated user
    final authenticatedUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: CommonWidgets.buildAppBar('My Health Connect'),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  CommonWidgets.buildMainHeading('Chat with a Peer'),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Connect with healthcare professionals to get the support you need.',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(AppColors.saffron),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                            context, '/select_a_service_provider');
                      },
                      child: Text('Select a Peer'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where(FieldPath.documentId, whereIn: specificUserIds) // Query specific users
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text('No users found')),
                );
              }

              // Exclude the current authenticated user from the list
              final users = snapshot.data!.docs.where((doc) {
                return doc.id != authenticatedUser?.uid; // Filter out current user
              }).toList();

              if (users.isEmpty) {
                return SliverFillRemaining(
                  child: Center(child: Text('No peers available')),
                );
              }

              return SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (ctx, index) {
                    final user = users[index];
                    return ServiceProviderCard(
                      serviceProviderName: user['username'] ?? 'Unknown',
                      iconData: Icons.person,
                      userId: user.id,
                    );
                  },
                  childCount: users.length,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

class ServiceProviderCard extends StatelessWidget {
  final String serviceProviderName;
  final IconData iconData;
  final String userId;

  ServiceProviderCard({
    Key? key,
    required this.serviceProviderName,
    required this.iconData,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                recipientUserId: userId, // Pass the user ID to the chat screen
              ),
            ),
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 50.0, color: Colors.black.withOpacity(0.7)),
              Text(serviceProviderName,
                  style: TextStyle(color: Colors.black.withOpacity(0.7))),
            ],
          ),
        ),
      ),
    );
  }
}

