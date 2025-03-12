import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// LoginPage provides a simple and secure user login interface.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _updateStreak() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final DateTime now = DateTime.now().toUtc();
    final DateTime today = DateTime(now.year, now.month, now.day);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference userRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot snapshot = await transaction.get(userRef);

        if (snapshot.exists) {
          Timestamp? lastActive = snapshot['lastActiveDate'];
          int currentStreak = snapshot['streak'] ?? 0;

          if (lastActive != null) {
            DateTime lastDate = lastActive.toDate().toUtc();
            DateTime lastActiveDate = DateTime(lastDate.year, lastDate.month, lastDate.day);

            final difference = today.difference(lastActiveDate).inDays;

            if (difference == 1) {
              currentStreak++;
            } else if (difference > 1) {
              currentStreak = 0;
            }
          }

          transaction.update(userRef, {
            'streak': currentStreak,
            'lastActiveDate': Timestamp.fromDate(today),
          });
        }
      });
    } catch (e) {
      print('Error updating streak: $e');
    }
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email and password cannot be empty');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Login successful');
      await _updateStreak();
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
        case 'invalid-credential': // Treat invalid credentials the same as wrong password
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        default:
          errorMessage = 'Failed to login: ${e.message}';
      }
      _showSnackBar(errorMessage);
      print('Failed to login: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Spacer(),
                Text(
                  'Hello, welcome back!',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  'Login to continue',
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                ),
                Spacer(),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.saffron,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.saffron,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        print('Forgot password is clicked!');
                        Navigator.pushNamed(context, '/forget_password');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.white,
                      ),
                      child: Text('Forgot Password?')),
                ),
                SizedBox(
                  height: 48,
                ),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundGreen,
                      foregroundColor: AppColors.white,
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.white),
                          )
                        : Text('Login'),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                        print('Sign up is clicked!');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.buttonDisplay,
                      ),
                      child: Text(
                        'Sign up!',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
