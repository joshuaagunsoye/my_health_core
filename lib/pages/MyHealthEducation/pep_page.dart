import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/services/favorites_service.dart';

class PepPage extends StatefulWidget {
  @override
  _PepPageState createState() => _PepPageState();
}

class _PepPageState extends State<PepPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final isFav = await FavoritesService.isFavorited('pep');
    setState(() => _isFavorited = isFav);
  }

  Future<void> _toggleFavorite() async {
    final item = FavoriteItem(
      id: 'pep',
      title: 'PEP',
      route: '/pep',
      savedAt: DateTime.now(),
    );
    await FavoritesService.toggleFavorite(item);
    await _checkIfFavorited();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorited ? 'Added to favorites' : 'Removed from favorites'),
        backgroundColor: AppColors.myrtleGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  final Uri _catieHivBasicsUrl = Uri.parse('https://www.catie.ca/essentials/hiv-basics');

  final List<Question> _questions = [
    Question(
      id: '1',
      title: 'What does "PEP" stand for?',
      options: {
        'Pre-Exposure Protection': false,
        'Post-Exposure Prophylaxis': true,
        'Preventive Exposure Plan': false,
        'Primary Exposure Prevention': false,
      },
    ),
    Question(
      id: '2',
      title: 'When should PEP be started after a potential exposure to HIV?',
      options: {
        'Within 24 hours only': false,
        'Within 48 hours only': false,
        'Within 72 hours': true,
        'Anytime within one week': false,
      },
    ),
    Question(
      id: '3',
      title: 'How long is PEP usually taken for?',
      options: {
        'One day': false,
        'Seven days': false,
        'Fourteen days': false,
        'Twenty-eight days': true,
      },
    ),
    Question(
      id: '4',
      title: 'What is the main purpose of PEP?',
      options: {
        'To treat HIV': false,
        'To prevent HIV after a single potential exposure': true,
        'To replace condoms or PrEP': false,
        'To test for HIV': false,
      },
    ),
    Question(
      id: '5',
      title: 'Who can help decide whether PEP is right for someone?',
      options: {
        'A pharmacist only': false,
        'A friend or partner': false,
        'A doctor or nurse practitioner': true,
        'An online quiz': false,
      },
    ),
  ];

  final List<Question> _retakeQuestions = [
    Question(
      id: 'r1',
      title: 'Why is it important to start PEP as soon as possible after a potential exposure?',
      options: {
        'Because PEP works only on the first day': false,
        'Because earlier use increases how effective it can be': true,
        'Because PEP stops working after 24 hours': false,
        'Because HIV symptoms appear quickly': false,
      },
    ),
    Question(
      id: 'r2',
      title: 'How is PEP intended to be used?',
      options: {
        'As a daily HIV prevention method': false,
        'After every sexual encounter': false,
        'After a single accidental or unexpected exposure': true,
        'Only during pregnancy': false,
      },
    ),
    Question(
      id: 'r3',
      title: 'How is PEP different from PrEP?',
      options: {
        'PEP is taken before exposure; PrEP is taken after': false,
        'PEP is taken after exposure; PrEP is taken on an ongoing basis': true,
        'They are the same medication used the same way': false,
        'PEP is only for healthcare workers': false,
      },
    ),
    Question(
      id: 'r4',
      title: 'Which situation is an example of when PEP might be considered?',
      options: {
        'Having sex with a condom that did not break': false,
        'Taking PrEP as prescribed': false,
        'A needle-stick injury': true,
        'Getting an HIV test': false,
      },
    ),
    Question(
      id: 'r5',
      title: 'Which statement about PEP is true?',
      options: {
        'PEP can only be used by certain genders': false,
        'PEP cannot be used during pregnancy': false,
        'PEP can be used by people of all genders': true,
        'PEP interferes with hormone therapy': false,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('PEP', context: context),
      backgroundColor: AppColors.lightTeal,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonWidgets.buildMainHeading('PEP'),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What is PEP?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'PEP is an acronym that stands for Post Exposure Prophylaxis. PEP is an effective strategy that involves an HIV-negative person taking HIV medications within 72 hours of a potential exposure to reduce the risk of HIV infection. When taken as prescribed for 28 days, PEP is very effective at preventing HIV infection.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'PEP needs to be started as soon as possible (up to a maximum of 72 hours) after a potential exposure to HIV. The sooner PEP is started, the more likely it is to work. PEP is meant to be used to prevent HIV transmission from a single accidental exposure to HIV. PEP should not be used regularly as an HIV prevention strategy. If a person uses PEP more than once, they may be a good candidate for PrEP (pre-exposure prophylaxis).',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'PEP is not the same as PrEP, which involves taking two HIV medications on an ongoing basis.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Should I take PEP?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'If you have had a potential exposure to HIV within the last 72 hours, then PEP might be right for you. The sooner you start PEP, the more effective it is.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'PEP can be used after a potential exposure to HIV through sexual or injection drug use activities. This can include having unprotected sex (whether consensual or non-consensual), having a condom break during sex or sharing equipment used to inject drugs.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'PEP can also be used after a potential exposure to HIV at work, such as when a healthcare worker or emergency responder has an accidental needle-stick injury.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'A doctor or nurse practitioner will help you determine if you should start PEP, based on the nature of your exposure. It\'s important to be honest about your potential exposure so the healthcare provider can properly assess your risk. PEP is usually only recommended if the potential exposure carries a high or moderate chance of passing HIV.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'PEP can be used by people of all genders. Experts believe that PEP can effectively prevent HIV in trans people and that the drugs in PEP are unlikely to interfere with the hormones that some trans people take; however, this has not been well studied.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'PEP can be taken by pregnant people safely. Tell your doctor if you are pregnant or planning to have a baby so they can prescribe a drug combination that is safe for you. Breastfeeding (also called chestfeeding) is not recommended while taking PEP.',
              ),
              const SizedBox(height: 24),
              CommonWidgets.buildSourcesHeading('Sources'),
              CommonWidgets.buildHyperlink('CATIE - HIV Basics', _catieHivBasicsUrl, context),
              CommonWidgets.buildQuizLink(context, _questions, retakeQuestions: _retakeQuestions),
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
