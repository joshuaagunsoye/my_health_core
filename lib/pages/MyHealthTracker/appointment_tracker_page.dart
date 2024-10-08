import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';

class AppointmentTrackerPage extends StatefulWidget {
  @override
  _AppointmentTrackerPageState createState() => _AppointmentTrackerPageState();
}

class _AppointmentTrackerPageState extends State<AppointmentTrackerPage> {
  DateTime selectedDate = DateTime.now();
  String? selectedAppointmentType;
  final List<String> appointmentTypes = [
    'New appointment',
    'Follow up appointment'
  ];
  final TextEditingController notesController = TextEditingController();
  String? selectedServiceProvider;
  final List<String> serviceProviders = [
    'Physician',
    'Pharmacist',
    'Social Worker',
    'Registered Dietician'
  ];
  String? selectedServiceProviderForDetails;
  bool showAllData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('My Health Tracker'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CommonWidgets.buildMainHeading('Track Your Appointments'),
              Center(
                child: IconButton(
                  icon: Icon(Icons.calendar_today, size: 40.0),
                  onPressed: () => _selectDate(context),
                ),
              ),
              Text(
                DateFormat('yyyy-MM-dd').format(selectedDate),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              SizedBox(height: 10),
              _logAppointmentContainer(),
              SizedBox(height: 5),
              _addNotesContainer(),
              SizedBox(height: 5),
              _serviceProviderSelection(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addAppointment,
                child: Text('Add Appointment',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron),
              ),
              SizedBox(height: 10),
              _summaryContainer(),
              SizedBox(height: 10),
              _serviceProviderFilter(),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showAllData = !showAllData;
                  });
                },
                child: Text(showAllData ? 'Hide All Data' : 'Show All Data',
                    style: TextStyle(color: Colors.black)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron),
              ),
              if (showAllData) _allDataContainer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _serviceProviderSelection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selectedServiceProvider,
        hint: Text('Select Service Provider',
            style: TextStyle(color: Colors.white)),
        onChanged: (String? newValue) {
          setState(() {
            selectedServiceProvider = newValue;
            selectedServiceProviderForDetails = newValue;
          });
        },
        items: serviceProviders.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _addAppointment() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user logged in');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No user logged in. Please login to add appointments.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (selectedAppointmentType == null || selectedServiceProvider == null) {
      _showSnackBar(
          'Please select an appointment type and a service provider.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'userId': user.uid,
        'date': selectedDate,
        'type': selectedAppointmentType,
        'serviceProvider': selectedServiceProvider,
        'notes': notesController.text.trim(),
      });

      setState(() {
        selectedAppointmentType = null;
        selectedServiceProvider = null;
        notesController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment added successfully.'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      _showSnackBar('Failed to add appointment: $e');
    }
  }

  Widget _logAppointmentContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Log an Appointment',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          DropdownButton<String>(
            value: selectedAppointmentType,
            hint: Text('Select Appointment Type',
                style: TextStyle(color: Colors.white)),
            onChanged: (String? newValue) {
              setState(() {
                selectedAppointmentType = newValue;
              });
            },
            items:
            appointmentTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.black)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _addNotesContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: notesController,
        decoration: InputDecoration(
            labelText: 'Appointment Notes',
            labelStyle: TextStyle(color: Colors.white)),
        style: TextStyle(color: Colors.white),
        maxLines: 3,
      ),
    );
  }

  Widget _summaryContainer() {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No appointments found',
                  style: TextStyle(color: Colors.white)));
        }

        Map<String, int> serviceProviderCounts = {
          'Physician': 0,
          'Pharmacist': 0,
          'Social Worker': 0,
          'Registered Dietician': 0,
        };

        snapshot.data!.docs.forEach((doc) {
          String serviceProvider = doc['serviceProvider'];
          if (serviceProviderCounts.containsKey(serviceProvider)) {
            serviceProviderCounts[serviceProvider] =
                (serviceProviderCounts[serviceProvider] ?? 0) + 1;
          }
        });

        // Dynamic colors based on the number of service providers
        List<Color> barColors = [
          Colors.blue,
          Colors.red,
          Colors.green,
          Colors.orange
        ];

        // Ensure the number of colors matches the number of data entries
        if (serviceProviderCounts.entries.length > barColors.length) {
          barColors.addAll(
              List.generate(serviceProviderCounts.entries.length - barColors.length,
                      (index) => Colors.grey)); // Adding fallback color
        }

        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text('Summary',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: SfCircularChart(
                  legend: Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                  ),
                  series: <CircularSeries>[
                    RadialBarSeries<MapEntry<String, int>, String>(
                      dataSource: serviceProviderCounts.entries.toList(),
                      xValueMapper: (MapEntry<String, int> data, _) => data.key,
                      yValueMapper: (MapEntry<String, int> data, _) => data.value.toDouble(),
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                      cornerStyle: CornerStyle.bothCurve, // Rounded bars
                      pointColorMapper: (MapEntry<String, int> data, index) => barColors[index % barColors.length], // Safeguard for out-of-bound errors
                      maximumValue: serviceProviderCounts.values.reduce((a, b) => a > b ? a : b).toDouble(),
                      radius: '100%', // Control the radius of the radial bars
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _serviceProviderFilter() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selectedServiceProviderForDetails,
        hint: Text('Filter by Service Provider',
            style: TextStyle(color: Colors.white)),
        onChanged: (String? newValue) {
          setState(() {
            selectedServiceProviderForDetails = newValue;
            showAllData = true;
          });
        },
        items: serviceProviders.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.black)),
          );
        }).toList(),
      ),
    );
  }

  Widget _allDataContainer() {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: selectedServiceProviderForDetails != null
          ? FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user?.uid)
          .where('serviceProvider',
          isEqualTo: selectedServiceProviderForDetails)
          .orderBy('date')
          .snapshots()
          : FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No data available',
                style: TextStyle(color: Colors.white)),
          );
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 50,
            columns: [
              DataColumn(
                  label: Text('Date', style: TextStyle(color: Colors.white))),
              DataColumn(
                  label: Text('Type', style: TextStyle(color: Colors.white))),
              DataColumn(
                  label: Text('Service Provider',
                      style: TextStyle(color: Colors.white))),
              DataColumn(
                  label: Text('Notes', style: TextStyle(color: Colors.white))),
            ],
            rows: snapshot.data!.docs.map((doc) {
              DateTime date = (doc['date'] as Timestamp).toDate();
              String type = doc['type'];
              String serviceProvider = doc['serviceProvider'];
              String notes = doc['notes'];
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(color: Colors.white))),
                  DataCell(Text(type, style: TextStyle(color: Colors.white))),
                  DataCell(Text(serviceProvider,
                      style: TextStyle(color: Colors.white))),
                  DataCell(
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Text(
                        notes,
                        style: TextStyle(color: Colors.white),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: AppointmentTrackerPage()));

