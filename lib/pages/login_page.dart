import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:device_info_plus/device_info_plus.dart';

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
    final user = _auth.currentUser;
    if (user == null) return;

    final now = DateTime.now().toUtc();
    final today = DateTime(now.year, now.month, now.day);

    try {
      await _firestore.runTransaction((transaction) async {
        final userRef = _firestore.collection('users').doc(user.uid);
        final snapshot = await transaction.get(userRef);

        int currentStreak = 0;
        Timestamp? lastActive;
        bool documentExists = snapshot.exists;

        if (documentExists) {
          final data = snapshot.data() as Map<String, dynamic>? ?? {};
          lastActive = data['lastActiveDate'] as Timestamp?;
          currentStreak = (data['streak'] as int?) ?? 0;
        }

        // Calculate streak
        if (lastActive != null) {
          final lastDate = lastActive.toDate().toUtc();
          final lastActiveDate = DateTime(lastDate.year, lastDate.month, lastDate.day);
          final difference = today.difference(lastActiveDate).inDays;

          currentStreak = difference == 1 ? currentStreak + 1 : difference > 1 ? 0 : currentStreak;
        } else {
          // First time tracking activity
          currentStreak = 1;
        }

        final updateData = {
          'streak': currentStreak,
          'lastActiveDate': Timestamp.fromDate(today),
        };

        if (documentExists) {
          transaction.update(userRef, updateData);
        } else {
          transaction.set(userRef, updateData);
        }
      });

      await _scheduleStreakReminder();

    } catch (e) {
      print('Error updating streak: $e');
    }
  }

  Future<void> _scheduleStreakReminder() async {
    final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // Android 13+ Permission Check
    final androidPlugin = notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      final deviceInfoPlugin = DeviceInfoPlugin(); // Proper initialization
      final androidInfo = await deviceInfoPlugin.androidInfo; // Fixed line
      if (androidInfo.version.sdkInt >= 33) {
        final bool? hasPermission = await androidPlugin.requestExactAlarmsPermission();
        if (hasPermission != true) { // Check for null or false
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Exact alarm permission required for reminders'),
              ),
            );
          }
          return;
        }
      }
    }

    // Timezone Setup
    tz.initializeTimeZones();
    final location = tz.getLocation('America/Halifax');
    final now = tz.TZDateTime.now(location);

    // Calculate expiry time
    final streakExpiryTime = now.add(Duration(days: 1)).subtract(Duration(hours: 5));


    // Debug output
    print("Corrected scheduling time: $streakExpiryTime");

    // Cancel existing and schedule new
    await notificationsPlugin.cancel(1);
    await notificationsPlugin.zonedSchedule(
      1,
      'Save your streak!',
      'Your streak will expire in 5 hours. Take action now!',
      streakExpiryTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_channel',
          'Streak Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Please fill in both email and password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Show immediate notification
      await _showInstantNotification();

      await _updateStreak();
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _showSnackBar('An unexpected error occurred');
      print('Login error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showInstantNotification() async {
    final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

    if (await notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() == false) {
      await notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }

    await notificationsPlugin.show(
      0, // Notification ID
      'Login Successful!',
      'Welcome back to My Health Core!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'streak_channel', // Same channel as scheduled notifications
          'Streak Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  void _handleAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'Account not found for this email';
        break;
      case 'wrong-password':
      case 'invalid-credential':
        message = 'Incorrect password';
        break;
      case 'invalid-email':
        message = 'Invalid email format';
        break;
      case 'user-disabled':
        message = 'Account disabled';
        break;
      default:
        message = 'Login failed: ${e.message}';
    }
    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.backgroundGreen,
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightTeal,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Login',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

// 👇 Landing Image Here
                Image.asset(
                  'assets/images/landing.png',
                  height: 274,
                ),
                const SizedBox(height: 24),

                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                _buildForgotPasswordButton(),
                const SizedBox(height: 48),
                _buildLoginButton(),
                const SizedBox(height: 16),
                _buildSignupPrompt(),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        filled: true,
        fillColor: AppColors.white,
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        filled: true,
        fillColor: AppColors.white,
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, '/forget_password'),
        style: TextButton.styleFrom(foregroundColor: AppColors.black),
        child: const Text('Forgot Password?'),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _login,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mintGreen,
          foregroundColor: AppColors.black,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
        )
            : const Text('Login'),
      ),
    );
  }

  Widget _buildSignupPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account?",
          style: TextStyle(color: AppColors.black),
        ),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          style: TextButton.styleFrom(foregroundColor: AppColors.black),
          child: const Text(
            'Sign up!',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }
}