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
      backgroundColor: AppColors.getBackgroundColor(context),
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
                      style: TextStyle(fontSize: 20, color: AppColors.getTextColor(context)),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today,
                          size: 24.0, color: AppColors.getTextColor(context)),
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
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
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
              style: TextStyle(fontSize: 20, color: AppColors.getTextColor(context))),
          DropdownButtonFormField<String>(
            value: selectedMedicationType,
            decoration: InputDecoration(
              labelText: 'Select Medication Type',
              fillColor: AppColors.backgroundGreen,
              filled: true,
              labelStyle: TextStyle(color: AppColors.getTextColor(context)),
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
              labelStyle: TextStyle(color: AppColors.getTextColor(context)),
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
                style: TextStyle(color: AppColors.getTextColor(context))),
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
                labelText: 'Medication Name',
                labelStyle: TextStyle(color: AppColors.getTextColor(context))),
            style: TextStyle(color: Colors.white),
          ),
          TextField(
            controller: dosageController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Dosage (mg)',
              labelStyle: TextStyle(color: AppColors.getTextColor(context)),
              filled: true,
              fillColor: AppColors.backgroundGreen,
            ),
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _logMedication,
            child: Text(
              'Log Medication',
              style: TextStyle(color: AppColors.getTextColor(context)),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.white),
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
            .orderBy('date')
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

          // Group data by date and medication type.
          // Always use the medication type (from the dropdown) as the key.
          // Dosage values are summed up per date per type.
          Map<String, Map<String, double>> medicationData = {};
          snapshot.data!.docs.forEach((doc) {
            var data = doc.data() as Map<String, dynamic>;
            String date = DateFormat('dd/MM')
                .format((data['date'] as Timestamp).toDate());
            String type = data['type'] ?? 'Unknown';

            if (!medicationData.containsKey(date)) {
              medicationData[date] = {
                'ART - Single Fixed Dose': 0.0,
                'ART - Combination Fixed Dose': 0.0,
                'ART - Injectable': 0.0,
                'PrEP': 0.0,
                'PEP': 0.0,
              };
            }

            double dosage = 0.0;
            // Parse the numeric part from 'customDosage', if provided.
            if (data.containsKey('customDosage') &&
                (data['customDosage'] as String).trim().isNotEmpty) {
              String numericPart = (data['customDosage'] as String)
                  .replaceAll(RegExp(r'[^0-9.]'), '');
              dosage = double.tryParse(numericPart) ?? 1.0;
            } else {
              // Use a default value (or you may choose to skip adding if no dosage logged)
              dosage = 1.0;
            }
            if (medicationData[date]!.containsKey(type)) {
              medicationData[date]![type] =
                  (medicationData[date]![type] ?? 0.0) + dosage;
            }
          });

          // Build bar groups per date.
          List<BarChartGroupData> barGroups = [];
          int index = 0;
          medicationData.forEach((date, medCounts) {
            // For each date, create a bar for each medication type.
            List<BarChartRodData> rods = [];
            medCounts.forEach((type, totalDosage) {
              rods.add(
                BarChartRodData(
                  toY: totalDosage,
                  color: _getBarColor(type),
                  borderRadius: BorderRadius.circular(8),
                  width: 16,
                ),
              );
            });
            barGroups.add(
              BarChartGroupData(
                x: index,
                barRods: rods,
              ),
            );
            index++;
          });

          // Legend data mapping for medication types.
          Map<String, Color> legendData = {
            'ART - Single Fixed Dose': Colors.blue,
            'ART - Combination Fixed Dose': Colors.orange,
            'ART - Injectable': Colors.indigo,
            'PrEP': Colors.yellow,
            'PEP': Colors.red,
          };

          return Column(
            children: [
              Text('Medication Summary',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              Container(
                height: 300,
                child: BarChart(
                  BarChartData(
                    barGroups: barGroups,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 50,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              value.toInt().toString(),
                              style: TextStyle(color: Colors.white, fontSize: 10),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < medicationData.keys.length) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  medicationData.keys.elementAt(value.toInt()),
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 12, letterSpacing: 2.0, fontWeight: FontWeight.bold),
                                ),
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
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      horizontalInterval: 5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.white.withOpacity(0.1),
                          strokeWidth: 1,
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              _buildLegend(legendData),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLegend(Map<String, Color> legendData) {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: legendData.entries.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              color: entry.value,
            ),
            SizedBox(width: 5),
            Text(entry.key, style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        );
      }).toList(),
    );
  }

  Color _getBarColor(String medicationType) {
    switch (medicationType) {
      case 'ART - Single Fixed Dose':
        return Colors.blue;
      case 'ART - Combination Fixed Dose':
        return Colors.orange;
      case 'ART - Injectable':
        return Colors.indigo;
      case 'PrEP':
        return Colors.yellow;
      case 'PEP':
        return Colors.red;
      default:
        return Colors.grey;
    }
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
        style: TextStyle(color: AppColors.getTextColor(context)),
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
