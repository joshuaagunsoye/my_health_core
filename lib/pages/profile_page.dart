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
        if (data['profileImage'] != null) {
          _profileImage = data['profileImage'];
        }
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
    if (_newPasswordController.text.isNotEmpty &&
        (_newPasswordController.text != _confirmNewPasswordController.text)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("New passwords do not match")));
      return;
    }

    if (_newPasswordController.text.isNotEmpty &&
        !isValidPassword(_newPasswordController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a number, and a special character.")));
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (_newPasswordController.text.isNotEmpty) {
        // Re-authenticate user if password change is requested
        AuthCredential credential = EmailAuthProvider.credential(
            email: _emailController.text,
            password: _currentPasswordController.text);
        await user!.reauthenticateWithCredential(credential);

        // If re-authentication is successful, proceed to update the password
        await user.updatePassword(_newPasswordController.text);
      }

      // Update user profile in Firestore
      await _firestore.collection('users').doc(user!.uid).update({
        'username': _usernameController.text,
        'profileImage': _profileImage,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = "The current password is incorrect.";
      } else {
        errorMessage = "Error updating profile: ${e.message}";
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }

  bool isValidPassword(String password) {
    final RegExp passwordRegExp = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('My Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: AppColors.white)),
                style: TextStyle(color: AppColors.white),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: AppColors.white)),
                style: TextStyle(color: AppColors.white),
                enabled: false,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _currentPasswordController,
                decoration: InputDecoration(
                    labelText: 'Current Password',
                    labelStyle: TextStyle(color: AppColors.white)),
                obscureText: true,
                style: TextStyle(color: AppColors.white),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: AppColors.white)),
                obscureText: true,
                style: TextStyle(color: AppColors.white),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _confirmNewPasswordController,
                decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    labelStyle: TextStyle(color: AppColors.white)),
                obscureText: true,
                style: TextStyle(color: AppColors.white),
              ),
              SizedBox(height: 24),
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
}

void main() => runApp(MaterialApp(home: ProfilePage()));
