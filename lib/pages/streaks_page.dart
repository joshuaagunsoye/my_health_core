import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/common_widgets.dart';

class StreaksPage extends StatefulWidget {
  @override
  _StreaksPageState createState() => _StreaksPageState();
}

class _StreaksPageState extends State<StreaksPage> {
  DateTime _currentMonth = DateTime.now();
  int _currentStreak = 0;
  Set<DateTime> _activeDays = {};
  String _profileImage = 'assets/avatars/avatar1.png';

  @override
  void initState() {
    super.initState();
    _loadStreakData();
  }

  Future<void> _loadStreakData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    // Load user profile data
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!mounted) return;
    if (userData.exists) {
      setState(() {
        _profileImage = userData['profileImage'] ?? _profileImage;
        _currentStreak = userData['streak'] ?? 0;
      });
    }

    // Load active days (days when user was active)
    // You can customize this based on your streak tracking logic
    var today = DateTime.now();
    var startOfMonth = DateTime(today.year, today.month, 1);

    // Example: Mark days based on lastActiveDate or quiz completion
    // This is a simple example - adjust based on your actual streak logic
    for (int i = 0; i < _currentStreak && i < 30; i++) {
      _activeDays.add(today.subtract(Duration(days: i)));
    }
    if (!mounted) return;
    setState(() {});
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isDayActive(DateTime day) {
    return _activeDays.any((activeDay) =>
        activeDay.year == day.year &&
        activeDay.month == day.month &&
        activeDay.day == day.day);
  }

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
          'MyHealthCore Streaks',
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
            children: [
              SizedBox(height: 20),
              // Profile Avatar
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage(_profileImage),
              ),
              SizedBox(height: 40),
              // Calendar
              _buildCalendar(),
              SizedBox(height: 40),
              // Streak Display
              _buildStreakDisplay(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.getTextColor(context).withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Month Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: AppColors.getTextColor(context)),
                onPressed: _previousMonth,
              ),
              Text(
                DateFormat('MMMM yyyy').format(_currentMonth),
                style: TextStyle(
                  color: AppColors.getTextColor(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: AppColors.getTextColor(context)),
                onPressed: _nextMonth,
              ),
            ],
          ),
          SizedBox(height: 16),
          // Weekday Headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN']
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            color: AppColors.getTextColor(context).withOpacity(0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          SizedBox(height: 12),
          // Calendar Grid
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // Get first day of the month
    var firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    var lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    
    // Calculate padding (Monday = 1, Sunday = 7)
    int startWeekday = firstDayOfMonth.weekday;
    int daysInMonth = lastDayOfMonth.day;
    
    List<Widget> dayWidgets = [];
    
    // Add empty cells for days before the month starts
    for (int i = 1; i < startWeekday; i++) {
      dayWidgets.add(_buildEmptyDay());
    }
    
    // Add days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      var currentDay = DateTime(_currentMonth.year, _currentMonth.month, day);
      dayWidgets.add(_buildDay(day, currentDay));
    }
    
    // Add empty cells to complete the grid
    while (dayWidgets.length % 7 != 0) {
      dayWidgets.add(_buildEmptyDay());
    }
    
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: dayWidgets,
    );
  }

  Widget _buildDay(int day, DateTime date) {
    bool isActive = _isDayActive(date);
    bool isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;
    
    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.gold.withOpacity(0.3)
            : AppColors.getTextColor(context).withOpacity(0.05),
        shape: BoxShape.circle,
        border: isToday
            ? Border.all(color: AppColors.gold, width: 2)
            : null,
      ),
      child: Center(
        child: isActive
            ? Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    color: AppColors.gold,
                    size: 24,
                  ),
                  if (day < 10)
                    Positioned(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              )
            : Text(
                '$day',
                style: TextStyle(
                  color: AppColors.getTextColor(context).withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyDay() {
    return Container();
  }

  Widget _buildStreakDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.getTextColor(context).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: AppColors.gold,
            size: 32,
          ),
          SizedBox(width: 12),
          Text(
            '$_currentStreak Day Streak',
            style: TextStyle(
              color: AppColors.getTextColor(context),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
