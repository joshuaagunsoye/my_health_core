import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Added for onboarding

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  bool _isLoading = false;
  bool _agreedToTerms = false;

  bool _isPasswordStrong(String password) {
    // Custom password strength validation
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasSpecialCharacters =
    password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final hasMinLength = password.length >= 8;

    return hasUppercase &
    hasDigits &
    hasLowercase &
    hasSpecialCharacters &
    hasMinLength;
  }

  Future<void> _signUp() async {
    final username = _usernameController.text;
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Custom email format validation to ensure it ends with @gmail.com
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@gmail\.com$").hasMatch(email)) {
      _showSnackBar('Please enter a valid Gmail address');
      return;
    }

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar('Email and password cannot be empty');
      return;
    }

    if (!_isPasswordStrong(password)) {
      _showSnackBar(
          'Password must be at least 8 characters long, and include uppercase, lowercase, number, and special character.');
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match');
      return;
    }

    if (!_agreedToTerms) {
      _showSnackBar('You must agree to the Terms and Conditions');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store additional user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'username': username,
        'streak': 0,
        'lastActiveDate': Timestamp.now(),
        'email': email,
      });

      // Set onboarding flag to false for new users
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasCompletedOnboarding', false);

      print('User created');
      // Navigate to onboarding instead of home
      Navigator.pushReplacementNamed(context, '/onboarding');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
          'This email is already in use. Please try another email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        default:
          errorMessage = 'Failed to sign up: ${e.message}';
      }
      _showSnackBar(errorMessage);
      print('Failed to sign up: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Create an Account',
                        style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Image.asset(
                        'assets/images/landing.png',
                        height: (constraints.maxHeight * 0.25).clamp(140.0, 220.0),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _usernameController,
                        style: TextStyle(color: AppColors.getTextColor(context)),
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(color: AppColors.getTextColor(context).withOpacity(0.6)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.getSurfaceColor(context)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.getSurfaceColor(context), width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.getSurfaceColor(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _emailController,
                        style: TextStyle(color: AppColors.getTextColor(context)),
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          hintStyle: TextStyle(color: AppColors.getTextColor(context).withOpacity(0.6)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.getSurfaceColor(context)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.getSurfaceColor(context), width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.getSurfaceColor(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: AppColors.getTextColor(context)),
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: TextStyle(color: AppColors.getTextColor(context).withOpacity(0.6)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.getSurfaceColor(context)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.getSurfaceColor(context), width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.getSurfaceColor(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        style: TextStyle(color: AppColors.getTextColor(context)),
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: TextStyle(color: AppColors.getTextColor(context).withOpacity(0.6)),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.getSurfaceColor(context)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            borderSide: BorderSide(color: AppColors.getSurfaceColor(context), width: 2),
                          ),
                          filled: true,
                          fillColor: AppColors.getSurfaceColor(context),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _agreedToTerms,
                            onChanged: (value) {
                              setState(() {
                                _agreedToTerms = value ?? false;
                              });
                            },
                            activeColor: AppColors.mintGreen,
                            checkColor: AppColors.white,
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final agreed = await Navigator.pushNamed(context, '/terms_and_conditions');
                                if (agreed == true) {
                                  setState(() {
                                    _agreedToTerms = true;
                                  });
                                }
                              },
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: AppColors.getTextColor(context),
                                    fontSize: 14,
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.getButtonColor(context),
                            foregroundColor: AppColors.getTextColor(context),
                          ),
                          child: _isLoading
                              ? CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.getTextColor(context)),
                          )
                              : const Text('Sign Up'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                              color: AppColors.getTextColor(context),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.getTextColor(context),
                            ),
                            child: const Text(
                              'Sign in!',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}