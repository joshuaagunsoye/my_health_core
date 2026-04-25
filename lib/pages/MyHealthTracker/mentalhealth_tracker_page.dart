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
      backgroundColor: AppColors.getBackgroundColor(context),
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
              SizedBox(height: 20.0),
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
                      color: AppColors.getTextColor(context), fontWeight: FontWeight.bold),
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
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
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
              style: TextStyle(fontSize: 20, color: AppColors.getTextColor(context))),
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
            hint: Text("I'm feeling...", style: TextStyle(color: AppColors.getTextColor(context))),
            onChanged: (value) {
              setState(() {
                selectedFeeling = value;
              });
            },
            items: feelingsOptions.map((feeling) {
              return DropdownMenuItem(
                value: feeling,
                child: Text(feeling, style: TextStyle(color: AppColors.getTextColor(context))),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: _logMentalHealth,
            child: Text('Log Mental Health',
                style: TextStyle(color: AppColors.getTextColor(context))),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.white),
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
      if (!mounted) return;
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
                style: TextStyle(color: Colors.white)),
          );
        }

        List<FlSpot> spots = [];
        List<Color> dotColors = [];
        int index = 0;

        snapshot.data!.docs.forEach((doc) {
          String feeling = doc['feeling'];
          DateTime date = (doc['date'] as Timestamp).toDate();

          double feelingValue = feelingsOptions.indexOf(feeling).toDouble();
          spots.add(FlSpot(index.toDouble(), feelingValue));

          dotColors.add(_getDotColor(feeling));
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
              Text('Summary',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: (snapshot.data!.docs.length - 1).toDouble(),
                    minY: 0,
                    maxY: 4,
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white.withOpacity(0.5),
                          strokeWidth: 1,
                          dashArray: [5, 5], // Dashed lines
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
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false, // Hide left titles
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < snapshot.data!.docs.length) {
                              return Text(
                                DateFormat('dd/MM').format(
                                    snapshot.data!.docs[value.toInt()]['date']
                                        .toDate()),
                                style: TextStyle(color: Colors.white, fontSize: 10),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return Transform.translate(
                                  offset: Offset(10, -10),
                                  child: Text(
                                    'Awful',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                );
                              case 1:
                                return Transform.translate(
                                  offset: Offset(10, 0),
                                  child: Text(
                                    'Bad',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                );
                              case 2:
                                return Transform.translate(
                                  offset: Offset(10, 10),
                                  child: Text(
                                    'Neutral',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                );
                              case 3:
                                return Transform.translate(
                                  offset: Offset(10, 20),
                                  child: Text(
                                    'Good',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                );
                              case 4:
                                return Transform.translate(
                                  offset: Offset(10, 30),
                                  child: Text(
                                    'Great',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                );
                              default:
                                return Container();
                            }
                          },
                          reservedSize: 50,
                        ),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: false,
                        barWidth: 0, // No connecting lines
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: dotColors[index],
                              strokeWidth: 2,
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

  Color _getDotColor(String feeling) {
    switch (feeling) {
      case 'Awful':
        return Colors.red;
      case 'Bad':
        return Colors.orange;
      case 'Neutral':
        return Colors.yellow;
      case 'Good':
        return Colors.lightGreen;
      case 'Great':
        return Colors.green;
      default:
        return Colors.grey;
    }
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
        textStyle: TextStyle(fontSize: 16, color: AppColors.getTextColor(context)),
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
    if (!mounted) return;
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}

void main() => runApp(MaterialApp(home: MentalHealthTrackerPage()));