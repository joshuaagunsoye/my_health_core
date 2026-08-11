// prep_page.dart

import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/services/favorites_service.dart';

class PrePPage extends StatefulWidget {
  @override
  _PrePPageState createState() => _PrePPageState();
}

class _PrePPageState extends State<PrePPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final isFav = await FavoritesService.isFavorited('prep');
    setState(() => _isFavorited = isFav);
  }

  Future<void> _toggleFavorite() async {
    final item = FavoriteItem(
      id: 'prep',
      title: 'PrEP',
      route: '/prep',
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
  final Uri _catieHivBasicsUrl = Uri.parse('https://www.catie.ca/essentials/hiv-basics');
  final Uri _prepClinicUrl = Uri.parse('https://www.prepclinic.ca/');
  final List<Question> prepQuestions = [
    Question(
      id: '1',
      title: 'What does "PrEP" stand for?',
      options: {
        'Pre-Exposure Prophylaxis': true,
        'Post-Exposure Protection': false,
        'Primary Exposure Prevention': false,
        'Preventive Exposure Program': false,
      },
    ),
    Question(
      id: '2',
      title: 'Who can use PrEP?',
      options: {
        'People living with HIV': false,
        'People who are HIV-negative': true,
        'Only people who inject drugs': false,
        'Only people in relationships with partners who have HIV': false,
      },
    ),
    Question(
      id: '3',
      title: 'How does PrEP work?',
      options: {
        'It kills HIV after infection': false,
        'It boosts the immune system': false,
        'It uses antiretroviral drugs to block HIV from taking hold': true,
        'It acts like a vaccine': false,
      },
    ),
    Question(
      id: '4',
      title: 'How often is oral PrEP usually taken?',
      options: {
        'Once a week': false,
        'Once every two weeks': false,
        'One tablet every day': true,
        'Only after sexual activity': false,
      },
    ),
    Question(
      id: '5',
      title: 'What is the main difference between PrEP and PEP?',
      options: {
        'PrEP is taken before exposure; PEP is taken after': true,
        'PEP is taken before exposure; PrEP is taken after': false,
        'They are identical medications': false,
        'Both are taken only once': false,
      },
    ),
  ];

  final List<Question> prepRetakeQuestions = [
    Question(
      id: 'r1',
      title: 'When is PrEP most effective at preventing HIV?',
      options: {
        'When it is taken only after sex': false,
        'When it is used consistently as prescribed': true,
        'When it is combined with antibiotics': false,
        'When it is taken sometimes': false,
      },
    ),
    Question(
      id: 'r2',
      title: 'Which of the following PrEP options are approved in Canada?',
      options: {
        'Only a daily pill': false,
        'Only a long-acting injection': false,
        'Pills and a long-acting injectable option': true,
        'A nasal spray': false,
      },
    ),
    Question(
      id: 'r3',
      title: 'What kind of medication is used in PrEP?',
      options: {
        'Antibiotics': false,
        'Antiretroviral medications': true,
        'Pain relievers': false,
        'Vaccines': false,
      },
    ),
    Question(
      id: 'r4',
      title: 'Why are regular medical appointments part of taking PrEP?',
      options: {
        'To confirm PrEP is still needed and to monitor health': true,
        'To increase the dose over time': false,
        'To test for viral load': false,
        'To stop PrEP after a short period': false,
      },
    ),
    Question(
      id: 'r5',
      title: 'Who should consider taking PrEP?',
      options: {
        'Anyone who is HIV positive': false,
        'People who are HIV negative and at risk of exposure': true,
        'Only people over 65': false,
        'Only healthcare workers': false,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightTeal,
      appBar: CommonWidgets.buildAppBar('My Health Education'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              CommonWidgets.buildMainHeading('PrEP'),
              SizedBox(height: 16),
              CommonWidgets.buildHeading('What is PrEP?'),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'PrEP is an acronym that stands for Pre-Exposure Prophylaxis. PrEP is an HIV prevention method that can be used by people who are HIV negative and at ongoing risk for HIV. It is a highly effective way to prevent HIV transmission when used consistently and correctly.',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'PrEP is available in pill form (also called oral PrEP) or as a long-acting injection. When PrEP is taken as prescribed, HIV transmission is very rare.',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'PrEP is not the same thing as post-exposure prophylaxis (PEP). PrEP is taken regularly before and after potential exposures to HIV, whereas PEP is taken for 28 days after a single potential exposure.',
              ),
              SizedBox(height: 16),
              CommonWidgets.buildHeading('What type of medication is found in PrEP?'),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'PrEP is a combination of two antiretrovirals. These are the same drugs used to treat people with HIV. They work by preventing HIV from being able to take hold in the body. The medications in PrEP are actually sometimes used as part of HIV treatment regimens as well (but can’t be used alone in treatment, only for prevention).',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'There are three types of PrEP approved by Health Canada, including two different pill formulations and one long-acting injectable option. Both PrEP pills contain two drugs. Injectable PrEP contains just one drug.',
              ),
              SizedBox(height: 16),
              CommonWidgets.buildHeading('How often do I have to take PrEP?'),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'PrEP medication is typically taken as one tablet every day. However, if you are a cis man or trans woman it may be prescribed On-Demand and taken just around the time of sexual activity. Individuals on daily PrEP will have maximum protection from vaginal sex at 21 days and anal sex at 7 days. The medication needs to be continued once daily as consistency determines the level of effectiveness.',
              ),
              SizedBox(height: 16),
              CommonWidgets.buildHeading('Are there any side effects?'),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'PrEP is generally well tolerated and side effects can include stomach upset, headache, or feeling tired. These symptoms usually improve or go away with use.',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'Rare potential side effects include impact on your kidney function but your prescriber will monitor this during regular bloodwork. Any changes are generally reversible upon stopping the medication. The other possible side effect is changes in bone mineral density (bone strength) which is generally minor and reversible upon discontinuation.',
              ),
              SizedBox(height: 16),
              CommonWidgets.buildHeading('How do I get on PrEP?'),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'Taking PrEP requires a prescription from a healthcare provider and attending regular medical appointments for monitoring and support.',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'Consider PrEP if any of the following apply to you:',
              ),
              SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'You don’t always use condoms (external or internal) when you have anal or vaginal sex and aren’t always certain of your partner’s HIV status.',
                'You’ve been diagnosed with a sexually transmitted infection in the last six months.',
                'You’re in a relationship with a partner living with HIV, but they are not undetectable.',
                'You are a person who injects drugs, or you’re in a sexual relationship with a person who injects drugs.',
              ]),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'Check out MyHealthLocator to find a PrEP clinic near you!',
              ),
              SizedBox(height: 16),
              CommonWidgets.buildHeading('How do I pay for PrEP?'),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'The cost of PrEP can be covered under most public and some private drug plans. For seniors over 65 years old, Ontarians 24 years and younger, Ontarians enrolled in Ontario Works, the Ontario Disability Support Program, home care or community care programs, the cost of PrEP is covered. If you do not fall into any of these categories, you may be eligible for the Trillium Drug Program.',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'The PrEPStart program provides 3 months of PrEP free for people who do not have a drug plan. It allows you to start PrEP right away and gives you three months to find the drug plan that’s right for you.',
              ),
              SizedBox(height: 8),
              CommonWidgets.buildText(
                'If you’re not in Ontario, navigate to MyHealthLocator to find out where to get PrEP near you.',
              ),
              SizedBox(height: 30),
              CommonWidgets.buildSourcesHeading('Sources'),
              CommonWidgets.buildHyperlink('CATIE - HIV Basics', _catieHivBasicsUrl, context),
              CommonWidgets.buildHyperlink('PrEP Clinic - All About PrEP Medication', _prepClinicUrl, context),
              CommonWidgets.buildQuizLink(context, prepQuestions, retakeQuestions: prepRetakeQuestions),
              SizedBox(height: 16),
              Center(
                child: InkWell(
                  onTap: _toggleFavorite,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
                        SizedBox(width: 8),
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
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(currentIndex: 1),
    );
  }
}
