// hiv_101_page.dart

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';

// Defines a stateless widget for displaying information about HIV basics.
class HIV101Page extends StatelessWidget {
  // URLs for educational resources on HIV.
  final Uri _bwvisionsUrl = Uri.parse('https://www.bwvisions.ca/sexual-health');
  final Uri _catieUrl = Uri.parse('https://www.catie.ca/essentials/hiv-basics');
  final Uri _catieUrlq = Uri.parse('https://www.facebook.com');
  final List<Question> hivQuestions = [
    Question(
      id: '1',
      title: 'What does HIV stand for?',
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
                'HIV 101',
              ),
              SizedBox(height: 16),
              CommonWidgets.buildHeading(
                'What is HIV?',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'Human immunodeficiency virus (HIV) is a virus that attacks and can weaken the immune system, which is the body’s built-in defence against disease and illness.',
              ),
              SizedBox(height: 24),
              CommonWidgets.buildHeading(
                'How does a person get HIV?',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'HIV is passed through body fluids (blood, semen, pre-cum, rectal fluid, vaginal fluid, breastmilk). HIV is most commonly passed through sex or by sharing needles or other drug use equipment.',
              ),
              SizedBox(height: 24),
              CommonWidgets.buildHeading(
                'HIV can also be passed:',
              ),
              SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'To a fetus or baby during pregnancy, birth, or breastfeeding',
                'By sharing needles or ink to get a tattoo',
                'By sharing needles or jewelry to get a body piercing',
                'By sharing acupuncture needles',
              ]),
              SizedBox(height: 24),
              CommonWidgets.buildHeading('HIV cannot be passed by:'),
              SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Shaking hands, working, or eating with someone who has HIV',
                'Hugs or kisses',
                'Coughs, sneezes, or spitting',
                'Swimming pools, toilet seats, or water fountains',
                'Insects or animals',
              ]),
              SizedBox(height: 30),
              // Source section header.
              CommonWidgets.buildSourcesHeading('Sources'),
              SizedBox(height: 8),
              // Links to external resources for more information.
              CommonWidgets.buildHyperlink(
                  'Black Women’s Visions - HIV and Sexual Health',
                  _bwvisionsUrl,
                  context),
              CommonWidgets.buildQuizLink(context, hivQuestions),
            ],
          ),
        ),
      ),
      // Floating action button to potentially save information or perform another action.

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // implement functionality to save the page content
        },
        backgroundColor: AppColors.beer,
        child: Icon(Icons.save, color: AppColors.white),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 0),
    );
  }
}
