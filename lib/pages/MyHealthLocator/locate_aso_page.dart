import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LocateASOPage extends StatefulWidget {
  @override
  _LocateASOPageState createState() => _LocateASOPageState();
}

class _LocateASOPageState extends State<LocateASOPage> {
  String? selectedProvince;
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<void> _launchURL(String url) async {
    try {
      // Add URL validation
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid map link format'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Map launch error: $e');
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
    // Reverse map to find full names for the dropdowny
    Map<String, String> fullProvinceNames =
        provinceAbbreviations.map((key, value) => MapEntry(value, key));

    return Scaffold(
      appBar: CommonWidgets.buildAppBar('My Health Locator'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CommonWidgets.buildMainHeading('Locate an ASO'),
              DropdownButtonFormField<String>(
                value: fullProvinceNames[
                    selectedProvince], // Set to full name based on abbreviation
                onChanged: (newValue) {
                  setState(() {
                    selectedProvince = provinceAbbreviations[
                        newValue!]; // Store abbreviation for Firestore query
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
                  fillColor: AppColors.backgroundGreen,
                  filled: true,
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              selectedProvince == null
                  ? Center(
                      child: Text("Please select a province.",
                          style: TextStyle(color: Colors.white)))
                  : StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('aso')
                          .where('province', isEqualTo: selectedProvince)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return Text("No ASOs found in this province.",
                              style: TextStyle(color: Colors.white));
                        }
                        return Column(
                          children: snapshot.data!.docs.map((doc) {
                            Map<String, dynamic> aso =
                                doc.data() as Map<String, dynamic>;
                            return Card(
                              color: AppColors.backgroundGreen,
                              child: ListTile(
                                title: InkWell(
                                  onTap: () => _launchURL(aso['mapsUrl']),
                                  child: Text(aso['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${aso['address']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text('${aso['city']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text('${aso['province']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text('${aso['postalCode']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text('${aso['phone']}',
                                        style: TextStyle(color: Colors.white)),
                                    if (aso['email'] != null &&
                                        aso['email'].isNotEmpty)
                                      Text('${aso['email']}',
                                          style:
                                              TextStyle(color: Colors.white)),
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
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }
}

void main() => runApp(MaterialApp(home: LocateASOPage()));
