import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/pages/simulated_chat_screen.dart';

// This page allows users to initiate a chat with various service providers.
class MainChatWithServiceProviderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightTeal,
      // Top AppBar with a title specific to the service provider chat feature.
      appBar: CommonWidgets.buildAppBar('My Health Connect'),
      // Scrollable body to accommodate various content lengths.
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.0),
            // Main heading
            CommonWidgets.buildMainHeading('Chat with a Service Provider'),
            // Description container that informs users about the availability of professional support.
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                // color: AppColors.backgroundGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Connect with healthcare professionals to get the support you need.',
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              ),
            ),
            // A grid view that displays different service providers.
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
                ServiceProviderCard(
                  serviceProviderName: 'Physician',
                  assetPath: 'assets/images/Physician.png',
                  onTap: () {
                    // Navigate to the simulated chat screen for Physician
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SimulatedChatScreen(
                          recipientUserId: 'physician', // Unique ID for the provider
                          recipientName: 'Physician',
                        ),
                      ),
                    );
                  },
                ),
                ServiceProviderCard(
                  serviceProviderName: 'Pharmacist',
                  assetPath: 'assets/images/Pharma.png',
                  onTap: () {
                    // Navigate to the simulated chat screen for Pharmacist
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SimulatedChatScreen(
                          recipientUserId: 'pharmacist', // Unique ID for the provider
                          recipientName: 'Pharmacist',
                        ),
                      ),
                    );
                  },
                ),
                ServiceProviderCard(
                  serviceProviderName: 'Social Worker',
                  assetPath: 'assets/images/SocialWork.png',
                  onTap: () {
                    // Navigate to the simulated chat screen for Social Worker
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SimulatedChatScreen(
                          recipientUserId: 'social_worker', // Unique ID for the provider
                          recipientName: 'Social Worker',
                        ),
                      ),
                    );
                  },
                ),
                ServiceProviderCard(
                  serviceProviderName: 'Registered Dietitian',
                  assetPath: 'assets/images/Dietitian.png',
                  onTap: () {
                    // Navigate to the simulated chat screen for Nutritionist
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SimulatedChatScreen(
                          recipientUserId: 'nutritionist', // Unique ID for the provider
                          recipientName: 'Dietitian',
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      // Bottom navigation bar to maintain app-wide navigation consistency.
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

// Represents a clickable card for each service provider in the grid.
class ServiceProviderCard extends StatelessWidget {
  final String serviceProviderName;
  final String assetPath;
  final VoidCallback onTap;

  ServiceProviderCard({
    Key? key,
    required this.serviceProviderName,
    required this.assetPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.mintGreen,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 60.0,
                height: 60.0,
                child: Image.asset(
                  assetPath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      size: 50.0,
                      color: Colors.black,
                    );
                  },
                ),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  serviceProviderName,
                  style: TextStyle(
                    color: Colors.black,
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
