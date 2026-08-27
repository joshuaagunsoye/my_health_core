import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';

class TermsAndConditionsPage extends StatefulWidget {
  const TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsPage> createState() => _TermsAndConditionsPageState();
}

class _TermsAndConditionsPageState extends State<TermsAndConditionsPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _termsContent = [
    'By using MyHealthCore, you agree to participate in a 7 day study where you’ll engage with the app for approximately 10 minutes per day. At the end of the study, you’ll be invited to complete a 10-minute evaluation survey. Please note that some content may cover sensitive topics such as HIV and sexual health.',
    'All of your data will remain anonymous and confidential. No personal identifying information will be collected or shared. Please do not enter any of your real health information, including your health card number or any medical records.',
    'The chat responses in MyHealthCore are computer-generated and not monitored by a real person. They are for educational purposes only and are not a substitute for professional medical advice, diagnosis, or treatment.',
    'If you have questions or concerns about your health, please contact a healthcare provider or clinic. If you are in crisis or feel unsafe, contact local emergency services or a crisis line immediately.',
    'For questions or concerns regarding the research study, please contact Kaminda at kaminda.musumbulwa@dal.ca.'
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Terms and Conditions',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextColor(context),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Image.asset(
                        'assets/images/terms.png',
                        height: (constraints.maxHeight * 0.25).clamp(120.0, 200.0),
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.privacy_tip,
                            size: 120,
                            color: AppColors.getAccentColor(context),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 150,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: _termsContent.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: _buildCarouselText(index),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _termsContent.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: _currentPage == index ? 24 : 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppColors.getAccentColor(context)
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
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
                            'I agree to the Terms and Conditions',
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
          },
        ),
      ),
    );
  }

  Widget _buildCarouselText(int index) {
    if (index == 0) {
      return Text(
        _termsContent[index],
        style: TextStyle(
          fontSize: 16,
          color: AppColors.getTextColor(context),
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      );
    } else {
      // Second slide with bold email
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontSize: 16,
            color: AppColors.getTextColor(context),
            height: 1.5,
          ),
          children: [
            const TextSpan(
              text: 'All of your data will remain anonymous—no personal identifying information will be collected or shared. For questions or concerns, contact Kaminda at ',
            ),
            TextSpan(
              text: 'kaminda.musumbulwa@dal.ca',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      );
    }
  }
}
