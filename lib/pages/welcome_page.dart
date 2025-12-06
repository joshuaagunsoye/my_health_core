import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              Text(
                'Welcome to',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextColor(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'MyHealth Core',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextColor(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                'Your mobile community resource for HIV prevention.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.getTextColor(context),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              Image.asset(
                'assets/images/peeps.png',
                height: 400,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.health_and_safety,
                    size: 160,
                    color: AppColors.getAccentColor(context),
                  );
                },
              ),

              const Spacer(flex: 2),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/onboarding');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.getButtonColor(context),
                    foregroundColor: AppColors.getTextColor(context),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
