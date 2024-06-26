// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

// SignUpPage provides a registration interface for new users.
final _firebase = FirebaseAuth.instance;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() {
    return _SignUpPageState();
  }
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  // var _isLogin = false;
  var _enteredUsername = "";
  var _enteredEmail = "";
  var _enteredPassword = "";
  var _enteredConfirmPassword = "";

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    if (_enteredPassword != _enteredConfirmPassword) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Passwords do not match')));
      return;
    }

    try {
      final userCredentials = await _firebase.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredPassword,
      );
      print(userCredentials);
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed')),
      );
    }
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Username',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.saffron,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredUsername = value!;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email Address',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.saffron,
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredEmail = value!;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
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
                         validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password must be at least 6 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredPassword = value!;
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.saffron,
                        ),
                         validator: (value) {
                          if (value == null || value.trim().length < 6) {
                            return 'Password must be at least 6 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _enteredConfirmPassword = value!;
                        },
                        obscureText: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundGreen,
                      foregroundColor: AppColors.white,
                    ),
                    child: Text('Sign Up'),
                  ),
                ),
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
}
