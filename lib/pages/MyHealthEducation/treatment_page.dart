import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_health_core/models/question_model.dart';

class TreatmentPage extends StatelessWidget {
  final Uri _url =
      Uri.parse('https://www.catie.ca/hiv-treatment-1');// Replace with your actual URL
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
                'What is HIV Treatment',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'HIV treatment refers to medications that can keep HIV under control, '
                    'which allows a person with HIV to stay healthy and live a long and full life. '
                    'Our knowledge about HIV treatment and the medications involved have improved over time.'
                    ' Very effective HIV drugs that are easy to take and have few side effects are now available.',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'When HIV gets into the body, it targets and enters a type of immune cell called the CD4 cell '
                    'and it uses the cell to make copies of itself. This is called viral replication. '
                    'When new copies of the HIV virus are released from a CD4 cell, '
                    'this CD4 cell is destroyed and the virus goes on to infect other CD4 cells, '
                    'destroying those CD4 cells as well. HIV also alters the functioning of the immune system. '
                    'If HIV is left untreated, the virus keeps making copies of itself, the number of CD4 cells '
                    'in the body slowly decreases, and the immune system doesn’t work as it should. '
                    'The depletion of CD4 cells weakens the person’s immune system. '
                    'Eventually this leaves the body vulnerable to life-threatening infections and cancers.'
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'The goal of HIV treatment is to stop the viral replication process and '
                      'reduce the amount of virus in the body, also known as the viral load, '
                      'to undetectable levels. It usually takes three months or less to achieve '
                      'an undetectable viral load, but it can take as long as six months.'
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'HIV treatment does not cure HIV. '
                      'Even when the viral load is undetectable, HIV remains hidden in the body. '
                      'HIV treatment is a lifelong commitment that requires taking medication regularly, '
                      'exactly as prescribed. This is called adherence. Ongoing adherence to HIV treatment is '
                      'very important. Without enough medication in the blood to suppress the virus, HIV will '
                      'begin replicating again and spread throughout the body.'
              ),
              SizedBox(height: 24),
              CommonWidgets.buildHeading(
                'What are the benefits of HIV treatment?',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'The most important benefit of HIV treatment is an '
                      'improvement in the health and quality of life of a person living with HIV. '
                      'With ongoing treatment and care, most people living with HIV can stay healthy '
                      '(or return to health) and live a long, full life. By limiting HIV’s ability to'
                      ' replicate and lowering the amount of virus in a person’s body, HIV treatment '
                      'prevents further damage to the immune system. This allows the immune system to '
                      'stay strong. For people who have a weakened immune system as a result of late '
                      'diagnosis of HIV, ongoing treatment will allow the immune system to become '
                      'stronger and will dramatically reduce the risk of serious HIV-related infections. '
                      'HIV treatment also helps to lower the chance that people with HIV will develop'
                      ' other health conditions associated with a weakened immune system, such as certain '
                      'types of cancer. By starting treatment early, remaining in care and staying adherent to HIV drugs,'
                      ' most people with HIV can expect to have a normal lifespan and have a'
                      ' low risk of HIV-related complications. '
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'A second important benefit of HIV treatment is the prevention of HIV transmission.'
                      ' When people living with HIV are on HIV treatment, are engaged in '
                      'care and maintain an undetectable viral load:'
              ),
              SizedBox(height: 24),
              CommonWidgets.buildHeading(
                'When should HIV treatment be started?',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'People should start HIV treatment as soon as possible after diagnosis. '
                      'The earlier they start HIV treatment, the better their health outcomes. '
                      'HIV treatment prevents people from getting sick from HIV-related illnesses '
                      'and keeps them healthy over time.'
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'The decision to start treatment belongs to the person living with HIV.'
                      ' It is important that people are ready to make the commitment to taking HIV treatment on a'
                      ' regular basis, for life.'
              ),
              SizedBox(height: 24),
              CommonWidgets.buildHeading(
                'What types of drugs are used for HIV treatment?',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'A typical drug regimen usually consists of two or three drugs '
                      'formulated into a single pill and taken every day. However, '
                      'long-acting formulations of HIV drugs are also available. '
                      'These formulations are injected by a healthcare provider every one or two months.'
                      ' In the future there may be other long-acting options for treatment.'
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'There are several different groups, known as classes, of HIV drugs. '
                      'Each class attacks the virus at different points in its replication process.'
                      ' Entry inhibitors are a class of drugs that prevent HIV from entering a CD4 cell. '
                      'The other drug classes prevent HIV from replicating by blocking different enzymes '
                      'that are needed for HIV to replicate within a CD4 cell. These classes include '
                      'nucleoside analogues (nukes), non-nucleoside analogues (non-nukes), integrase '
                      'inhibitors, protease inhibitors and capsid inhibitors. New classes of HIV drugs'
                      ' are under development. A typical HIV treatment regimen includes drugs from at least two classes.'
              ),
              SizedBox(height: 24),
              CommonWidgets.buildHeading(
                'What are the side effects of HIV treatment?',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'Side effects of current HIV drugs are generally mild, '
                      'temporary and much less common than for older HIV drugs.'
                      ' Many people experience no side effects at all. '
                      'Some short-term side effects that may occur when '
                      'a person first starts treatment include nausea, headache, '
                      'diarrhea or difficulty sleeping. If side effects occur, '
                      'they tend to be mild to moderate in severity and disappear '
                      'after a few days or weeks. If necessary, most of these temporary '
                      'side effects can be managed with over-the-counter treatments '
                      '(e.g., taking ibuprofen for a headache) for a few days. The earlier '
                      'a person is diagnosed with HIV and the sooner they begin treatment, '
                      'the less likely they are to experience significant side effects from HIV treatment.'
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                  'It is important for a person to speak to their healthcare providers about '
                      'the symptoms they experience after starting HIV treatment. '
                      'If it is determined that a symptom is a side effect of HIV treatment,'
                      ' healthcare providers can work with the person to determine how best to address the issue.'
                      ' If necessary, healthcare providers may suggest ways to manage temporary side effects.'
                      ' In cases where side effects significantly affect a person’s '
                      'quality of life or do not go away over time, '
                      'healthcare providers may suggest changing the treatment to reduce side effects.'
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
                  'CATIE - HIV Treatment',
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
