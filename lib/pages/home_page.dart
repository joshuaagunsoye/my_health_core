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
      title: 'Understanding drivers of HIV in African, Caribbean and Black communities',
      imageUrl: 'assets/images/news1.png',
      hyperlink: 'https://www.catie.ca/understanding-drivers-of-hiv-in-african-caribbean-and-black-communities',
    ),
    CarouselItemData(
      title: 'Yeztugo Is Now the First and Only FDA-Approved HIV PrEP Option Offering 6 Months of Protection',
      imageUrl: 'assets/images/news2.png',
      hyperlink: 'https://www.gilead.com/news/news-details/2025/yeztugo-lenacapavir-is-now-the-first-and-only-fda-approved-hiv-prevention-option-offering-6-months-of-protection',
    ),
    CarouselItemData(
      title: 'Advocates against HIV criminalization decry Carney silence on reform Trudeau promised',
      imageUrl: 'assets/images/news3.png',
      hyperlink: 'https://www.thecanadianpressnews.ca/health/advocates-against-hiv-criminalization-decry-carney-silence-on-reform-trudeau-promised/article_2159ecd8-1560-5628-bd04-91b4f07c3a82.html',
    ),
    CarouselItemData(
      title: 'AIDS Committee of Toronto to close in 2026',
      imageUrl: 'assets/images/news4.png',
      hyperlink: 'https://www.actoronto.org/',
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
      title: 'MyHealthTracker',
      imagePath: 'assets/images/tracker.png',
      route: '/my_health_tracker',
    ),
    FeatureData(
      title: 'MyHealthLocator',
      imagePath: 'assets/images/locator.png',
      route: '/my_health_locator',
    ),
    FeatureData(
      title: 'MyHealthConnect',
      imagePath: 'assets/images/connect2.png',
      route: '/my_health_connect',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    // Guard against the widget being disposed between the await and setState.
    if (!mounted) return;
    if (doc.exists) {
      setState(() {
        _username = doc['username'] ?? "User";
      });
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
                Image.asset(
                  'assets/images/waving.png',
                  width: 24,
                  height: 24,
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
              backgroundColor: Colors.transparent,
              radius: 20,
              backgroundImage: AssetImage('assets/avatars/avatar1.png'),
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
                    hintText: 'Search...',
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
                        color: AppColors.getCardColor(context),
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

            // Latest Info Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/info.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Latest Info',
                        style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 120.0,
                    child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        final item = _carouselItems[index];
                        return InkWell(
                          onTap: () => _launchURL(item.hyperlink),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.0),
                            decoration: BoxDecoration(
                              color: AppColors.getSurfaceColor(context),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.getTextColor(context).withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  // Background Image
                                  Positioned.fill(
                                    child: Opacity(
                                      opacity: 0.15,
                                      child: Image.asset(
                                        item.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  // Content
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          item.title,
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.getTextColor(context),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Nature | December 13, 2024',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: AppColors.getTextColor(context).withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: _carouselItems.length,
                      autoplay: true,
                      pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(
                          color: AppColors.getTextColor(context).withOpacity(0.3),
                          activeColor: AppColors.getTextColor(context),
                          size: 8.0,
                          activeSize: 8.0,
                        ),
                      ),
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