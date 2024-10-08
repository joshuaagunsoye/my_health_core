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

        List<FlSpot> feelingTrends = [];
        List<Color> dotColors = []; // To store the color for each dot
        int index = 0;

        snapshot.data!.docs.forEach((doc) {
          String feeling = (doc.data() as Map<String, dynamic>)['feeling'];
          DateTime date = (doc.data() as Map<String, dynamic>)['date'].toDate();

          // Prepare data for line chart
          double feelingValue = feelingsOptions.indexOf(feeling).toDouble();
          feelingTrends.add(FlSpot(index.toDouble(), feelingValue.toDouble()));

          // Assign colors based on feeling
          switch (feeling) {
            case 'Awful':
              dotColors.add(Colors.red);
              break;
            case 'Bad':
              dotColors.add(Colors.orange);
              break;
            case 'Neutral':
              dotColors.add(Colors.yellow);
              break;
            case 'Good':
              dotColors.add(Colors.lightGreen);
              break;
            case 'Great':
              dotColors.add(Colors.green);
              break;
            default:
              dotColors.add(Colors.grey);
          }

          index++;
        });

        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text('Summary', style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              Container(
                height: 270, // Adjust the height of the chart container if necessary
                child: LineChart(
                  LineChartData(
                    minY: 0,  // Set minimum value for y-axis
                    maxY: 4.5,  // Slightly increase maxY to avoid overlapping
                    minX: 0,  // Set minimum value for x-axis
                    maxX: (snapshot.data!.docs.length - 1).toDouble(),  // Set max value for x-axis based on data points
                    gridData: FlGridData(
                      show: false, // Hide the grid lines
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            // Custom labels for the y-axis (Feelings)
                            switch (value.toInt()) {
                              case 0:
                                return Text('Awful', style: TextStyle(color: Colors.white, fontSize: 8));
                              case 1:
                                return Text('Bad', style: TextStyle(color: Colors.white, fontSize: 8));
                              case 2:
                                return Text('Neutral', style: TextStyle(color: Colors.white, fontSize: 8));
                              case 3:
                                return Text('Good', style: TextStyle(color: Colors.white, fontSize: 8));
                              case 4:
                                return Text('Great', style: TextStyle(color: Colors.white, fontSize: 8));
                              default:
                                return Text('', style: TextStyle(color: Colors.white));
                            }
                          },
                          interval: 1,
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            // Custom labels for the x-axis (Dates)
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                DateFormat('MMM d').format(snapshot.data!.docs[value.toInt()]['date'].toDate()),
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide the top titles
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide the right titles
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: feelingTrends,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: dotColors[index], // Set the color of the dot based on the feeling
                              strokeWidth: 1,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
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