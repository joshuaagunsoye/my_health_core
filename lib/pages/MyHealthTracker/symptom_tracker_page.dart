import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';

class SymptomTrackerPage extends StatefulWidget {
  @override
  _SymptomTrackerPageState createState() => _SymptomTrackerPageState();
}

class _SymptomTrackerPageState extends State<SymptomTrackerPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? selectedSymptomType;
  final List<String> selectedSymptoms = [];
  String? selectedSeverity;
  String? selectedGraphSymptomType;
  bool showAllData = false;
  final List<String> severities = ['Mild', 'Moderate', 'Severe'];
  final Map<String, List<String>> symptomDetails = {
    'Cognitive': [
      'Brain fog',
      'Memory loss',
      'Poor concentration',
      'Change in mood'
    ],
    'Respiratory': [
      'Dry cough',
      'Wet cough',
      'Shortness of breath',
      'Sneezing',
      'Stuffy nose',
      'Drainage down back of throat'
    ],
    'Fever': ['Chills', 'Sweating', 'Confusion'],
    'Aches/Pains': [
      'Headache',
      'Body aches',
      'Sore throat',
      'Ear pain',
      'Leg pain',
      'Back pain',
      'Joint pain'
    ],
    'Ear/Nose/Throat': [
      'Stuffy nose',
      'Runny nose',
      'Loss of smell/taste',
      'Drainage down back of throat',
      'Ear pain',
      'Blocked ears'
    ],
    'Eyes': ['Itchy eyes', 'Discharge from eyes', 'Burning eyes'],
    'Digestive': [
      'Stomach pain',
      'Diarrhea',
      'Nausea',
      'Vomiting',
      'Constipation',
      'Bloody stool'
    ],
    'Skin': ['Rash', 'Eczema', 'Hives', 'Acne'],
  };

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
              CommonWidgets.buildMainHeading('Track Your Symptoms'),
              _dateSelectionSection(),
              SizedBox(height: 10),
              _timeSelectionSection(),
              _symptomTypeDropdown(),
              SizedBox(height: 10),
              if (selectedSymptomType != null) _symptomChecklist(),
              SizedBox(height: 10),
              _severityDropdown(),
              SizedBox(height: 10),
              _logSymptomButton(),
              SizedBox(height: 10),
              _graphSymptomTypeDropdown(),
              SizedBox(height: 10),
              _symptomSummary(),
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

  Widget _dateSelectionSection() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('yyyy-MM-dd').format(selectedDate),
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today, size: 24.0, color: Colors.white),
            onPressed: () => _selectDate(),
          ),
        ],
      ),
    );
  }

  Widget _timeSelectionSection() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('HH:mm').format(
              DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              ),
            ),
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          IconButton(
            icon: Icon(Icons.access_time, size: 24.0, color: Colors.white),
            onPressed: () => _selectTime(),
          ),
        ],
      ),
    );
  }

  Widget _symptomTypeDropdown() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedSymptomType,
        decoration: InputDecoration(
          labelText: 'Select Symptom Type',
          fillColor: AppColors.backgroundGreen,
          filled: true,
          labelStyle: TextStyle(color: Colors.white),
        ),
        onChanged: (value) {
          setState(() {
            selectedSymptomType = value;
            selectedSymptoms.clear();
          });
        },
        items:
            symptomDetails.keys.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _graphSymptomTypeDropdown() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedGraphSymptomType,
        decoration: InputDecoration(
          labelText: 'Select Graph Symptom Type',
          fillColor: AppColors.backgroundGreen,
          filled: true,
          labelStyle: TextStyle(color: Colors.white),
        ),
        onChanged: (value) {
          setState(() {
            selectedGraphSymptomType = value;
            showAllData =
                false; // Hide the data table when a new symptom type is selected
          });
        },
        items:
            symptomDetails.keys.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _symptomChecklist() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Specific Symptoms',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          ...symptomDetails[selectedSymptomType]!.map((symptom) {
            return CheckboxListTile(
              value: selectedSymptoms.contains(symptom),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedSymptoms.add(symptom);
                  } else {
                    selectedSymptoms.remove(symptom);
                  }
                });
              },
              title: Text(symptom, style: TextStyle(color: Colors.white)),
              activeColor: AppColors.beer,
              checkColor: Colors.white,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _severityDropdown() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedSeverity,
        decoration: InputDecoration(
          labelText: 'Select Severity',
          fillColor: AppColors.backgroundGreen,
          filled: true,
          labelStyle: TextStyle(color: Colors.white),
        ),
        onChanged: (value) {
          setState(() {
            selectedSeverity = value;
          });
        },
        items: severities.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _logSymptomButton() {
    return ElevatedButton(
      onPressed: _logSymptom,
      child: Text(
        'Log Symptom',
        style: TextStyle(color: Colors.black),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.saffron,
      ),
    );
  }

  void _selectDate() async {
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

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _logSymptom() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user logged in. Please login to log symptoms.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedSymptomType == null ||
        selectedSeverity == null ||
        selectedSymptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please complete all fields before logging.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('symptoms').add({
        'userId': user.uid,
        'date': selectedDate,
        'time': selectedTime.format(context),
        'symptomType': selectedSymptomType,
        'specificSymptoms': selectedSymptoms,
        'severity': selectedSeverity,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Symptom logged successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log symptom: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _symptomSummary() {
    if (selectedGraphSymptomType == null) {
      return Center(
        child: Text('Please select a symptom type to view the graph.',
            style: TextStyle(color: Colors.white)),
      );
    }

    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('symptoms')
          .where('userId', isEqualTo: user?.uid)
          .where('symptomType', isEqualTo: selectedGraphSymptomType)
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No symptoms found',
                style: TextStyle(color: Colors.white)),
          );
        }

        Map<DateTime, Map<double, int>> symptomSeverities = {};
        snapshot.data!.docs.forEach((doc) {
          DateTime date = (doc['date'] as Timestamp).toDate();
          date = DateTime(date.year, date.month, date.day);
          double severity = severities.indexOf(doc['severity']).toDouble() + 1;

          if (!symptomSeverities.containsKey(date)) {
            symptomSeverities[date] = {};
          }
          if (!symptomSeverities[date]!.containsKey(severity)) {
            symptomSeverities[date]![severity] = 0;
          }
          symptomSeverities[date]![severity] =
              symptomSeverities[date]![severity]! + 1;
        });

        List<DateTime> dates = symptomSeverities.keys.toList()..sort();
        List<LineChartBarData> barData = [];
        List<FlSpot> spots = [];

        for (int i = 0; i < dates.length; i++) {
          symptomSeverities[dates[i]]!.forEach((severity, count) {
            if (count == 1) {
              spots.add(FlSpot(i.toDouble(), severity));
            } else {
              barData.add(LineChartBarData(
                spots: [
                  FlSpot(i.toDouble(), severity),
                  FlSpot(i.toDouble() + (count - 1) * 0.1, severity),
                ],
                isCurved: false,
                barWidth: 3,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(show: false),
                color: Colors.blue,
              ));
            }
          });
        }

        barData.add(LineChartBarData(
          spots: spots,
          isCurved: false,
          barWidth: 0,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
          color: Colors.blue,
        ));

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
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX:
                        dates.isNotEmpty ? (dates.length - 1).toDouble() : 1.0,
                    minY: 0.5,
                    maxY: severities.length.toDouble() + 0.5,
                    lineBarsData: barData,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < dates.length) {
                              return Text(
                                DateFormat('MMM dd')
                                    .format(dates[value.toInt()]),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              );
                            }
                            return Container();
                          },
                          interval: 1,
                        ),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.transparent, width: 1),
                        bottom: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
          .collection('symptoms')
          .where('userId', isEqualTo: user?.uid)
          .where('symptomType', isEqualTo: selectedGraphSymptomType)
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
                  label:
                      Text('Severity', style: TextStyle(color: Colors.white))),
              DataColumn(
                  label:
                      Text('Symptoms', style: TextStyle(color: Colors.white))),
            ],
            rows: snapshot.data!.docs.map((doc) {
              DateTime date = (doc['date'] as Timestamp).toDate();
              String severity = doc['severity'];
              List symptoms = doc['specificSymptoms'];
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(color: Colors.white))),
                  DataCell(
                      Text(severity, style: TextStyle(color: Colors.white))),
                  DataCell(
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 300),
                      child: Text(
                        symptoms.join(', '),
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
}

void main() => runApp(MaterialApp(home: SymptomTrackerPage()));
