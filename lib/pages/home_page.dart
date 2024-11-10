import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart'; // Swiper package
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FeatureItemData> allFeatures = [
    FeatureItemData(title: 'MyHealthEducation', icon: Icons.school),
    FeatureItemData(title: 'MyHealthConnect', icon: Icons.people_alt),
    FeatureItemData(title: 'MyHealthLocator', icon: Icons.location_pin),
    FeatureItemData(title: 'MyHealthTracker', icon: Icons.track_changes),
  ];

  List<FeatureItemData> filteredFeatures = [];
  final TextEditingController _searchController = TextEditingController();

  final List<CarouselItemData> _carouselItems = [
    CarouselItemData(
      title: 'Commentary: After 40 years of AIDS, why do we still not have an HIV vaccine?',
      imageUrl: 'assets/images/news1.png',
      hyperlink: 'https://www.channelnewsasia.com/commentary/hiv-aids-vaccine-40-years-testing-treatment-trials-4210821',
    ),
    CarouselItemData(
      title: 'Scientists say they can cut HIV out of cells',
      imageUrl: 'assets/images/news2.png',
      hyperlink: 'https://www.bbc.com/news/health-68609297',
    ),
    CarouselItemData(
      title: 'Major change is coming - long acting PrEP (Pre-Exposure Prophylaxis)',
      imageUrl: 'assets/images/news3.png',
      hyperlink: 'https://www.catie.ca/treatmentupdate-250/major-change-is-coming-long-acting-hiv-pre-exposure-prophylaxis',
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredFeatures.addAll(allFeatures);
  }

  void _testURL() {
    const testUrl = 'https://www.google.com';
    _launchURL(testUrl);
  }

  void _onSearchSubmitted(String keyword) {
    if (keyword.isNotEmpty) {
      String googleSearchUrl =
          'https://www.google.com/search?q=site:catie.ca+$keyword';
      _launchURL(googleSearchUrl);
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url); // Parse the URL
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Open in an external browser
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('My Health Core'),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: AppColors.font),
                  onSubmitted: _onSearchSubmitted,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: AppColors.font),
                    prefixIcon: Icon(Icons.search, color: AppColors.white),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Latest News Swiper
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Latest News',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: AppColors.white,
                        shadows: [
                          Shadow(
                            color: AppColors.black.withOpacity(0.5),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 225.0, // Fixed height for Swiper
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        final item = _carouselItems[index];
                        return InkWell(
                          onTap: () => _launchURL(item.hyperlink),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(item.imageUrl),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: AppColors.white,
                                  backgroundColor: AppColors.black.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _carouselItems.length,
                      autoplay: true,
                      pagination: SwiperPagination(),
                    ),
                  ),
                ],
              ),
            ),

            // Quick Feature Access List
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: filteredFeatures.map((feature) {
                  return FeatureItem(title: feature.title, icon: feature.icon);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

class CarouselItemData {
  final String title;
  final String imageUrl;
  final String hyperlink;

  CarouselItemData({
    required this.title,
    required this.imageUrl,
    required this.hyperlink,
  });
}

class FeatureItemData {
  final String title;
  final IconData icon;

  FeatureItemData({
    required this.title,
    required this.icon,
  });
}

class FeatureItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const FeatureItem({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToFeaturePage(String routeName) {
      Navigator.pushNamed(context, routeName);
    }

    String routeName = '';
    switch (title) {
      case 'MyHealthEducation':
        routeName = '/my_health_education';
        break;
      case 'MyHealthConnect':
        routeName = '/my_health_connect';
        break;
      case 'MyHealthLocator':
        routeName = '/my_health_locator';
        break;
      case 'MyHealthTracker':
        routeName = '/my_health_tracker';
        break;
      default:
        break;
    }

    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          navigateToFeaturePage(routeName);
        },
      ),
    );
  }
}
