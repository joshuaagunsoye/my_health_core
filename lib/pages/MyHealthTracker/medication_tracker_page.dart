import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'dart:math' as math;

class MedicationTrackerPage extends StatefulWidget {
  @override
  _MedicationTrackerPageState createState() => _MedicationTrackerPageState();
}

class _MedicationTrackerPageState extends State<MedicationTrackerPage> {
  DateTime selectedDate = DateTime.now();
  String? selectedMedicationType;
  bool fullDosageTaken = true;
  String? selectedSideEffect;
  final TextEditingController customMedController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final List<String> medicationTypes = [
    'Select your medication',
    'ART - Single Fixed Dose',
    'ART - Combination Fixed Dose',
    'ART - Injectable',
    'PrEP',
    'PEP'
  ];
  final List<String> sideEffectOptions = [
    "None",
    "Rash",
    "Skin darkening",
    "Redness",
    "Blisters",
    "Muscle or joint ache",
    "Pain",
    "Swelling",
    "Weight gain",
    "Weight loss",
    "Dry mouth",
    "Nausea",
    "Vomiting",
    "Diarrhea",
    "Vivid dreams",
    "Anxiety",
    "Depression",
    "Insomnia",
    "Suicidal Ideation"
  ];
  String? filterMedicationType;
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
              CommonWidgets.buildMainHeading('Medication Tracker'),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(selectedDate),
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today,
                          size: 24.0, color: Colors.white),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              _logMedicationContainer(),
              SizedBox(height: 20),
              _summaryContainer(),
              SizedBox(height: 10),
              _medicationTypeFilterDropdown(),
              SizedBox(height: 10),
              _showAllDataButton(),
              if (showAllData) _allDataTable(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _logMedicationContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Log Your Medication',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          DropdownButtonFormField<String>(
            value: selectedMedicationType,
            decoration: InputDecoration(
              labelText: 'Select Medication Type',
              fillColor: AppColors.backgroundGreen,
              filled: true,
              labelStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedMedicationType = newValue!;
              });
            },
            items:
                medicationTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          DropdownButtonFormField<String>(
            value: selectedSideEffect,
            decoration: InputDecoration(
              labelText: 'Select Side Effect',
              fillColor: AppColors.backgroundGreen,
              filled: true,
              labelStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedSideEffect = newValue!;
              });
            },
            items:
                sideEffectOptions.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SwitchListTile(
            title: Text('Full Dosage Taken',
                style: TextStyle(color: Colors.white)),
            value: fullDosageTaken,
            onChanged: (bool value) {
              setState(() {
                fullDosageTaken = value;
              });
            },
            activeColor: Colors.white,
            activeTrackColor: AppColors.gold,
          ),
          TextField(
            controller: customMedController,
            decoration: InputDecoration(
                labelText: 'Custom Medication Name',
                labelStyle: TextStyle(color: Colors.white)),
            style: TextStyle(color: Colors.white),
          ),
          TextField(
            controller: dosageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: 'Custom Dosage (mg)',
                labelStyle: TextStyle(color: Colors.white)),
            style: TextStyle(color: Colors.white),
          ),
          ElevatedButton(
            onPressed: _logMedication,
            child: Text(
              'Log Medication',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.saffron),
          ),
        ],
      ),
    );
  }

  void _logMedication() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null ||
        selectedMedicationType == null ||
        selectedMedicationType == 'Select your medication') {
      _showSnackBar('Please login and select a medication type.');
      return;
    }

    String customName = customMedController.text.trim();
    String customDosage = dosageController.text.trim() + ' mg';

    Map<String, dynamic> data = {
      'userId': user.uid,
      'date': selectedDate,
      'type': selectedMedicationType,
      'fullDosageTaken': fullDosageTaken,
      'sideEffect': selectedSideEffect ?? 'None',
    };

    if (customName.isNotEmpty && customDosage.isNotEmpty) {
      data['customMedicationName'] = customName;
      data['customDosage'] = customDosage;
    }

    try {
      await FirebaseFirestore.instance.collection('medications').add(data);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Medication logged successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log medication: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _summaryContainer() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(
          child: Text('Please log in to view summary',
              style: TextStyle(color: Colors.white)));
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('medications')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text('No medications found',
                    style: TextStyle(color: Colors.white)));
          }

          Map<String, int> medicationCounts = {
            'ART - Single Fixed Dose': 0,
            'ART - Combination Fixed Dose': 0,
            'ART - Injectable': 0,
            'PrEP': 0,
            'PEP': 0,
          };

          snapshot.data!.docs.forEach((doc) {
            var data = doc.data() as Map<String, dynamic>;
            String type = data['type'] ?? 'Unknown';
            if (medicationCounts.containsKey(type)) {
              medicationCounts[type] = (medicationCounts[type] ?? 0) + 1;
            }
          });

          List<BarChartGroupData> barGroups = medicationCounts.entries
              .map((entry) => BarChartGroupData(
                    x: medicationTypes.indexOf(entry.key) - 1,
                    barRods: [
                      BarChartRodData(
                          toY: entry.value.toDouble(), color: Colors.blue)
                    ],
                  ))
              .toList();

          return Column(
            children: [
              Text('Summary',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              _buildBarChart(barGroups),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBarChart(List<BarChartGroupData> barGroups) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: barGroups,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  );
                },
                interval: 1,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 &&
                      value.toInt() < medicationTypes.length - 1) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Transform.rotate(
                        angle: -math.pi / 2,
                        child: Text(
                          medicationTypes[value.toInt() + 1],
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }

  Widget _medicationTypeFilterDropdown() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: filterMedicationType,
        decoration: InputDecoration(
          labelText: 'Filter by Medication Type',
          fillColor: AppColors.backgroundGreen,
          filled: true,
          labelStyle: TextStyle(color: Colors.white),
        ),
        onChanged: (String? newValue) {
          setState(() {
            filterMedicationType = newValue;
            showAllData =
                true; // Show the data table when a new filter is selected
          });
        },
        items: medicationTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _showAllDataButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          showAllData = !showAllData;
        });
      },
      child: Text(
        showAllData ? 'Hide Data' : 'Show All Data',
        style: TextStyle(color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.saffron,
      ),
    );
  }

  Widget _allDataTable() {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medications')
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

        List<Map<String, dynamic>> logs = snapshot.data!.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;

          return {
            'date': (data.containsKey('date') && data['date'] is Timestamp)
                ? (data['date'] as Timestamp).toDate()
                : DateTime.now(),
            'type': (data.containsKey('type') && data['type'] is String)
                ? data['type']
                : 'Unknown',
            'fullDosageTaken': (data.containsKey('fullDosageTaken') &&
                    data['fullDosageTaken'] is bool)
                ? data['fullDosageTaken']
                : false,
            'sideEffect':
                (data.containsKey('sideEffect') && data['sideEffect'] is String)
                    ? data['sideEffect']
                    : 'None',
            'customMedicationName': (data.containsKey('customMedicationName') &&
                    data['customMedicationName'] is String)
                ? data['customMedicationName']
                : '',
            'customDosage': (data.containsKey('customDosage') &&
                    data['customDosage'] is String)
                ? data['customDosage']
                : '',
          };
        }).toList();

        if (filterMedicationType != null) {
          logs =
              logs.where((log) => log['type'] == filterMedicationType).toList();
        }

        if (logs.isEmpty) {
          return Center(
            child: Text('No data available for selected medication type.',
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
                  label: Text('Medication Type',
                      style: TextStyle(color: Colors.white))),
              DataColumn(
                  label: Text('Full Dosage Taken',
                      style: TextStyle(color: Colors.white))),
              DataColumn(
                  label: Text('Side Effect',
                      style: TextStyle(color: Colors.white))),
              DataColumn(
                  label: Text('Custom Medication Name',
                      style: TextStyle(color: Colors.white))),
              DataColumn(
                  label: Text('Custom Dosage',
                      style: TextStyle(color: Colors.white))),
            ],
            rows: logs.map((log) {
              DateTime date = log['date'];
              String type = log['type'];
              String fullDosage = log['fullDosageTaken'] ? 'Yes' : 'No';
              String sideEffect = log['sideEffect'];
              String customMedName = log['customMedicationName'];
              String customDosage = log['customDosage'];
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(color: Colors.white))),
                  DataCell(Text(type, style: TextStyle(color: Colors.white))),
                  DataCell(
                      Text(fullDosage, style: TextStyle(color: Colors.white))),
                  DataCell(
                      Text(sideEffect, style: TextStyle(color: Colors.white))),
                  DataCell(Text(customMedName,
                      style: TextStyle(color: Colors.white))),
                  DataCell(Text(customDosage,
                      style: TextStyle(color: Colors.white))),
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
        backgroundColor: Colors.green,
      ),
    );
  }
}
