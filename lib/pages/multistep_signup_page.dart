import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiStepSignUpPage extends StatefulWidget {
  const MultiStepSignUpPage({Key? key}) : super(key: key);

  @override
  _MultiStepSignUpPageState createState() => _MultiStepSignUpPageState();
}

class _MultiStepSignUpPageState extends State<MultiStepSignUpPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  
  bool _isLoading = false;

  final List<String> _termsPages = [
    'By using MyHealthCore, you agree to participate in a 7 day study where you’ll engage with the app for approximately 10 minutes per day. At the end of the study, you’ll be invited to complete a 10-minute evaluation survey. Please note that some content may cover sensitive topics such as HIV and sexual health.',
    'All of your data will remain anonymous and confidential. No personal identifying information will be collected or shared. Please do not enter any of your real health information, including your health card number or any medical records.',
    'The chat responses in MyHealthCore are computer-generated and not monitored by a real person. They are for educational purposes only and are not a substitute for professional medical advice, diagnosis, or treatment.',
    'If you have questions or concerns about your health, please contact a healthcare provider or clinic. If you are in crisis or feel unsafe, contact local emergency services or a crisis line immediately.',
    'For questions or concerns regarding the research study, please contact Kaminda at kaminda.musumbulwa@dal.ca.'
  ];

  void _nextStep() {
    if (_currentStep < 7) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _validateEmail() {
    if (_emailController.text.isEmpty) {
      _showSnackBar('Please enter your email address');
      return false;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      _showSnackBar('Please enter a valid email address');
      return false;
    }
    return true;
  }

  bool _validatePassword() {
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Please enter a password');
      return false;
    }
    if (_passwordController.text.length < 8) {
      _showSnackBar('Use at least 8 characters and include a mix of letters, numbers, and symbols.');
      return false;
    }
    final hasUppercase = _passwordController.text.contains(RegExp(r'[A-Z]'));
    final hasLowercase = _passwordController.text.contains(RegExp(r'[a-z]'));
    final hasDigits = _passwordController.text.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = _passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
      _showSnackBar('Use at least 8 characters and include a mix of letters, numbers, and symbols.');
      return false;
    }
    return true;
  }

  bool _validateUsername() {
    if (_usernameController.text.isEmpty) {
      _showSnackBar('Please enter a username');
      return false;
    }
    if (_usernameController.text.length < 3) {
      _showSnackBar('Username must be at least 3 characters');
      return false;
    }
    return true;
  }

  Future<void> _completeSignUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        'username': _usernameController.text,
        'streak': 0,
        'lastActiveDate': Timestamp.now(),
        'email': _emailController.text.trim(),
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasCompletedOnboarding', false);

      Navigator.pushReplacementNamed(context, '/onboarding');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use. Please try another email.';
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
      appBar: _currentStep > 0
          ? AppBar(
              backgroundColor: AppColors.getBackgroundColor(context),
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColors.getTextColor(context),
                ),
                onPressed: _previousStep,
              ),
            )
          : null,
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildEmailStep(),
            _buildPasswordStep(),
            _buildUsernameStep(),
            ..._termsPages.asMap().entries.map((entry) => _buildTermsStep(entry.key, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Step 1 of 3: Enter your\nemail address',
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Register with your email for faster verification and password recovery.',
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use a valid email to help us confirm it\'s really you and secure your account.',
                    style: TextStyle(
                      color: AppColors.getTextColor(context).withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: AppColors.getTextColor(context)),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: AppColors.getTextColor(context).withOpacity(0.5)),
                      filled: true,
                      fillColor: AppColors.getSurfaceColor(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_validateEmail()) {
                          _nextStep();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getButtonColor(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLoginPrompt(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Step 2 of 3: Create a\npassword',
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Choose a strong password to keep your account secure.',
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Use at least 8 characters and include a mix of letters, numbers, and symbols.',
                    style: TextStyle(
                      color: AppColors.getTextColor(context).withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: AppColors.getTextColor(context)),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: AppColors.getTextColor(context).withOpacity(0.5)),
                      filled: true,
                      fillColor: AppColors.getSurfaceColor(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_validatePassword()) {
                          _nextStep();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getButtonColor(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLoginPrompt(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsernameStep() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Step 3 of 3: Pick a\nusername',
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Create a unique username that represents you.',
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your username will appear on your profile and can\'t be changed later.',
                    style: TextStyle(
                      color: AppColors.getTextColor(context).withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _usernameController,
                    style: TextStyle(color: AppColors.getTextColor(context)),
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: AppColors.getTextColor(context).withOpacity(0.5)),
                      filled: true,
                      fillColor: AppColors.getSurfaceColor(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_validateUsername()) {
                          _nextStep();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getButtonColor(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLoginPrompt(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: TextStyle(
            color: AppColors.getTextColor(context),
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/signin');
          },
          child: Text(
            'Log in',
            style: TextStyle(
              color: AppColors.getAccentColor(context),
              fontSize: 14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsStep(int index, String content) {
    bool isLastStep = index == _termsPages.length - 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Terms and Conditions',
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/images/terms.png',
                    height: (constraints.maxHeight * 0.25).clamp(120.0, 180.0),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    content,
                    style: TextStyle(
                      color: AppColors.getTextColor(context),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _termsPages.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == index
                              ? AppColors.getTextColor(context)
                              : AppColors.getTextColor(context).withOpacity(0.3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () {
                        if (isLastStep) {
                          _completeSignUp();
                        } else {
                          _nextStep();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getButtonColor(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.getTextColor(context)),
                            )
                          : Text(
                              isLastStep ? 'I agree to the Terms and Conditions' : 'Next',
                              style: TextStyle(
                                color: AppColors.getTextColor(context),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
