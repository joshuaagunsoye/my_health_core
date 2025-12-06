import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_health_core/widgets/web_view_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _username = "User"; // Default username
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  // Define feature data with image paths
  final List<FeatureData> _features = [
    FeatureData(
      title: 'MyHealthEducation',
      imagePath: 'assets/images/education.png',
      route: '/my_health_education',
    ),
    FeatureData(
      title: 'MyHealthConnect',
      imagePath: 'assets/images/connect.png',
      route: '/my_health_connect',
    ),
    FeatureData(
      title: 'MyHealthLocator',
      imagePath: 'assets/images/locator.png',
      route: '/my_health_locator',
    ),
    FeatureData(
      title: 'MyHealthTracker',
      imagePath: 'assets/images/tracker.png',
      route: '/my_health_tracker',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        setState(() {
          _username = doc['username'] ?? "User";
        });
      }
    }
  }

  void _onSearchSubmitted(String keyword) {
    if (keyword.isNotEmpty) {
      String searchUrl = Uri.https('www.catie.ca', '/search', {
        'query': keyword,
        'audience': 'All',
        'infection': 'All',
        'resource_type': 'All',
        'resource_population': 'All',
        'sort_by': 'search_api_relevance',
      }).toString();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(
            url: searchUrl,
            title: 'Search Results',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a search term')),
      );
    }
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getButtonColor(context),
        elevation: 0,
        title: Row(
          children: [
            // Waving hand icon and greeting
            Row(
              children: [
                Icon(
                  Icons.waving_hand, // Use the waving hand icon
                  color: AppColors.getTextColor(context),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  "Hi, $_username!",
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            CircleAvatar(
              backgroundColor: AppColors.getSurfaceColor(context),
              radius: 20,
              child: Text(
                _username.isNotEmpty ? _username[0].toUpperCase() : "U",
                style: TextStyle(
                  color: AppColors.getAccentColor(context),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: AppColors.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: AppColors.getTextColor(context)),
                  onSubmitted: _onSearchSubmitted,
                  decoration: InputDecoration(
                    hintText: 'Search health topics...',
                    hintStyle: TextStyle(
                      color: AppColors.getTextColor(context).withOpacity(0.6),
                    ),
                    prefixIcon: Icon(Icons.search, color: AppColors.getAccentColor(context)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            // Feature Boxes Grid (2x2)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 24, // Increased spacing for text below
                childAspectRatio: 0.9, // Adjusted for text below
                children: _features.map((feature) {
                  return Column(
                    children: [
                      // Feature box without title
                      _buildFeatureBox(
                        context: context,
                        imagePath: feature.imagePath,
                        color: AppColors.getSurfaceColor(context),
                        route: feature.route,
                      ),
                      SizedBox(height: 8),
                      // Title outside the box
                      Text(
                        feature.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),

            // Latest News Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: AppColors.getSurfaceColor(context),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.getTextColor(context).withOpacity(0.2),
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
                      'Latest Info',
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: AppColors.getTextColor(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 225.0,
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
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                    backgroundColor: Colors.black.withOpacity(0.5),
                                  ),
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
            SizedBox(height: 30), // Add some space at the bottom
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }

  Widget _buildFeatureBox({
    required BuildContext context,
    required String imagePath,
    required Color color,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.getTextColor(context).withOpacity(0.15),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            height: 150,
            width: 100,
            fit: BoxFit.contain,
          ),
        ),
      ),
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

// New class for feature data
class FeatureData {
  final String title;
  final String imagePath;
  final String route;

  FeatureData({
    required this.title,
    required this.imagePath,
    required this.route,
  });
}