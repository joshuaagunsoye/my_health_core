import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class LocateCommunityBasedOrganisationPage extends StatefulWidget {
  @override
  _LocateCommunityBasedOrganisationPageState createState() =>
      _LocateCommunityBasedOrganisationPageState();
}

class _LocateCommunityBasedOrganisationPageState
    extends State<LocateCommunityBasedOrganisationPage> {
  String? selectedProvince;
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
    final encodedUrl = Uri.encodeFull(url);
    print('Attempting to launch URL: $encodedUrl'); // Debug log

    if (await canLaunch(encodedUrl)) {
      await launch(encodedUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $encodedUrl')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reverse map to find full names for the dropdown
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
              CommonWidgets.buildMainHeading(
                  'Locate a Community Based Organisation'),
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
                          .collection('cbo')
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
                          return Text(
                              "No Community Based Organisations found in this province.",
                              style: TextStyle(color: Colors.white));
                        }
                        return Column(
                          children: snapshot.data!.docs.map((doc) {
                            Map<String, dynamic> cbo =
                                doc.data() as Map<String, dynamic>;
                            return Card(
                              color: AppColors.backgroundGreen,
                              child: ListTile(
                                title: InkWell(
                                  onTap: () {
                                    // Check and launch URL
                                    if (cbo.containsKey('mapsUrl')) {
                                      _launchURL(cbo['mapsUrl']);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text('No valid URL found')),
                                      );
                                    }
                                  },
                                  child: Text(cbo['name'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${cbo['address']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text('${cbo['city']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text('${cbo['province']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text('${cbo['postalCode']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text('${cbo['phone']}',
                                        style: TextStyle(color: Colors.white)),
                                    if (cbo['email'] != null &&
                                        cbo['email'].isNotEmpty)
                                      Text('${cbo['email']}',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement save functionality here
        },
        backgroundColor: AppColors.beer,
        child: Icon(Icons.save, color: AppColors.white),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }
}

void main() =>
    runApp(MaterialApp(home: LocateCommunityBasedOrganisationPage()));
