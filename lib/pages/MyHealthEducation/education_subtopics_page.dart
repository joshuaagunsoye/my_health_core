import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';

class HivBasicsPage extends StatelessWidget {
  const HivBasicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('HIV Basics', context: context),
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SubtopicTile(
              title: 'HIV 101',
              onTap: () => Navigator.pushNamed(context, '/hiv_101'),
            ),
            _SubtopicTile(
              title: 'HIV Treatment',
              onTap: () => Navigator.pushNamed(context, '/treatment'),
            ),
            _SubtopicTile(
              title: 'HIV and Black Communities',
              onTap: () => Navigator.pushNamed(context, '/hiv_black_communities'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }
}

class HivPreventionPage extends StatelessWidget {
  const HivPreventionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('HIV Prevention', context: context),
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SubtopicTile(
              title: 'HIV Testing',
              onTap: () => Navigator.pushNamed(context, '/testing'),
            ),
            _SubtopicTile(
              title: 'PrEP',
              onTap: () => Navigator.pushNamed(context, '/prep'),
            ),
            _SubtopicTile(
              title: 'PEP',
              onTap: () => Navigator.pushNamed(context, '/pep'),
            ),
            _SubtopicTile(
              title: 'Condoms',
              onTap: () => Navigator.pushNamed(context, '/condoms'),
            ),
            _SubtopicTile(
              title: 'Safer Substance Use',
              onTap: () => Navigator.pushNamed(context, '/safer_substance_use'),
            ),
            _SubtopicTile(
              title: 'Understanding HIV Stigma',
              onTap: () => Navigator.pushNamed(context, '/hiv_stigma'),
            ),
            _SubtopicTile(
              title: 'Undetectable = Untransmittable (U=U)',
              onTap: () => Navigator.pushNamed(context, '/u_equals_u'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }
}

class _SubtopicTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _SubtopicTile({
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
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
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
