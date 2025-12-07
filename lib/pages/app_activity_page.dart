import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/common_widgets.dart';

class AppActivityPage extends StatefulWidget {
  @override
  _AppActivityPageState createState() => _AppActivityPageState();
}

class _AppActivityPageState extends State<AppActivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: AppColors.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.getTextColor(context)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'View MyHealthTracker Activity',
          style: TextStyle(
            color: AppColors.getTextColor(context),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Tests Tracker'),
              _buildTestsChart(),
              SizedBox(height: 24),
              
              _buildSectionTitle('Appointments Tracker'),
              _buildAppointmentsChart(),
              SizedBox(height: 24),
              
              _buildSectionTitle('Mental Health Tracker'),
              _buildMentalHealthChart(),
              SizedBox(height: 24),
              
              _buildSectionTitle('Symptoms Tracker'),
              _buildSymptomsChart(),
              SizedBox(height: 24),
              
              _buildSectionTitle('Medication Tracker'),
              _buildMedicationChart(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          color: AppColors.getTextColor(context),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTestsChart() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildEmptyCard('Please log in to view test data');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('tests')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('No test data available');
        }

        List<Map<String, dynamic>> logs = snapshot.data!.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return {
            'type': data['type'] ?? 'Unknown',
            'result': data['result'] ?? 'Unknown',
          };
        }).toList();

        int countStandardTest = logs.where((log) => log['type'] == 'HIV Standard Test').length;
        int countSelfTest = logs.where((log) => log['type'] == 'HIV Self-Test').length;

        return _buildChartCard(
          child: SizedBox(
            height: 250,
            child: SfCircularChart(
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(color: AppColors.getTextColor(context)),
              ),
              series: <CircularSeries>[
                DoughnutSeries<TestData, String>(
                  dataSource: [
                    TestData('HIV Standard Test', countStandardTest),
                    TestData('HIV Self-Test', countSelfTest),
                  ],
                  xValueMapper: (TestData data, _) => data.type,
                  yValueMapper: (TestData data, _) => data.count,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(color: AppColors.getTextColor(context)),
                  ),
                  innerRadius: '50%',
                  pointColorMapper: (TestData data, _) => 
                    data.type == 'HIV Standard Test' ? AppColors.gold : AppColors.mintGreen,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppointmentsChart() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildEmptyCard('Please log in to view appointment data');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('No appointment data available');
        }

        Map<String, int> appointmentCounts = {};
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          String provider = data['serviceProvider'] ?? 'Unknown';
          appointmentCounts[provider] = (appointmentCounts[provider] ?? 0) + 1;
        }

        return _buildChartCard(
          child: SizedBox(
            height: 250,
            child: SfCircularChart(
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(color: AppColors.getTextColor(context)),
              ),
              series: <CircularSeries>[
                PieSeries<MapEntry<String, int>, String>(
                  dataSource: appointmentCounts.entries.toList(),
                  xValueMapper: (MapEntry<String, int> data, _) => data.key,
                  yValueMapper: (MapEntry<String, int> data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(color: AppColors.getTextColor(context)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMentalHealthChart() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildEmptyCard('Please log in to view mental health data');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mentalHealthLogs')
          .where('userId', isEqualTo: user.uid)
          .orderBy('date')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('No mental health data available');
        }

        Map<String, int> feelingCounts = {};
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          String feeling = data['feeling'] ?? 'Unknown';
          feelingCounts[feeling] = (feelingCounts[feeling] ?? 0) + 1;
        }

        return _buildChartCard(
          child: SizedBox(
            height: 250,
            child: Container(
              padding: EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: feelingCounts.values.isEmpty ? 10 : feelingCounts.values.reduce((a, b) => a > b ? a : b).toDouble() + 2,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          List<String> feelings = feelingCounts.keys.toList();
                          if (value.toInt() < feelings.length) {
                            return Text(
                              feelings[value.toInt()],
                              style: TextStyle(
                                color: AppColors.getTextColor(context),
                                fontSize: 10,
                              ),
                            );
                          }
                          return Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: AppColors.getTextColor(context),
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: feelingCounts.entries.toList().asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.value.toDouble(),
                          color: AppColors.mintGreen,
                          width: 20,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSymptomsChart() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildEmptyCard('Please log in to view symptom data');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('symptoms')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('No symptom data available');
        }

        Map<String, int> symptomCounts = {};
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          String type = data['type'] ?? 'Unknown';
          symptomCounts[type] = (symptomCounts[type] ?? 0) + 1;
        }

        return _buildChartCard(
          child: SizedBox(
            height: 250,
            child: SfCircularChart(
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(color: AppColors.getTextColor(context)),
              ),
              series: <CircularSeries>[
                PieSeries<MapEntry<String, int>, String>(
                  dataSource: symptomCounts.entries.toList(),
                  xValueMapper: (MapEntry<String, int> data, _) => data.key,
                  yValueMapper: (MapEntry<String, int> data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(color: AppColors.getTextColor(context)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMedicationChart() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildEmptyCard('Please log in to view medication data');
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medications')
          .where('userId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyCard('No medication data available');
        }

        Map<String, int> medicationCounts = {};
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          String type = data['type'] ?? 'Unknown';
          medicationCounts[type] = (medicationCounts[type] ?? 0) + 1;
        }

        return _buildChartCard(
          child: SizedBox(
            height: 250,
            child: SfCircularChart(
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
                textStyle: TextStyle(color: AppColors.getTextColor(context)),
              ),
              series: <CircularSeries>[
                DoughnutSeries<MapEntry<String, int>, String>(
                  dataSource: medicationCounts.entries.toList(),
                  xValueMapper: (MapEntry<String, int> data, _) => data.key,
                  yValueMapper: (MapEntry<String, int> data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: TextStyle(color: AppColors.getTextColor(context)),
                  ),
                  innerRadius: '50%',
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChartCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.getTextColor(context).withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLoadingCard() {
    return _buildChartCard(
      child: SizedBox(
        height: 250,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.mintGreen),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCard(String message) {
    return _buildChartCard(
      child: SizedBox(
        height: 250,
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              color: AppColors.getTextColor(context).withOpacity(0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Data class for test chart
class TestData {
  TestData(this.type, this.count);
  final String type;
  final int count;
}
