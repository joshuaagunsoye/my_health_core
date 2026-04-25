import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/widgets/notification_service.dart';
import 'package:my_health_core/widgets/dark_mode_toggle.dart';
import 'package:my_health_core/pages/streaks_page.dart';
import 'package:my_health_core/pages/app_activity_page.dart';
import 'package:my_health_core/providers/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _currentPasswordController =
  TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
  TextEditingController();

  String _profileImage = 'assets/avatars/avatar1.png'; // Default profile image.
  int _streaks = 0;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return;
    var userData = await _firestore.collection('users').doc(user.uid).get();
    if (!mounted) return;
    var data = userData.data();
    if (data != null) {
      _usernameController.text = data['username'] ?? '';
      _emailController.text = data['email'] ?? '';
      _profileImage = data['profileImage'] ?? _profileImage;
      _streaks = data['streaks'] ?? 0;
      setState(() {});
    }
  }

  void _changeProfileImage() async {
    String? selectedAvatar = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an Avatar'),
          content: SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              children: List.generate(16, (index) {
                String avatarPath = 'assets/avatars/avatar${index + 1}.png';
                return InkWell(
                  onTap: () => Navigator.of(context).pop(avatarPath),
                  child: Image.asset(avatarPath, width: 80, height: 80),
                );
              }),
            ),
          ),
        );
      },
    );

    if (selectedAvatar != null) {
      setState(() {
        _profileImage = selectedAvatar;
      });
    }
  }

  Future<void> _saveProfile() async {
    try {
      User? user = _auth.currentUser;
      if (_newPasswordController.text.isNotEmpty) {
        AuthCredential credential = EmailAuthProvider.credential(
            email: _emailController.text,
            password: _currentPasswordController.text);
        await user!.reauthenticateWithCredential(credential);
        await user.updatePassword(_newPasswordController.text);
      }

      await _firestore.collection('users').doc(user!.uid).update({
        'username': _usernameController.text,
        'profileImage': _profileImage,
        'streaks': _streaks,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: ${e.toString()}")));
    }
  }

  // Feature card navigation methods
  void _viewAppActivity() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AppActivityPage()),
    );
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      // Navigate to welcome/login page and clear navigation stack
      Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Successfully signed out")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error signing out: ${e.toString()}")),
      );
    }
  }

  void _openNotifications() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.getBackgroundColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text(
            'Notification Settings', 
            style: TextStyle(
              color: AppColors.getTextColor(context), 
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: AppColors.getSurfaceColor(context),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'MyHealthCore sends you 2 helpful reminders per day at 10:00 AM and 6:00 PM.',
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await NotificationService.scheduleDailyReminders();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Daily reminders enabled!'),
                                backgroundColor: AppColors.myrtleGreen,
                              ),
                            );
                          },
                          child: Text(
                            'Enable', 
                            style: TextStyle(
                              color: AppColors.getTextColor(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.getButtonColor(context),
                            foregroundColor: AppColors.getTextColor(context),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await NotificationService.cancelReminderNotifications();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Reminders disabled'),
                                backgroundColor: AppColors.myrtleGreen,
                              ),
                            );
                          },
                          child: Text(
                            'Disable', 
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.disabledButton,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Test notification button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await NotificationService.scheduleTestNotification();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Test notification will appear in 10 seconds!'),
                          backgroundColor: AppColors.myrtleGreen,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Text(
                      'Send Test Reminder (10 seconds)', 
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.myrtleGreen,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                // Debug buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await NotificationService.checkNotificationPermissions();
                          await NotificationService.showImmediateTestNotification();
                          await NotificationService.debugPendingNotifications();
                        },
                        child: Text('Immediate Test', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: AppColors.getTextColor(context),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await NotificationService.debugPendingNotifications();
                        },
                        child: Text('Check Pending', style: TextStyle(fontSize: 12)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.gold,
                          foregroundColor: AppColors.getTextColor(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // Watch the theme provider to rebuild when theme changes
    context.watch<ThemeProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      appBar: CommonWidgets.buildAppBar('My Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: _changeProfileImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(_profileImage),
                  ),
                ),
              ),
              SizedBox(height: 24),

              _buildFeatureCard("MyHealthCore Streaks", Icons.local_fire_department, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StreaksPage()),
                );
              }),
              SizedBox(height: 12),
              
              // Feature Cards Section
              _buildFeatureCard("View App Activity", Icons.analytics, () => _viewAppActivity()),
              _buildFeatureCard("Notifications", Icons.notifications, () => _openNotifications()),
              _buildDarkModeCard(),
              SizedBox(height: 12),


              // _buildTextField(_usernameController, 'Username'), // Hidden username field
              // _buildTextField(_emailController, 'Email', enabled: false), // Hidden email field
              // _buildTextField(_currentPasswordController, 'Current Password', obscureText: true), // Hidden password field
              // _buildTextField(_newPasswordController, 'New Password', obscureText: true), // Hidden new password field
              // _buildTextField(_confirmNewPasswordController, 'Confirm New Password', obscureText: true), // Hidden confirm password field
              SizedBox(height: 24),

              // Streaks & Quiz Stats Section


              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _signOut,
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool enabled = true, bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, labelStyle: TextStyle(color: AppColors.getTextColor(context))),
      style: TextStyle(color: AppColors.getTextColor(context)),
      obscureText: obscureText,
      enabled: enabled,
    );
  }

  Widget _buildFeatureCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          color: AppColors.getSurfaceColor(context),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(color: AppColors.getTextColor(context), fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Icon(Icons.arrow_forward_ios, color: AppColors.getAccentColor(context), size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDarkModeCard() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        color: AppColors.getSurfaceColor(context),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dark Mode',
                style: TextStyle(color: AppColors.getTextColor(context), fontSize: 16, fontWeight: FontWeight.w500),
              ),
              DarkModeSwitch(),
            ],
          ),
        ),
      ),
    );
  }
}


void main() => runApp(MaterialApp(home: ProfilePage()));
