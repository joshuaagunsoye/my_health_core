import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/services/favorites_service.dart';

class UEqualsUPage extends StatefulWidget {
  @override
  _UEqualsUPageState createState() => _UEqualsUPageState();
}

class _UEqualsUPageState extends State<UEqualsUPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final isFav = await FavoritesService.isFavorited('u_equals_u');
    setState(() => _isFavorited = isFav);
  }

  Future<void> _toggleFavorite() async {
    final item = FavoriteItem(
      id: 'u_equals_u',
      title: 'Undetectable = Untransmittable (U=U)',
      route: '/u_equals_u',
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

  final Uri _catiePowerUrl = Uri.parse('https://www.catie.ca/essentials/u-equals-u');

  final List<Question> _questions = [
    Question(
      id: '1',
      title: 'What does "U = U" stand for?',
      options: {
        'Undiagnosed equals untreated': false,
        'Undetectable equals untransmittable': true,
        'Unmedicated equals unsafe': false,
        'Undetected equals unknown': false,
      },
    ),
    Question(
      id: '2',
      title: 'What does it mean to have an undetectable viral load?',
      options: {
        'HIV has been cured': false,
        'HIV is no longer in the body': false,
        'The amount of HIV in the blood is very low due to treatment': true,
        'HIV is inactive without medication': false,
      },
    ),
    Question(
      id: '3',
      title: 'How can someone know if their viral load is undetectable?',
      options: {
        'By how they feel physically': false,
        'By counting missed doses': false,
        'By having regular viral load blood tests': true,
        'By waiting for symptoms': false,
      },
    ),
    Question(
      id: '4',
      title: 'When someone maintains an undetectable viral load, what does the evidence show?',
      options: {
        'They may still transmit HIV through sex': false,
        'They cannot transmit HIV through sex': true,
        'They can only transmit HIV without condoms': false,
        'Transmission depends on gender': false,
      },
    ),
    Question(
      id: '5',
      title: 'Which statement about U = U is true?',
      options: {
        'U = U only applies to certain types of sex': false,
        'U = U depends on sexual orientation': false,
        'U = U applies regardless of gender or sexual orientation': true,
        'U = U only applies when condoms are used': false,
      },
    ),
  ];

  final List<Question> _retakeQuestions = [
    Question(
      id: 'r1',
      title: 'What helps someone maintain an undetectable viral load over time?',
      options: {
        'Taking medication occasionally': false,
        'Taking HIV medication as prescribed and staying in care': true,
        'Avoiding all sexual activity': false,
        'Using condoms only': false,
      },
    ),
    Question(
      id: 'r2',
      title: 'What does U = U mean for pregnancy and childbirth?',
      options: {
        'HIV is always passed to the baby': false,
        'Transmission can occur even with treatment': false,
        'HIV is not transmitted during pregnancy or delivery when viral load is undetectable': true,
        'Treatment must be stopped during pregnancy': false,
      },
    ),
    Question(
      id: 'r3',
      title: 'Which statement about breastfeeding and U = U is correct?',
      options: {
        'HIV transmission through breastfeeding is impossible': false,
        'HIV transmission through breastfeeding is greatly reduced but still possible': true,
        'Breastfeeding always leads to HIV transmission': false,
        'U = U does not apply during breastfeeding': false,
      },
    ),
    Question(
      id: 'r4',
      title: 'Why is it still recommended to use new needles every time, even with an undetectable viral load?',
      options: {
        'U = U does not apply to HIV': false,
        'To prevent HIV and other conditions like hepatitis B and C': true,
        'Because treatment stops working otherwise': false,
        'To increase the effect of substances': false,
      },
    ),
    Question(
      id: 'r5',
      title: 'What does U = U mean for other sexually transmitted infections (STIs)?',
      options: {
        'It prevents all STIs': false,
        'It prevents bacterial infections only': false,
        'It does not prevent other STIs': true,
        'It replaces the need for condoms': false,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('U=U', context: context),
      backgroundColor: AppColors.lightTeal,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonWidgets.buildMainHeading('Undetectable = Untransmittable (U=U)'),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What is U = U?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'U = U stands for "Undetectable equals Untransmittable". What does this mean? It means that people with an undetectable viral load cannot pass on HIV. This is because HIV treatment can reduce the amount of HIV (known as the viral load) in the blood and other bodily fluids to undetectable levels.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What does "undetectable" mean?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'To get your viral load to undetectable levels (and keep it there) you need to take your HIV meds as prescribed and see your healthcare provider regularly. The only way to know if your viral load is undetectable is to regularly have a blood test called a viral load test. You and your healthcare provider will decide how often you should have a viral load test (probably every three to six months). If you do not have a healthcare provider, your local HIV organization may be able to help you get connected with one.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What does "untransmittable" mean?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'When you maintain an undetectable viral load, you cannot pass HIV to the people you have sex with. This is true no matter what kinds of sex you are having, and no matter your gender or sexual orientation. It is also true whether or not a condom is used.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Evidence shows that people living with HIV who are on treatment, engaged in care and have an ongoing undetectable viral load:',
              ),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Do not transmit HIV to their sexual partners',
                'Do not transmit HIV to their baby during pregnancy and delivery (if they maintain an undetectable viral load throughout pregnancy and childbirth)',
                'Have a greatly reduced chance of transmitting HIV through breastfeeding',
                'Have a reduced chance of transmitting HIV to people with whom they share injection drug use equipment; however, it is still recommended that people use new needles and all other equipment every time they use drugs, regardless of their HIV status or viral load, to prevent passing on HIV and other conditions like Hepatitis B and C',
              ]),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Having an undetectable viral load does not prevent other STIs (sexually transmitted infections), such as syphilis, chlamydia, herpes and gonorrhea. Condoms can reduce the risk of many STIs, so you might want to use condoms to help prevent STIs.',
              ),
              const SizedBox(height: 24),
              CommonWidgets.buildSourcesHeading('Sources'),
              CommonWidgets.buildHyperlink('CATIE - The Power of Undetectable', _catiePowerUrl, context),
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
