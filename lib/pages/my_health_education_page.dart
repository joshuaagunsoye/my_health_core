import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';

// MyHealthEducationPage provides two main topic categories that lead to subtopics.
class MyHealthEducationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.getButtonColor(context),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/myhealtheducationicon.png',
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
          'My Health Education',
          style: TextStyle(
            color: AppColors.getTextColor(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: AppColors.getTextColor(context),
        ),
      ),
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Explore a wealth of information and resources to enhance your health knowledge about HIV.',
                style: TextStyle(fontSize: 16.0, color: AppColors.getTextColor(context)),
              ),
            ),
            const SizedBox(height: 24.0),
            _TopicCard(
              title: 'HIV Basics',
              onTap: () => Navigator.pushNamed(context, '/hiv_basics'),
            ),
            const SizedBox(height: 16.0),
            _TopicCard(
              title: 'HIV Prevention',
              onTap: () => Navigator.pushNamed(context, '/hiv_prevention'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _TopicCard({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.getCardColor(context),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.getAccentColor(context),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
