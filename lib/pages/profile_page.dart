import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';

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
  int _quizCount = 0;
  List<Map<String, dynamic>> _quizResults = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var userData = await _firestore.collection('users').doc(user.uid).get();
      var data = userData.data();
      if (data != null) {
        _usernameController.text = data['username'] ?? '';
        _emailController.text = data['email'] ?? '';
        _profileImage = data['profileImage'] ?? _profileImage;
        _streaks = data['streaks'] ?? 0;
        _quizCount = data['quizCount'] ?? 0;
        // _quizResults = List<Map<String, dynamic>>.from(data['quizResults'] ?? []);
        setState(() {});
      }
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
        'quizCount': _quizCount,
        'quizResults': _quizResults,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              _buildStatsCard("Streaks", "$_streaks Days", isStreak: true),
              _buildStatsCard("Quizzes Completed", "$_quizCount"),
              _buildQuizResults(),
              SizedBox(height: 12),


              _buildTextField(_usernameController, 'Username'),
              _buildTextField(_emailController, 'Email', enabled: false),
              _buildTextField(_currentPasswordController, 'Current Password', obscureText: true),
              _buildTextField(_newPasswordController, 'New Password', obscureText: true),
              _buildTextField(_confirmNewPasswordController, 'Confirm New Password', obscureText: true),
              SizedBox(height: 24),

              // Streaks & Quiz Stats Section


              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.saffron),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool enabled = true, bool obscureText = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, labelStyle: TextStyle(color: AppColors.white)),
      style: TextStyle(color: AppColors.white),
      obscureText: obscureText,
      enabled: enabled,
    );
  }

  Widget _buildStatsCard(String title, String value, {bool isStreak = false}) {
    return Card(
      color: AppColors.black,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(color: AppColors.saffron, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (isStreak) Text(" 🔥", style: TextStyle(fontSize: 20)), // Fire emoji
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildQuizResults() {
    return _quizResults.isNotEmpty
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text("Recent Quiz Results", style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ..._quizResults.take(5).map((quiz) => ListTile(
          title: Text("Score: ${quiz['score']}%", style: TextStyle(color: AppColors.white)),
          subtitle: Text("Date: ${quiz['date']}", style: TextStyle(color: AppColors.yellow)),
        )),
      ],
    )
        : SizedBox();
  }
}


void main() => runApp(MaterialApp(home: ProfilePage()));
