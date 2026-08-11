import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/services/favorites_service.dart';

class CondomsPage extends StatefulWidget {
  @override
  _CondomsPageState createState() => _CondomsPageState();
}

class _CondomsPageState extends State<CondomsPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final isFav = await FavoritesService.isFavorited('condoms');
    setState(() => _isFavorited = isFav);
  }

  Future<void> _toggleFavorite() async {
    final item = FavoriteItem(
      id: 'condoms',
      title: 'Condoms',
      route: '/condoms',
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
  final Uri _beInTheKnowInternalUrl = Uri.parse('https://beintheknow.org/condoms/internal-condoms/');
  final Uri _beInTheKnowExternalUrl = Uri.parse('https://beintheknow.org/condoms/external-condoms/');

  final List<Question> _questions = [
    Question(
      id: '1',
      title: 'What is the main way condoms help prevent HIV?',
      options: {
        'By killing the virus': false,
        'By acting as a barrier that prevents body fluids from mixing': true,
        'By cleaning the genitals': false,
        'By increasing pleasure': false,
      },
    ),
    Question(
      id: '2',
      title: 'What should you use to help prevent condoms from breaking?',
      options: {
        'Petroleum jelly': false,
        'Baby oil': false,
        'Water-based or silicone-based lubricants': true,
        'Butter': false,
      },
    ),
    Question(
      id: '3',
      title: 'What is an internal condom?',
      options: {
        'A condom worn on the penis': false,
        'A condom inserted into the vagina or anus': true,
        'A condom used only by men': false,
        'A condom that sticks to the skin': false,
      },
    ),
    Question(
      id: '4',
      title: 'When should an external condom be put on?',
      options: {
        'After sex': false,
        'Just before ejaculation': false,
        'When the penis is hard, before any sexual activity': true,
        'Anytime during sex': false,
      },
    ),
    Question(
      id: '5',
      title: 'What should you do with a used condom?',
      options: {
        'Flush it down the toilet': false,
        'Reuse it if it looks fine': false,
        'Wrap it in a tissue and put it in the bin': true,
        'Throw it on the ground': false,
      },
    ),
  ];

  final List<Question> _retakeQuestions = [
    Question(
      id: 'r1',
      title: 'Why are condoms effective at preventing HIV?',
      options: {
        'They absorb HIV': false,
        'They prevent bodily fluids from entering the body': true,
        'They strengthen the immune system': false,
        'They reduce the need for testing': false,
      },
    ),
    Question(
      id: 'r2',
      title: 'Which statement about internal condoms is true?',
      options: {
        'They can only be used for vaginal sex': false,
        'They are worn on the penis': false,
        'They can be used for vaginal or anal sex': true,
        'They must be used with oil-based lubricants': false,
      },
    ),
    Question(
      id: 'r3',
      title: 'What helps condoms work best at preventing HIV?',
      options: {
        'Using the same condom more than once': false,
        'Putting the condom on halfway through sex': false,
        'Using a new condom correctly every time': true,
        'Using two condoms at the same time': false,
      },
    ),
    Question(
      id: 'r4',
      title: 'Which type of lubricant is recommended to use with condoms?',
      options: {
        'Oil-based lubricants': false,
        'Water-based or silicone-based lubricants': true,
        'Lotion or moisturizer': false,
        'Cooking oil': false,
      },
    ),
    Question(
      id: 'r5',
      title: 'What is a safe way to remove and dispose of a condom after sex?',
      options: {
        'Remove it later and reuse it': false,
        'Flush it down the toilet': false,
        'Wrap it and place it in the garbage': true,
        'Rinse it and throw it away': false,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('Condoms', context: context),
      backgroundColor: AppColors.lightTeal,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonWidgets.buildMainHeading('Condoms'),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What are they?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Condoms are thin pouches that keep sperm from getting into the vagina. Condoms work by keeping semen, or other fluids, from entering the vagina. The materials used to make most condoms (such as latex, nitrile, polyurethane and polyisoprene) do not let HIV pass through them.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Condoms act as a barrier to HIV infection by preventing the vagina, penis, rectum and mouth from being exposed to bodily fluids (such as semen, vaginal fluid and rectal fluid) that can contain HIV.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'There are two types of condoms, internal condoms and external condoms. The use of either of these types of condoms is a highly effective strategy to prevent passing on HIV and other infections. When condoms are used consistently and correctly the chances of passing on HIV is very low.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'You must use new external and internal condoms consistently and correctly for them to be effective. Using water-based or silicone-based lubricants helps ensure they do not break.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Internal condoms'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'An internal condom is inserted into the vagina. This is a pouch made of polyurethane or nitrile. The internal condom was designed for vaginal sex but can also be used for anal sex.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'The pouch is open at one end and closed at the other, with a flexible ring at both ends. The ring at the closed end is inserted into the vagina or anus to hold the condom in place. The ring at the open end of the pouch remains outside of the vagina or anus.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('How do I use internal condoms?'),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Don\'t start having sex until you put the condom in.',
                'Check it hasn\'t passed its expiry date.',
                'Carefully take the condom out of the packet. Don\'t use teeth or scissors as these can damage condoms.',
                'Squeeze the sides of the inner ring (by the closed end of the condom).',
                'Get into a comfortable position – try lying down or squatting and push the condom inside your vagina. The outer ring should stay outside with the rest as far in as possible.',
                'Use your hand to guide the penis into the condom.',
                'Keep the condom in the whole time you have sex.',
                'After sex, twist the outer ring and pull the condom out.',
                'Wrap the condom in a tissue and put it in the bin.',
              ]),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('External condoms'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'An external condom is worn on the penis. This is a sheath made from polyurethane, latex or polyisoprene, which covers the penis during sexual intercourse. They come in different sizes and should fit securely but not feel uncomfortable. If you are sensitive to rubber, you can get non-latex condoms.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('How do I use external condoms?'),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Put it on when the penis is hard, but before you start having sex.',
                'Check it hasn\'t passed its expiry date.',
                'Carefully take the condom out of the packet. Don\'t use teeth or scissors as these can damage condoms.',
                'Pinch the air out of the top.',
                'Check the condom is not inside out – the rim should be on the outside.',
                'Roll the condom down to the base of the penis.',
                'Keep the condom on until you finish having sex.',
                'When you finish, hold the condom down to the base of your penis while you withdraw.',
                'Wrap the condom in a tissue and put it in the bin.',
              ]),
              const SizedBox(height: 24),
              CommonWidgets.buildSourcesHeading('Sources'),
              CommonWidgets.buildHyperlink('CATIE - HIV Basics', _catieHivBasicsUrl, context),
              CommonWidgets.buildHyperlink('Be In The Know - Internal Condoms', _beInTheKnowInternalUrl, context),
              CommonWidgets.buildHyperlink('Be In The Know - External Condoms', _beInTheKnowExternalUrl, context),
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
