import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LocateHIVTestPage extends StatefulWidget {
  @override
  _LocateHIVTestPageState createState() => _LocateHIVTestPageState();
}

class _LocateHIVTestPageState extends State<LocateHIVTestPage> {
  String? selectedProvince;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore collection name. Adjust here if the collection is named
  // differently (e.g. 'hiv_text', 'hivTest', 'hiv_tests').
  static const String _collection = 'hiv_test';

  final Map<String, String> provinceAbbreviations = {
    'Alberta': 'AB',
    'British Columbia': 'BC',
    'Manitoba': 'MB',
    'Newfoundland & Labrador': 'NL',
    'New Brunswick': 'NB',
    'Nova Scotia': 'NS',
    'Quebec': 'QC',
    'Saskatchewan': 'SK',
    'Ontario': 'ON',
  };

  String _generateMapsUrl({
    required String address,
    required String city,
    required String province,
    required String postalCode,
  }) {
    final fullAddress = '$address, $city, $province $postalCode';
    final encodedQuery = Uri.encodeComponent(fullAddress);
    return 'https://www.google.com/maps/search/?api=1&query=$encodedQuery';
  }

  Future<void> _launchURL(String url) async {
    try {
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        throw FormatException('Invalid URL scheme');
      }

      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } else {
        await launchUrl(
          uri,
          mode: LaunchMode.inAppWebView,
        );
      }
    } on FormatException catch (e) {
      debugPrint('Invalid URL format: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid map link format'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Map launch error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open map'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> fullProvinceNames =
        provinceAbbreviations.map((key, value) => MapEntry(value, key));

    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: CommonWidgets.buildAppBar('My Health Locator'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CommonWidgets.buildMainHeading('Locate an HIV Test'),
              SizedBox(height: 16),
              CommonWidgets.buildCenterText(
                'Find HIV testing sites near you. Select your province to '
                'see clinics, community organizations, and walk-in testing '
                'locations registered in our directory.',
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: fullProvinceNames[selectedProvince],
                onChanged: (newValue) {
                  setState(() {
                    selectedProvince = provinceAbbreviations[newValue!];
                  });
                },
                items: provinceAbbreviations.keys
                    .map<DropdownMenuItem<String>>((String province) {
                  return DropdownMenuItem<String>(
                    value: province,
                    child: Text(province),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Select Province',
                  fillColor: AppColors.mintGreen,
                  filled: true,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              if (selectedProvince == null)
                Center(
                  child: Text(
                    'Please select a province.',
                    style:
                        TextStyle(color: AppColors.getTextColor(context)),
                  ),
                )
              else if (_auth.currentUser == null)
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Please log in to view HIV testing locations.',
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signin'),
                        child: Text('Log In'),
                      ),
                    ],
                  ),
                )
              else
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection(_collection)
                      .where('province', isEqualTo: selectedProvince)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      debugPrint('Firebase Error: ${snapshot.error}');
                      debugPrint('Selected Province: $selectedProvince');
                      return Column(
                        children: [
                          Text(
                            'Firebase Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Selected Province: $selectedProvince',
                            style: TextStyle(
                                color: AppColors.getTextColor(context)),
                          ),
                        ],
                      );
                    }
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                              'No HIV testing sites found in this province.',
                              style: TextStyle(
                                  color: AppColors.getTextColor(context)),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Province code: $selectedProvince',
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }
                    return Column(
                      children: docs.map((doc) {
                        final site = doc.data() as Map<String, dynamic>;

                        // Prefer an explicit mapsUrl when present;
                        // otherwise build one from the address fields.
                        final String mapsUrl = (site['mapsUrl'] is String &&
                                (site['mapsUrl'] as String).isNotEmpty)
                            ? site['mapsUrl'] as String
                            : _generateMapsUrl(
                                address: '${site['address'] ?? ''}',
                                city: '${site['city'] ?? ''}',
                                province: '${site['province'] ?? ''}',
                                postalCode: '${site['postalCode'] ?? ''}',
                              );

                        return Card(
                          color: AppColors.getSurfaceColor(context),
                          child: ListTile(
                            title: InkWell(
                              onTap: () => _launchURL(mapsUrl),
                              child: Text(
                                '${site['name'] ?? 'Unnamed site'}',
                                style: TextStyle(
                                  color: AppColors.getTextColor(context),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (site['address'] != null)
                                  Text('${site['address']}',
                                      style: TextStyle(
                                          color: AppColors.getTextColor(
                                              context))),
                                if (site['city'] != null)
                                  Text('${site['city']}',
                                      style: TextStyle(
                                          color: AppColors.getTextColor(
                                              context))),
                                if (site['province'] != null)
                                  Text('${site['province']}',
                                      style: TextStyle(
                                          color: AppColors.getTextColor(
                                              context))),
                                if (site['postalCode'] != null)
                                  Text('${site['postalCode']}',
                                      style: TextStyle(
                                          color: AppColors.getTextColor(
                                              context))),
                                if (site['phone'] != null)
                                  Text('${site['phone']}',
                                      style: TextStyle(
                                          color: AppColors.getTextColor(
                                              context))),
                                if (site['email'] != null &&
                                    '${site['email']}'.isNotEmpty)
                                  Text('${site['email']}',
                                      style: TextStyle(
                                          color: AppColors.getTextColor(
                                              context))),
                                if (site['hours'] != null &&
                                    '${site['hours']}'.isNotEmpty)
                                  Text('Hours: ${site['hours']}',
                                      style: TextStyle(
                                          color: AppColors.getTextColor(
                                              context))),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }
}
