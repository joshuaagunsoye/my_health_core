import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';

class TestTrackerPage extends StatefulWidget {
  @override
  _TestTrackerPageState createState() => _TestTrackerPageState();
}

class _TestTrackerPageState extends State<TestTrackerPage> {
  DateTime selectedDate = DateTime.now();
  String? selectedTestType;
  String? followUpBooked;
  final TextEditingController resultsController = TextEditingController();
  String? selectedFilterTestType;
  bool showAllData = false;

  final List<String> testTypes = [
    'HIV Standard Test',
    'HIV Self-Test',
  ];

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
              CommonWidgets.buildMainHeading('Track Your Tests'),
              _dateSelectionSection(),
              SizedBox(height: 10),
              _logTestContainer(),
              SizedBox(height: 10),
              _addTestResultsContainer(),
              SizedBox(height: 20),
              _summaryContainer(),  // This will contain the pie chart
              SizedBox(height: 10),
              _testTypeFilterDropdown(),
              SizedBox(height: 10),
              _showAllDataButton(),
              if (showAllData) _allDataTable(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 2),
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

  Widget _logTestContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Log a Test',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          DropdownButtonFormField<String>(
            value: selectedTestType,
            decoration: InputDecoration(
              labelText: 'Select Test Type',
              fillColor: AppColors.backgroundGreen,
              filled: true,
              labelStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (String? newValue) {
              setState(() {
                selectedTestType = newValue;
              });
            },
            items: testTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _addTestResultsContainer() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Add Test Results',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          TextField(
            controller: resultsController,
            decoration: InputDecoration(
              labelText: 'Results',
              labelStyle: TextStyle(color: Colors.white),
            ),
            style: TextStyle(color: Colors.white),
          ),
          DropdownButtonFormField<String>(
            value: followUpBooked,
            decoration: InputDecoration(
              labelText: 'Follow Up Booked',
              fillColor: AppColors.backgroundGreen,
              filled: true,
              labelStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (String? newValue) {
              setState(() {
                followUpBooked = newValue;
              });
            },
            items: ['Yes', 'No'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: _logTestAndResult,
            child: Text(
              'Add Test and Results',
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.saffron),
          ),
        ],
      ),
    );
  }

  void _logTestAndResult() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null ||
        selectedTestType == null ||
        resultsController.text.isEmpty ||
        followUpBooked == null) {
      _showSnackBar('Please complete all fields and be logged in.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('tests').add({
        'userId': user.uid,
        'date': selectedDate,
        'type': selectedTestType!,
        'result': resultsController.text.trim(),
        'followUp': followUpBooked!,
      });

      setState(() {
        selectedTestType = null;
        followUpBooked = null;
        resultsController.clear();
      });

      _showSnackBar('Test and results logged successfully.');
    } catch (e) {
      _showSnackBar('Failed to add test result: $e');
    }
  }

  Widget _summaryContainer() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(
        child: Text('Please log in to view summary', style: TextStyle(color: Colors.white)),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tests')
            .where('userId', isEqualTo: user.uid)
            .orderBy('date')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No test results found', style: TextStyle(color: Colors.white)),
            );
          }

          List<Map<String, dynamic>> logs = snapshot.data!.docs.map((doc) {
            return {
              'date': (doc['date'] as Timestamp).toDate(),
              'type': doc['type'],
              'result': doc['result'],
              'followUp': doc['followUp']
            };
          }).toList();

          return Column(
            children: [
              Text('Summary', style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              _buildSyncfusionPieChart(logs),  // Pie chart method call here
            ],
          );
        },
      ),
    );
  }

  Widget _buildSyncfusionPieChart(List<Map<String, dynamic>> logs) {
    int countStandardTest = 0;
    int countSelfTest = 0;

    for (var log in logs) {
      if (log['type'] == 'HIV Standard Test') {
        countStandardTest++;
      } else if (log['type'] == 'HIV Self-Test') {
        countSelfTest++;
      }
    }

    // Enable tooltips by adding TooltipBehavior
    TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: AppColors.backgroundGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SfCircularChart(
        // Add TooltipBehavior to enable hover effects
        tooltipBehavior: _tooltipBehavior,
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        series: <CircularSeries>[
          PieSeries<Data, String>(
            dataSource: [
              Data('HIV Standard Test', countStandardTest),
              Data('HIV Self-Test', countSelfTest),
            ],
            xValueMapper: (Data data, _) => data.type,
            yValueMapper: (Data data, _) => data.count,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            // Enable tooltips for each pie slice
            enableTooltip: true,
          )
        ],
      ),
    );
  }


  Widget _testTypeFilterDropdown() {
    return Container(
        padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
    color: AppColors.backgroundGreen,
    borderRadius: BorderRadius.circular(12),
    ),
    child: DropdownButtonFormField<String>(
    value: selectedFilterTestType,
    decoration: InputDecoration(
    labelText: 'Filter by Test Type',
    fillColor: AppColors.backgroundGreen,
    filled: true,
    labelStyle: TextStyle(color: Colors.white),
    ),
      onChanged: (String? newValue) {
        setState(() {
          selectedFilterTestType = newValue;
          showAllData = true; // Show the data table when a new filter is selected
        });
      },
      items: testTypes.map<DropdownMenuItem<String>>((String value) {
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
          .collection('tests')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No data available', style: TextStyle(color: Colors.white)),
          );
        }

        List<Map<String, dynamic>> logs = snapshot.data!.docs.map((doc) {
          return {
            'date': (doc['date'] as Timestamp).toDate(),
            'type': doc['type'],
            'result': doc['result'],
            'followUp': doc['followUp']
          };
        }).toList();

        if (selectedFilterTestType != null) {
          logs = logs.where((log) => log['type'] == selectedFilterTestType).toList();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 50,
            columns: [
              DataColumn(
                label: Text('Date', style: TextStyle(color: Colors.white)),
              ),
              DataColumn(
                label: Text('Test Type', style: TextStyle(color: Colors.white)),
              ),
              DataColumn(
                label: Text('Result', style: TextStyle(color: Colors.white)),
              ),
              DataColumn(
                label: Text('Follow Up', style: TextStyle(color: Colors.white)),
              ),
            ],
            rows: logs.map((log) {
              DateTime date = log['date'];
              String testType = log['type'];
              String result = log['result'];
              String followUp = log['followUp'];
              return DataRow(
                cells: [
                  DataCell(Text(DateFormat('yyyy-MM-dd').format(date), style: TextStyle(color: Colors.white))),
                  DataCell(Text(testType, style: TextStyle(color: Colors.white))),
                  DataCell(Text(result, style: TextStyle(color: Colors.white))),
                  DataCell(Text(followUp, style: TextStyle(color: Colors.white))),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
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

void main() => runApp(MaterialApp(home: TestTrackerPage()));

// The Data class for Pie Chart
class Data {
  Data(this.type, this.count);
  final String type;
  final int count;
}

