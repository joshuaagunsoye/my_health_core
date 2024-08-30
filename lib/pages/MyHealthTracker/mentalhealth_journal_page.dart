import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';

class MentalHealthJournalPage extends StatefulWidget {
  @override
  _MentalHealthJournalPageState createState() =>
      _MentalHealthJournalPageState();
}

class _MentalHealthJournalPageState extends State<MentalHealthJournalPage> {
  TextEditingController _journalController =
      TextEditingController(); // Controls text input for journal entries
  DateTime selectedDate =
      DateTime.now(); // Holds currently selected date for journal entries

  @override
  void dispose() {
    _journalController.dispose(); // Properly dispose of the controller
    super.dispose();
  }

  void _addNewEntry() {
    _journalController.clear(); // Clears the text field when adding a new entry
  }

  void _saveEntry() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && _journalController.text.isNotEmpty) {
      Map<String, dynamic> data = {
        'userId': user.uid,
        'date': selectedDate,
        'entry': _journalController.text
      };
      FirebaseFirestore.instance.collection('mentalHealthJournal').add(data);
      _journalController
          .clear(); // Clears the text field after saving the entry
    }
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
        selectedDate = picked; // Updates the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('Mental Health Tracker'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CommonWidgets.buildMainHeading('Mental Health Journal'),
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
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _addNewEntry,
                child: Text(
                  'New Entry',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron),
              ),
              TextField(
                controller: _journalController,
                decoration: InputDecoration(
                  hintText: 'Type your thoughts here...',
                  hintStyle: TextStyle(
                      color: AppColors.chocolateCosmos.withOpacity(0.6)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.chocolateCosmos),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.gold),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
                maxLines: 5,
                style: TextStyle(color: Colors.black),
              ),
              ElevatedButton(
                onPressed: _saveEntry,
                child: Text(
                  'Save Entry',
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron),
              ),
              SizedBox(height: 10),
              _buildJournalEntries(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildJournalEntries() {
    User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('mentalHealthJournal')
          .where('userId', isEqualTo: user?.uid)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return Center(
              child: Text('No journal entries found',
                  style: TextStyle(color: Colors.white)));
        }

        Map<DateTime, List<String>> journalEntries = {};
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          DateTime date = (data['date'] as Timestamp).toDate();
          date =
              DateTime(date.year, date.month, date.day); // Normalize the date
          String entry = data['entry'] ?? '';
          journalEntries[date] = journalEntries[date] ?? [];
          journalEntries[date]!.add(entry);
        }

        List<DateTime> dates = journalEntries.keys.toList();
        dates.sort((a, b) => b.compareTo(a));

        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.backgroundGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text('Old Entries',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              ...dates.map((date) {
                return ExpansionTile(
                  title: Text(DateFormat('yyyy-MM-dd').format(date),
                      style: TextStyle(color: Colors.white)),
                  children: journalEntries[date]!.map((entry) {
                    return ListTile(
                      title: Text(entry, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

void main() => runApp(MaterialApp(home: MentalHealthJournalPage()));
