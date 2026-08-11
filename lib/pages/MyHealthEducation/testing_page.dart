// testing_page.dart
// ignore_for_file: prefer_const_constructors, unused_element, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/services/favorites_service.dart';

class TestingPage extends StatefulWidget {
  @override
  _TestingPageState createState() => _TestingPageState();
}

class _TestingPageState extends State<TestingPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final isFav = await FavoritesService.isFavorited('hiv_testing');
    setState(() => _isFavorited = isFav);
  }

  Future<void> _toggleFavorite() async {
    final item = FavoriteItem(
      id: 'hiv_testing',
      title: 'HIV Testing',
      route: '/testing',
      savedAt: DateTime.now(),
    );
    await FavoritesService.toggleFavorite(item);
    await _checkIfFavorited();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorited ? 'Added to favorites' : 'Removed from favorites'),
        backgroundColor: AppColors.myrtleGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }
  final Uri _catieMoreOptionsUrl = Uri.parse('https://www.catie.ca/essentials/more-options-testing');
  final Uri _catieTestingProcessUrl = Uri.parse('https://www.catie.ca/essentials/hiv-testing-process');
  final Uri _bioLytical = Uri.parse('https://shop.insti.com/insti-hiv-self-test');

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
      title: 'Which HIV test typically takes up to 2 weeks to get results and involves drawing blood from a vein?',
      options: {
        'Rapid Point of Care (POC) HIV Test': false,
        'Standard HIV Test': true,
        'Dried Blood Spot (DBS) Testing': false,
        'Oral HIV Testing': false,
      },
    ),
    Question(
      id: '2',
      title: 'Which HIV test uses a blood sample from a finger prick and provides results within minutes?',
      options: {
        'Rapid Point of Care (POC) HIV Test': true,
        'Standard HIV Test': false,
        'Dried Blood Spot (DBS) Testing': false,
        'Oral HIV Testing': false,
      },
    ),
    Question(
      id: '3',
      title: 'What makes anonymous HIV testing different from other testing options?',
      options: {
        'It gives faster results': false,
        'The test is done at home': false,
        'The person\'s name is not linked to the test': true,
        'It does not require blood': false,
      },
    ),
    Question(
      id: '4',
      title: 'Which HIV test involves using an oral swab and provides results in 20 to 40 minutes?',
      options: {
        'Rapid Point of Care (POC) HIV Test': false,
        'Standard HIV Test': false,
        'Dried Blood Spot (DBS) Testing': false,
        'Oral HIV Testing': true,
      },
    ),
    Question(
      id: '5',
      title: 'If a rapid point-of-care HIV test gives a positive result, what is the next step?',
      options: {
        'No further testing is needed': false,
        'Repeat the rapid test immediately': false,
        'Conduct a confirmatory standard test': true,
        'Wait for symptoms to appear': false,
      },
    ),
  ];

  final List<Question> testingRetakeQuestions = [
    Question(
      id: 'r1',
      title: 'Which statement about HIV testing confidentiality testing is true?',
      options: {
        'HIV test results are shared publicly': false,
        'HIV testing decisions and results are generally kept confidential': true,
        'Confidentiality does not apply to HIV testing': false,
        'Only anonymous tests are confidential': false,
      },
    ),
    Question(
      id: 'r2',
      title: 'Why is a confirmatory blood test needed after a positive rapid HIV test?',
      options: {
        'Rapid tests are only used for research': false,
        'A second test is needed to confirm the result': true,
        'Rapid tests always give false positives': false,
        'The test must be repeated every time': false,
      },
    ),
    Question(
      id: 'r3',
      title: 'Which HIV testing method can be especially useful in rural or remote communities?',
      options: {
        'Oral HIV self-testing': false,
        'Rapid point-of-care testing': false,
        'Dried blood spot testing': true,
        'Standard laboratory testing': false,
      },
    ),
    Question(
      id: 'r4',
      title: 'What is one feature of non-nominal HIV testing?',
      options: {
        'The test cannot be reported to public health': false,
        'The test is ordered using a code, initials, or an alias': true,
        'The test is always anonymous': false,
        'The test is only available online': false,
      },
    ),
    Question(
      id: 'r5',
      title: 'What is one reason someone might choose an HIV self-test?',
      options: {
        'It replaces all clinic-based testing': false,
        'It can offer more privacy and convenience': true,
        'It gives a final diagnosis on its own': false,
        'It works immediately after exposure': false,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('HIV Testing', context: context),
      backgroundColor: AppColors.lightTeal,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonWidgets.buildMainHeading('HIV Testing'),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What are the different ways to test for HIV?'),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Standard HIV Test'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'The standard test is typically done at a sexual health clinic, walk-in clinic or a family doctor\'s office. Blood is drawn from a vein and sent to a lab where it can take up to 2 weeks to get a result.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Rapid Point of Care (POC) HIV Test'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'This test is typically done at a sexual health clinic, walk-in clinic or a family doctor\'s office. Point-of-care tests can provide results within minutes (can be given the result of the test during the same visit). This test is done with a blood sample from a finger prick. A positive result on a rapid test must be followed by a confirmatory standard test. A negative test result means no further testing needs to be done.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Dried Blood Spot Testing'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Dried blood spot (DBS) testing uses a sample of blood from a finger prick that is collected as a blot on a card. The blood spot is dried at room temperature and mailed to a public health laboratory for screening and confirmatory testing. Currently, this collection technique is in limited use in Canada because only a few public health laboratories can process the DBS cards. DBS testing has the advantage of being able to be used in rural and remote areas because the samples are very stable once collected, and do not need to be refrigerated during transport. Dried blood spots can also be used to test for other blood-borne infections, including hepatitis B and hepatitis C.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Oral HIV Testing'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'The oral self-test is being studied in Canada in the hope that it will soon be approved. The OraQuick Oral HIV Test uses an oral swab rather than a finger prick to detect HIV. To conduct the test, a person swabs their upper and lower gums and inserts the swab into a testing device. Results are available in 20 to 40 minutes. The oral test is only a screening test, and a confirmatory blood test is required to confirm a positive test result. The advantage of the oral test is that a blood sample is not required to conduct the self-test, which may make it more acceptable to some people.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Is my HIV test kept confidential?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Your decision to get an HIV test and your HIV status are both confidential pieces of information, except in very rare cases. The maintenance of confidentiality is an important consideration for a person who has decided to be tested for HIV. As with all medical information, it is the responsibility of the health provider performing the testing to ensure that the confidentiality of the person being tested is maintained.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'There are very limited circumstances in which confidentiality may be broken without consent. For example, the law may require your personal information to be released or some information may be required to be released to public health.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What information is collected when I go for an HIV test?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'The information collected at your appointment depends on the type of test you agree to. There are three options for collecting information during a test: 1) Nominal testing, 2) non-nominal testing, and 3) anonymous testing.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Nominal Testing'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Nominal testing, or name-based testing, is available across Canada and often takes place within clinics, offices of healthcare providers and hospitals. When a person has a nominal HIV test, the HIV test is ordered using the person\'s name. If the test is positive, the result is reported to public health authorities using the person\'s name and the test result is also recorded in the healthcare record of the person being tested.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Non-nominal Testing'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Non-nominal, or non-identifying testing, is also available across Canada and often takes place within clinics and offices of healthcare providers. If a person has a non-nominal HIV test, the HIV test is ordered using a code or the person\'s initials or an alias (depending on the province/territory), not their full or partial name. If the test is positive, the result is reported to public health using the person\'s name in most (but not all) provinces. The test result is also recorded in the healthcare record of the person being tested.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Anonymous Testing'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Anonymous HIV testing is available in certain provinces and territories, but not all. This form of HIV testing offers the highest degree of confidentiality for the person being tested. The person does not have to give their name and the HIV test is carried out using a code that is not linked to the person\'s identity. Anonymous testing usually takes place in specialised clinics or other community-based venues.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'In most provinces or territories where anonymous testing is available, if an anonymous HIV test is positive, the testing laboratory notifies public health about the positive test result. The name and contact information for the individual being tested is not shared with public health (as they are not known). The HIV test result is not recorded on the healthcare record of the person being tested.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Where can I get an HIV test?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'You can get a standard HIV test at a sexual health clinic near you.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'If you\'re hesitant about going into a clinic to be tested, a rapid point-of-care test may be the best option for you.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'A self-test can be purchased online from the manufacturer, bioLytical for \$34.95 + tax. This test may also be available in some pharmacies. The rapid test is also available for free at some AIDS service locations.',
              ),
              const SizedBox(height: 24),
              CommonWidgets.buildSourcesHeading('Sources'),
              CommonWidgets.buildHyperlink('CATIE - More Options for Testing in Canada', _catieMoreOptionsUrl, context),
              CommonWidgets.buildHyperlink('CATIE - The HIV Testing Process', _catieTestingProcessUrl, context),
              CommonWidgets.buildHyperlink('Self Test: bioLytical', _bioLytical, context),
              CommonWidgets.buildQuizLink(context, testingQuestions, retakeQuestions: testingRetakeQuestions),
              const SizedBox(height: 16),
              Center(
                child: InkWell(
                  onTap: _toggleFavorite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Favourite this content',
                          style: TextStyle(
                            color: AppColors.getTextColor(context),
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorited ? Colors.red : AppColors.getTextColor(context),
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }
}
