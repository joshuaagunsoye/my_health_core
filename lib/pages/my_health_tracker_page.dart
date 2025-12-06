import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';

// Defines data structure for each tracking feature in the app.
class TrackerFeatureItemData {
  final String title;
  final IconData icon;

  TrackerFeatureItemData({required this.title, required this.icon});
}

// StatelessWidget for displaying the 'My Health Tracker' section of the app.
// This page offers options to track various health aspects like tests, appointments, and symptoms.
class MyHealthTrackerPage extends StatelessWidget {
  // List of all features available in the Health Tracker section.
  final List<TrackerFeatureItemData> features = [
    TrackerFeatureItemData(title: 'Track your Tests', icon: Icons.check_circle),
    TrackerFeatureItemData(
        title: 'Track your Appointments', icon: Icons.calendar_today),
    TrackerFeatureItemData(title: 'Track your Symptoms', icon: Icons.healing),
    TrackerFeatureItemData(
        title: 'Track your Mental Health', icon: Icons.favorite),
    TrackerFeatureItemData(
        title: 'Track your Medication', icon: Icons.medication),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: CommonWidgets.buildAppBar('My Health Tracker'),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container for introductory text about the app's tracking capabilities.
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  // color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Easily manage your health with this all-in-one tracker.',
                  style: TextStyle(fontSize: 16.0, color: AppColors.getTextColor(context)),
                ),
              ),
              SizedBox(height: 24.0),
              ...features
                  .map((feature) => TrackerFeatureItem(
                        title: feature.title,
                        icon: feature.icon,
                        onTap: () => navigateToTrackerFeaturePage(
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

// Navigation logic based on the title of the selected tracking feature.
  void navigateToTrackerFeaturePage(BuildContext context, String title) {
    if (title == 'Track your Tests') {
      Navigator.pushNamed(context, '/test_tracker');
    }
    if (title == 'Track your Medication') {
      Navigator.pushNamed(context, '/medication_tracker');
    }
    if (title == 'Track your Appointments') {
      Navigator.pushNamed(context, '/appointment_tracker');
    }
    if (title == 'Track your Symptoms') {
      Navigator.pushNamed(context, '/symptom_tracker');
    }
    if (title == 'Track your Mental Health') {
      Navigator.pushNamed(context, '/mentalhealth_tracker');
    }
    // Add other if conditions for navigation as needed.
  }
}

class TrackerFeatureItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const TrackerFeatureItem({
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
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
