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
  
  // Navigator images
  final List<String> navigatorImages = [
    'assets/images/nav1.png',
    'assets/images/nav2.png',
    'assets/images/nav3.png',
    'assets/images/nav4.png',
  ];

  @override
  Widget build(BuildContext context) {
    // Retrieve the current authenticated user
    final authenticatedUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.mintGreen,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/connect2.png',
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          'Chat with a Community Navigator',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 16.0),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Start a chat to ask questions or seek support 24/7. Please do not share any personal health information, such as your health card number or medical records.',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 24.0),
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

                // Build list of all navigators (real + placeholders)
                List<Widget> navigatorCards = [];
                
                // Add real navigators from Firestore
                for (int i = 0; i < users.length; i++) {
                  final user = users[i];
                  navigatorCards.add(
                    ServiceProviderCard(
                      serviceProviderName: 'Community Navigator ${i + 1}',
                      imagePath: navigatorImages[i % navigatorImages.length],
                      userId: user.id,
                      isPlaceholder: false,
                    ),
                  );
                }
                
                // Add placeholder navigators to reach total of 4
                for (int i = users.length; i < 4; i++) {
                  navigatorCards.add(
                    ServiceProviderCard(
                      serviceProviderName: 'Community Navigator ${i +1}',
                      imagePath: navigatorImages[i],
                      userId: '',
                      isPlaceholder: true,
                    ),
                  );
                }

                return GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: navigatorCards,
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
  final String imagePath;
  final String userId;
  final bool isPlaceholder;

  ServiceProviderCard({
    Key? key,
    required this.serviceProviderName,
    required this.imagePath,
    required this.userId,
    this.isPlaceholder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isPlaceholder ? 0.6 : 1.0,
      child: Column(
        children: [
          Card(
            color: AppColors.getSurfaceColor(context),
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: isPlaceholder ? null : () {
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
              child: Container(
                height: 150,
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 80.0,
                        color: AppColors.getTextColor(context),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 4.0),
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
    );
  }
}

