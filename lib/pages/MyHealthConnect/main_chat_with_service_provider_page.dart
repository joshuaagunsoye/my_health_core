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
                color: AppColors.backgroundGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Connect with healthcare professionals to get the support you need.',
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
            // A grid view that displays different service providers.
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              children: <Widget>[
                ServiceProviderCard(
                  serviceProviderName: 'Physician',
                  iconData: Icons.local_hospital,
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
                  iconData: Icons.medical_services,
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
                  iconData: Icons.people,
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
                  serviceProviderName: 'Nutritionist',
                  iconData: Icons.restaurant_menu,
                  onTap: () {
                    // Navigate to the simulated chat screen for Nutritionist
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SimulatedChatScreen(
                          recipientUserId: 'nutritionist', // Unique ID for the provider
                          recipientName: 'Nutritionist',
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
  final IconData iconData;
  final VoidCallback onTap;

  ServiceProviderCard({
    Key? key,
    required this.serviceProviderName,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
