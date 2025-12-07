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
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: CommonWidgets.buildAppBar('My Health Connect'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.0),
            CommonWidgets.buildMainHeading('Chat with a Community Navigator'),
            SizedBox(height: 8.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Start a chat to ask questions or seek support 24/7. Please do not share any personal health information, such as your health card number or medical records.',
                style: TextStyle(
                  fontSize: 14.0,
                  color: AppColors.getTextColor(context),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where(FieldPath.documentId, whereIn: specificUserIds)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No users found'));
                }

                // Exclude the current authenticated user from the list
                final users = snapshot.data!.docs.where((doc) {
                  return doc.id != authenticatedUser?.uid;
                }).toList();

                if (users.isEmpty) {
                  return Center(child: Text('No community navigators available'));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  itemCount: users.length,
                  itemBuilder: (ctx, index) {
                    final user = users[index];
                    final IconData genderIcon = index % 2 == 0 ? Icons.man : Icons.woman;
                    return ServiceProviderCard(
                      serviceProviderName: user['username'] ?? 'Community Navigator ${index + 1}',
                      iconData: genderIcon,
                      userId: user.id,
                    );
                  },
                );
              },
            ),
          ],
        ),
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
      color: AppColors.mintGreen.withOpacity(0.3),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                recipientUserId: userId,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  color: AppColors.mintGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 40.0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  serviceProviderName,
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

