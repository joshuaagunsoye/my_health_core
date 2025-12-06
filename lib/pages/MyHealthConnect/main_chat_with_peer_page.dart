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
    'Og1TwUu42WbNFI6qeru87uz0HHr2', // Replace with actual user IDs
    'lro5PXdqE4xWA47Qihvr',
  ];

  @override
  Widget build(BuildContext context) {
    // Retrieve the current authenticated user
    final authenticatedUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.getSurfaceColor(context),
      appBar: CommonWidgets.buildAppBar('My Health Connect'),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  CommonWidgets.buildMainHeading('Chat with a Peer'),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: AppColors.getSurfaceColor(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Connect with peers who understand your journey for support and guidance.',
                      style: TextStyle(
                        fontSize: 16.0, 
                        color: AppColors.getTextColor(context),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 24.0),
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
                    // Alternate between male and female icons
                    final IconData genderIcon = index % 2 == 0 ? Icons.man : Icons.woman;
                    return ServiceProviderCard(
                      serviceProviderName: user['username'] ?? 'Unknown',
                      iconData: genderIcon,
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
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
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
      color: AppColors.getSurfaceColor(context),
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
              Icon(iconData, size: 50.0, color: AppColors.getTextColor(context)),
              SizedBox(height: 8.0),
              Text(
                serviceProviderName,
                style: TextStyle(
                  color: AppColors.getTextColor(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

