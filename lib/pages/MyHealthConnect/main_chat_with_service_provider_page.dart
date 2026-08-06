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
      backgroundColor: AppColors.getBackgroundColor(context),
      // Top AppBar with a title specific to the service provider chat feature.
      appBar: CommonWidgets.buildAppBar('Chat with a Service Provider'),
      // Scrollable body to accommodate various content lengths.
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 8.0),
            // Description container that informs users about the availability of professional support.
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.mintGreen.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Start a chat to ask questions or seek support 24/7. Please do not share any personal health information, such as your health card number or medical records.',
                style: TextStyle(fontSize: 14.0, color: AppColors.getTextColor(context)),
              ),
            ),
            SizedBox(height: 16.0),
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
                  assetPath: 'assets/images/pharma1.png',
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
                  serviceProviderName: 'Dietitian',
                  assetPath: 'assets/images/dietitian.png',
                  onTap: () {
                    // Navigate to the simulated chat screen for Dietitian
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SimulatedChatScreen(
                          recipientUserId: 'registered_dietitian', // Unique ID for the provider
                          recipientName: 'Dietitian',
                        ),
                      ),
                    );
                  },
                ),
                ServiceProviderCard(
                  serviceProviderName: 'Social Worker',
                  assetPath: 'assets/images/socialw.png',
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
              ],
            ),
          ],
        ),
      ),
      // Bottom navigation bar to maintain app-wide navigation consistency.
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
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
    return Column(
      children: [
        Card(
          color: AppColors.getSurfaceColor(context),
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              height: 120,
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Center(
                child: Image.asset(
                  assetPath,
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
    );
  }
}
