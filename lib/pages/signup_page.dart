// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_health_core/widgets/form_container_widget.dart';
import 'package:my_health_core/firebase_auth_service.dart';

// SignUpPage provides a registration interface for new users.
// final _firebase = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                  'Create an Account',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                FormContainerWidget(
                  controller: _usernameController,
                  hintText: "Username",
                  isPasswordField: false,
                ),
                SizedBox(height: 16),
                FormContainerWidget(
                  controller: _emailController,
                  hintText: "Email address",
                  isPasswordField: false,
                ),
                SizedBox(height: 16),
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                SizedBox(height: 24),
                FormContainerWidget(
                  controller: _confirmPasswordController,
                  hintText: "Confirm Password",
                  isPasswordField: true,
                ),
                SizedBox(height: 24),
                // SizedBox(
                //   height: 48,
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: _submit,
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.backgroundGreen,
                //       foregroundColor: AppColors.white,
                //     ),
                //     child: Text('Sign Up'),
                //   ),
                // ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: AppColors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.buttonDisplay,
                      ),
                      child: Text(
                        'Sign in!',
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

  void _signUp() async {
    // setState(() {
    //   isSigningUp = true;
    // });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    // setState(() {
    //   isSigningUp = false;
    // });
    if (user != null) {
      // showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/home");
    } else {
      // showToast(message: "Some error happend");
    }
  }
}
