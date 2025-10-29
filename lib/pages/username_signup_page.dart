import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class UsernameSignUpPage extends StatefulWidget {
  const UsernameSignUpPage({super.key});

  @override
  _UsernameSignUpPageState createState() => _UsernameSignUpPageState();
}

class _UsernameSignUpPageState extends State<UsernameSignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  // Generate a random email and password for the user
  String _generateRandomEmail() {
    final random = Random();
    final randomId = random.nextInt(1000000000);
    return 'user_$randomId@myhealth.temp';
  }

  String _generateRandomPassword() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#\$%^&*';
    final random = Random();
    return List.generate(16, (index) => chars[random.nextInt(chars.length)]).join();
  }

  Future<void> _signUpWithUsername() async {
    final username = _usernameController.text.trim();

    if (username.isEmpty) {
      _showSnackBar('Please enter a username');
      return;
    }

    if (username.length < 3) {
      _showSnackBar('Username must be at least 3 characters');
      return;
    }

    // Check if username is already taken
    final usernameQuery = await _firestore
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (usernameQuery.docs.isNotEmpty) {
      _showSnackBar('Username already taken. Please choose another.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create account with random email/password
      final email = _generateRandomEmail();
      final password = _generateRandomPassword();
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        // Store user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'username': username,
          'isUsernameOnly': true,
          'createdAt': FieldValue.serverTimestamp(),
          'streak': 0,
          'lastActiveDate': Timestamp.fromDate(DateTime.now()),
        });

        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      _showSnackBar('Sign-up failed: ${e.message}');
    } catch (e) {
      _showSnackBar('An unexpected error occurred');
      print('Username signup error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.backgroundGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightTeal,
      appBar: AppBar(
        backgroundColor: AppColors.lightTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 100,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  'Quick Sign Up',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Just pick a username and get started!',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                Image.asset(
                  'assets/images/landing.png',
                  height: 200,
                ),
                const SizedBox(height: 48),
                _buildUsernameField(),
                const SizedBox(height: 24),
                _buildInfoCard(),
                const SizedBox(height: 48),
                _buildContinueButton(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextField(
      controller: _usernameController,
      decoration: const InputDecoration(
        hintText: 'Choose a username',
        prefixIcon: Icon(Icons.person, color: AppColors.mintGreen),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.mintGreen),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: AppColors.mintGreen, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
      ),
      maxLength: 20,
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mintGreen.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.check_circle_outline, 'No email or password needed'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.cloud_upload_outlined, 'Your data is saved in the cloud'),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.security_outlined, 'Add email later for account recovery'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.black,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signUpWithUsername,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mintGreen,
          foregroundColor: AppColors.black,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
              )
            : const Text('Get Started'),
      ),
    );
  }
}
