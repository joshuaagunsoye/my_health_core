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

        // Process symptom data for the chart
        List<FlSpot> spots = [];
        List<DateTime> dates = [];
        snapshot.data!.docs.forEach((doc) {
          DateTime date = (doc['date'] as Timestamp).toDate();
          double severity = severities.indexOf(doc['severity']).toDouble() + 1;

          if (severity >= 1 && severity <= 3) {
            dates.add(date);
            spots.add(FlSpot(dates.length.toDouble() - 1, severity));
          }
        });

        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text('Symptom Severity Over Time',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 20),
              Container(
                height: 300,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: dates.length.toDouble() - 1,
                    minY: 1,
                    maxY: 3,
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: false,
                        barWidth: 0,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (FlSpot spot, double xPercentage, LineChartBarData bar, int index) {
                            // Get color based on severity value
                            Color dotColor;
                            switch (spot.y.toInt()) {
                              case 1:
                                dotColor = Colors.yellow;
                                break;
                              case 2:
                                dotColor = Colors.orange;
                                break;
                              case 3:
                                dotColor = Colors.red;
                                break;
                              default:
                                dotColor = Colors.grey;
                            }

                            return FlDotCirclePainter(
                              radius: 6,
                              color: dotColor,
                              strokeColor: Colors.white,
                              strokeWidth: 2,
                            );
                          },
                        ),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                '',
                                style: TextStyle(
                                  color: Colors.transparent, // Placeholder, no need for left labels
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < dates.length) {
                              return Text(
                                DateFormat('dd/MM').format(dates[value.toInt()]),
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              switch (value.toInt()) {
                                case 1:
                                  return Transform.translate(
                                    offset: Offset(10, -10), // Adjust X (horizontal) and Y (vertical) for 'Mild'
                                    child: Text(
                                      'Mild',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  );
                                case 2:
                                  return Transform.translate(
                                    offset: Offset(10, 0), // Adjust X and Y for 'Moderate'
                                    child: Text(
                                      'Moderate',
                                      softWrap: false,
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                      overflow: TextOverflow.visible,
                                    ),
                                  );
                                case 3:
                                  return Transform.translate(
                                    offset: Offset(10, 10), // Adjust X and Y for 'Severe'
                                    child: Text(
                                      'Severe',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  );
                                default:
                                  return Container();
                              }
                            },
                            reservedSize: 50, // Ensure enough space for legends
                          ),
                        ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white.withOpacity(0.5),
                          strokeWidth: 1,
                          dashArray: [5, 5], // Dashed horizontal lines
                        );
                      },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.white, width: 2),
                        bottom: BorderSide(color: Colors.white, width: 2),
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
