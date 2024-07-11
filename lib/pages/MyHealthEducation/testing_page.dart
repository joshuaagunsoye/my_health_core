// testing_page.dart
// ignore_for_file: prefer_const_constructors, unused_element, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_health_core/models/question_model.dart';

class TestingPage extends StatelessWidget {
  final Uri _bwvPreventionAndTestingUrl =
      Uri.parse('https://www.bwvisions.ca/prevention-and-testing');
  final Uri _bioLytical =
      Uri.parse('https://shop.insti.com/insti-hiv-self-test');

  // Function to handle launching URLs
  void _launchUrl(BuildContext context, Uri url) async {
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch the link.')),
      );
    }
  }
  final List<Question> testingQuestions = [
    Question(
      id: '1',
      title: 'What does HIV stand for11?',
      options: {
        'Human Immunodeficiency Virus': true,
        'Human Immune Virus ': false,
        'Human Infectious Virus': false,
        'Human Immunization Virus': false,
      },
    ),
    Question(
      id: '2',
      title: 'HIV can be passed on through which of the following fluids?',
      options: {
        'Blood': true,
        'Saliva': false,
        'Sweat': false,
        'Tears': false,
      },
    ),
    Question(
      id: '3',
      title: 'HIV cannot be passed on through which of the following activities?',
      options: {
        'Sharing needles': false,
        'Hugging': true,
        'Breastfeeding': false,
        'Sexual intercourse': false,
      },
    ),
    Question(
      id: '4',
      title: 'Which of the following is NOT a way HIV can be passed?',
      options: {
        'Through broken skin': false,
        'Through the opening of the penis': false,
        'Through swimming pools ': true,
        'Through the wet linings of the body ': false,
      },
    ),
    Question(
      id: '5',
      title: 'Can HIV be passed by sharing a toilet seat with someone who has HIV?',
      options: {
        'Yes': false,
        'No': true,
      },
    )
  ];

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
                'HIV Testing',
              ),
              SizedBox(height: 16),
              CommonWidgets.buildHeading(
                'What are the different ways to test for HIV?',
              ),
              CommonWidgets.buildTestingMethodSection(
                context,
                '1. Standard HIV Test',
                'The standard test is typically done at a sexual health clinic, walk-in clinic or a family doctor’s office. Blood is drawn from a vein and sent to a lab where it can take up to 2 weeks to get a result.',
              ),
              CommonWidgets.buildTestingMethodSection(
                context,
                '2. Rapid Point of Care (POC) HIV Test',
                'This test is typically done at a sexual health clinic, walk-in clinic or a family doctor’s office. Point-of-care tests can provide results within minutes (can be given the result of the test during the same visit). This test is done with a blood sample from a finger prick. A positive result on a rapid test must be followed by a confirmatory standard test. A negative test result means no further testing needs to be done.',
              ),
              CommonWidgets.buildTestingMethodSection(
                context,
                '3. INSTI HIV Self-Test',
                'If you’re hesitant about going into a clinic to be tested, this may be the best option for you. This is a screening test done with a blood sample from a finger prick that works by detecting HIV antibodies. It can take between 3 and 12 weeks for the test to be able to detect antibodies from the time a person was exposed to HIV. A self-test can be purchased online from the manufacturer, bioLytical(link below) for \$34.95 + tax. This test may also be available in some pharmacies.',
              ),
              CommonWidgets.buildTestingMethodSection(
                context,
                '4. GetaKit Self-Test',
                'GetaKit is a study about the mail-out delivery of free HIV self-test kits in Ontario. Select a site based on where you’re located and how you identify, register and get a free test sent to you. You must be over 16 years old to participate.',
              ),
              SizedBox(height: 30),
              CommonWidgets.buildSourcesHeading(
                'Sources',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildHyperlink(
                'Black Women’s Visions - Prevention and Testing',
                _bwvPreventionAndTestingUrl,
                context,
              ),
              CommonWidgets.buildHyperlink(
                'Self Test: bioLytical',
                _bioLytical,
                context,
              ),
            CommonWidgets.buildQuizLink(context, testingQuestions)
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
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }
}
