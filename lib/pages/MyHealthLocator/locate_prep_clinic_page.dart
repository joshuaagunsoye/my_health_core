import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LocatePrepClinicPage extends StatefulWidget {
  @override
  _LocatePrepClinicPageState createState() => _LocatePrepClinicPageState();
}

class _LocatePrepClinicPageState extends State<LocatePrepClinicPage> {
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
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
    // Reverse map to find full names for the dropdown
    Map<String, String> fullProvinceNames =
        provinceAbbreviations.map((key, value) => MapEntry(value, key));

    return Scaffold(
      backgroundColor: AppColors.getSurfaceColor(context),
      appBar: CommonWidgets.buildAppBar('My Health Locator'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CommonWidgets.buildMainHeading('Locate a PrEP Clinic'),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: fullProvinceNames[
                    selectedProvince], // Set to full name based on abbreviation
                onChanged: (newValue) {
                  setState(() {
                    selectedProvince = provinceAbbreviations[
                        newValue!]; // Store abbreviation for Firestore query
                    print('Selected province full name: $newValue');
                    print('Selected province abbreviation: $selectedProvince');
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
                  labelStyle: TextStyle(color: AppColors.getTextColor(context)),
                ),
              ),
              SizedBox(height: 20),
              selectedProvince == null
                  ? Center(
                      child: Text("Please select a province.",
                          style: TextStyle(color: AppColors.getTextColor(context))))
                  : _auth.currentUser == null
                  ? Center(
                      child: Column(
                        children: [
                          Text("Please log in to view PrEP clinic locations.",
                              style: TextStyle(color: Colors.red)),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(context, '/signin'),
                            child: Text('Log In'),
                          ),
                        ],
                      ))
                  : StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('prep_clinics')
                          .where('province', isEqualTo: selectedProvince)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          print('Firebase Error: ${snapshot.error}');
                          print('Selected Province: $selectedProvince');
                          return Column(
                            children: [
                              Text("Firebase Error: ${snapshot.error}", 
                                style: TextStyle(color: Colors.red)),
                              SizedBox(height: 10),
                              Text("Selected Province: $selectedProvince",
                                style: TextStyle(color: AppColors.getTextColor(context))),
                            ],
                          );
                        }
                        if (snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                Text("No PrEP clinics found in this province.",
                                    style: TextStyle(color: AppColors.getTextColor(context))),
                                SizedBox(height: 10),
                                Text("Province code: $selectedProvince",
                                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                                SizedBox(height: 20),
                                Text("Data will be available soon!",
                                    style: TextStyle(color: Colors.blue, fontStyle: FontStyle.italic)),
                              ],
                            ),
                          );
                        }
                        return Column(
                          children: snapshot.data!.docs.map((doc) {
                            Map<String, dynamic> clinic =
                                doc.data() as Map<String, dynamic>;
                            return Card(
                              color: AppColors.getSurfaceColor(context),
                              child: ListTile(
                                title: InkWell(
                                  onTap: () => _launchURL(clinic['mapsUrl']),
                                  child: Text(clinic['name'],
                                      style: TextStyle(
                                          color: AppColors.getTextColor(context),
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${clinic['address']}',
                                        style: TextStyle(color: AppColors.getTextColor(context))),
                                    Text('${clinic['city']}',
                                        style: TextStyle(color: AppColors.getTextColor(context))),
                                    Text('${clinic['province']}',
                                        style: TextStyle(color: AppColors.getTextColor(context))),
                                    Text('${clinic['postalCode']}',
                                        style: TextStyle(color: AppColors.getTextColor(context))),
                                    Text('${clinic['phone']}',
                                        style: TextStyle(color: AppColors.getTextColor(context))),
                                    if (clinic['email'] != null &&
                                        clinic['email'].isNotEmpty)
                                      Text('${clinic['email']}',
                                          style:
                                              TextStyle(color: AppColors.getTextColor(context))),
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

void main() => runApp(MaterialApp(home: LocatePrepClinicPage()));
