import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_health_core/models/question_model.dart';

class TreatmentPage extends StatelessWidget {
  final Uri _url =
      Uri.parse('https://www.google.com');// Replace with your actual URL
  final List<Question> treatmentQuestions = [
    Question(
      id: '1',
      title: 'What is the main goal of HIV treatment?',
      options: {
        'To cure HIV ': false,
        'To stop the viral replication process and reduce the viral load to undetectable levels': true,
        'To manage HIV-related symptoms': false,
        'To temporarily suppress HIV': false,
      },
    ),
    Question(
      id: '2',
      title: 'How long does it typically take for HIV treatment to achieve an undetectable viral load?',
      options: {
        '1 week': false,
        '1 month': false,
        '3 to 6 months': true,
        '1 year ': false,
      },
    ),
    Question(
      id: '3',
      title: 'What are the benefits of early and ongoing HIV treatment?',
      options: {
        ' Shortens the lifespan of the individual  ': false,
        ' Reduces the risk of HIV transmission and improves the health and quality of life': true,
        'Increases the risk of side effects  ': false,
        'Only prevents HIV-related infections': false,
      },
    ),
    Question(
      id: '4',
      title: 'Which statement about HIV treatment side effects is correct?',
      options: {
        'All side effects are severe and permanent': false,
        'Side effects are generally mild, temporary, and less common with current HIV drugs': true,
        'Side effects do not occur with HIV treatment': false,
        'Side effects are unavoidable and cannot be managed': false,
      },
    ),
    Question(
      id: '5',
      title: 'What is the recommended timing for starting HIV treatment after diagnosis?',
      options: {
        'Only when symptoms develop': false,
        'As soon as possible after diagnosis': true,
        'When the viral load is high': false,
        'Only after consulting multiple specialists': false,
      },
    )
  ];

  // Function to handle launching URLs
  void _launchUrl(BuildContext context) async {
    try {
      if (!await launchUrl(_url)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch the link.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('My Health Education'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CommonWidgets.buildMainHeading(
                'Treatment',
              ),
              SizedBox(height: 16),
              Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Aliquam ac sapien eget elit semper porttitor sed vel orci. '
                'Ut suscipit, nulla nec ultricies interdum, purus dui dictum tellus, '
                'id commodo justo libero eget ante.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.bananaMania,
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Sources',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bananaMania,
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _launchUrl(context),
                child: Text(
                  'www.google.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.saffron,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              // Add more Text widgets for additional links as needed
              CommonWidgets.buildQuizLink(context, treatmentQuestions)

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement save functionality here
        },
        backgroundColor: AppColors.beer,
        child: Icon(Icons.save, color: AppColors.white),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }
}
