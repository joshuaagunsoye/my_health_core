import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/providers/theme_provider.dart';

// Defines data structure for each feature in the Connect section of the app.
class ConnectFeatureItemData {
  final String title;
  final IconData icon;

  ConnectFeatureItemData({required this.title, required this.icon});
}

// StatelessWidget for displaying the 'My Health Connect' section.
// This page includes options to interact with community stories, service providers, and peers.
class MyHealthConnectPage extends StatelessWidget {
  final List<ConnectFeatureItemData> features = [
    ConnectFeatureItemData(
        title: 'Connect with a Service Provider', icon: Icons.chat),
    ConnectFeatureItemData(title: 'Connect with a Community Navigator', icon: Icons.forum),
  ];

  @override
  Widget build(BuildContext context) {
    // Watch the theme provider to rebuild when theme changes
    context.watch<ThemeProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: CommonWidgets.buildAppBar('My Health Connect'),
      // Centers the content and allows vertical scrolling.
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Decorative container providing a brief intro to the page functionality.
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  // color: AppColors.getSurfaceColor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Connect with your community and healthcare professionals for support and guidance.',
                  style: TextStyle(fontSize: 16.0, color: AppColors.getTextColor(context)),
                ),
              ),
              SizedBox(height: 24.0),
              // Dynamically generates a list of feature items for the connect section.
              ...features
                  .map((feature) => ConnectFeatureItem(
                        title: feature.title,
                        icon: feature.icon,
                        onTap: () => navigateToConnectFeaturePage(
                            context, feature.title),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }

  // Navigates to the specific feature page based on the title of the selected feature.
  void navigateToConnectFeaturePage(BuildContext context, String title) {
    if (title == 'Community Stories') {
      Navigator.pushNamed(context, '/main_community_stories');
    }
    if (title == 'Connect with a Service Provider') {
      Navigator.pushNamed(context, '/main_chat_with_service_provider');
    }
    if (title == 'Connect with a Community Navigator') {
      Navigator.pushNamed(context, '/main_chat_with_peer');
    }
  }
}

// StatelessWidget to render each feature item with modern styling (icons and arrows outside cards).
class ConnectFeatureItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ConnectFeatureItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          color: AppColors.getSurfaceColor(context),
          margin: EdgeInsets.zero,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: AppColors.getAccentColor(context), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
