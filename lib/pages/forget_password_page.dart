import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_health_core/styles/app_colors.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    // Function to send reset password email
    Future<void> resetPassword(String email) async {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reset password link has been sent to your email.'),
            backgroundColor: Colors.green,
          ),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred: ${e.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

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
                  'Forgot Password',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Enter your email address to reset your password',
                  style: TextStyle(
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: 32),
                TextField(
                  controller: emailController,
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
                ),
                SizedBox(height: 32),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter your email address.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        resetPassword(emailController.text);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundGreen,
                      foregroundColor: AppColors.white,
                    ),
                    child: Text('Reset Password'),
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password?',
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
