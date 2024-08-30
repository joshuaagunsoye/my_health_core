import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/pages/MyHealthTracker/mentalhealth_journal_page.dart';

class MentalHealthTrackerPage extends StatefulWidget {
  @override
  _MentalHealthTrackerPageState createState() =>
      _MentalHealthTrackerPageState();
}

class _MentalHealthTrackerPageState extends State<MentalHealthTrackerPage> {
  DateTime selectedDate =
      DateTime.now(); // Tracks the current selected date for logging.
  List<String> selectedSymptoms = []; // List of selected symptoms for the day.
  String? selectedFeeling; // Tracks the user's selected feeling.
  bool showAllData = false; // Tracks whether to show all data or not.
  final List<String> symptomOptions = [
    "Anxiety",
    "Depression",
    "Low mood",
    "Sadness",
    "Hopelessness",
    "Irritability",
    "Impulsivity",
    "Grandiose ideas",
    "Racing thoughts",
    "Can't concentrate",
    "Low self-esteem",
  ]; // Options for symptoms that can be selected.

  final List<String> feelingsOptions = [
    "Awful",
    "Bad",
    "Neutral",
    "Good",
    "Great"
  ]; // Options for feelings that can be selected.

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
              CommonWidgets.buildMainHeading('Mental Health Tracker'),
              SizedBox(height: 15),
              _dateSelector(),
              _logSymptomsSection(),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MentalHealthJournalPage()),
                  );
                },
                child: Text(
                  'Go to Mental Health Journal',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffron,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 15),
              _summarySection(),
              SizedBox(height: 15),
              _showAllDataButton(),
              SizedBox(height: 20),
              showAllData ? _allDataTable() : Container(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _dateSelector() {
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
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }

  Widget _logSymptomsSection() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log Your Symptoms',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: symptomOptions.map((symptom) {
              return ChoiceChip(
                label: Text(symptom),
                selected: selectedSymptoms.contains(symptom),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedSymptoms.add(symptom);
                    } else {
                      selectedSymptoms.remove(symptom);
                    }
                  });
                },
              );
            }).toList(),
          ),
          DropdownButton<String>(
            value: selectedFeeling,
            hint: Text("I'm feeling...", style: TextStyle(color: Colors.white)),
            onChanged: (value) {
              setState(() {
                selectedFeeling = value;
              });
            },
            items: feelingsOptions.map((feeling) {
              return DropdownMenuItem(
                value: feeling,
                child: Text(feeling, style: TextStyle(color: Colors.black)),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: _logMentalHealth,
            child: Text('Log Mental Health',
                style: TextStyle(color: Colors.black)),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.saffron),
          ),
        ],
      ),
    );
  }

  void _logMentalHealth() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null || selectedSymptoms.isEmpty || selectedFeeling == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select at least one symptom and feeling.'),
          backgroundColor: Colors.red));
      return;
    }

    var data = {
      'userId': user.uid,
      'date': selectedDate,
      'symptoms': selectedSymptoms,
      'feeling': selectedFeeling,
    };

    FirebaseFirestore.instance
        .collection('mentalHealthLogs')
        .add(data)
        .then((result) {
      setState(() {
        selectedSymptoms.clear();
        selectedFeeling = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Mental health logged successfully.'),
          backgroundColor: Colors.green));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to log mental health: $error'),
          backgroundColor: Colors.red));
    });
  }

  Widget _summarySection() {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mentalHealthLogs')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No mental health records found',
                  style: TextStyle(color: Colors.white)));
        }

        Map<String, int> feelingsCounts = {
          "Awful": 0,
          "Bad": 0,
          "Neutral": 0,
          "Good": 0,
          "Great": 0,
        };

        snapshot.data!.docs.forEach((doc) {
          String feeling = (doc.data() as Map<String, dynamic>)['feeling'];
          feelingsCounts[feeling] = (feelingsCounts[feeling] ?? 0) + 1;
        });

        List<BarChartGroupData> barGroups = feelingsCounts.entries.map((entry) {
          int index = feelingsOptions.indexOf(entry.key);
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: entry.value.toDouble(),
                color: Colors.blue,
              )
            ],
          );
        }).toList();

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
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    borderData: FlBorderData(
                      show: false,
                      border: Border(
                        left: BorderSide(color: Colors.white),
                        bottom: BorderSide(color: Colors.white),
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, interval: 1),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            String feeling = feelingsOptions[value.toInt()];
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                feeling,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
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
      child: Text(showAllData ? 'Hide Data' : 'Show All Data'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.saffron,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }

  Widget _allDataTable() {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mentalHealthLogs')
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
                  label:
                      Text('Feeling', style: TextStyle(color: Colors.white))),
              DataColumn(
                  label:
                      Text('Symptoms', style: TextStyle(color: Colors.white))),
            ],
            rows: snapshot.data!.docs.map((doc) {
              DateTime date = (doc['date'] as Timestamp).toDate();
              String feeling = doc['feeling'];
              List symptoms = doc['symptoms'];
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(color: Colors.white))),
                  DataCell(
                      Text(feeling, style: TextStyle(color: Colors.white))),
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
}

void main() => runApp(MaterialApp(home: MentalHealthTrackerPage()));
