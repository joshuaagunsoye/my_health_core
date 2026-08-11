import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/services/favorites_service.dart';

class SaferSubstanceUsePage extends StatefulWidget {
  @override
  _SaferSubstanceUsePageState createState() => _SaferSubstanceUsePageState();
}

class _SaferSubstanceUsePageState extends State<SaferSubstanceUsePage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final isFav = await FavoritesService.isFavorited('safer_substance_use');
    setState(() => _isFavorited = isFav);
  }

  Future<void> _toggleFavorite() async {
    final item = FavoriteItem(
      id: 'safer_substance_use',
      title: 'Safer Substance Use',
      route: '/safer_substance_use',
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

  final Uri _catieSaferTipsUrl = Uri.parse('https://www.catie.ca/essentials/safer-using');
  final Uri _lakeheadUrl = Uri.parse('https://www.lakeheadu.ca/');

  final List<Question> _questions = [
    Question(
      id: '1',
      title: 'What is the main goal of safer substance use?',
      options: {
        'To stop people from using substances': false,
        'To reduce harm and the risk of transmitting conditions like HIV, Hepatitis B & C': true,
        'To monitor substance use': false,
        'To punish unsafe behaviour': false,
      },
    ),
    Question(
      id: '2',
      title: 'How can HIV be transmitted through substance use?',
      options: {
        'Through air when substances are smoked': false,
        'Through blood left in shared needles or equipment': true,
        'Through casual contact': false,
        'Through saliva': false,
      },
    ),
    Question(
      id: '3',
      title: 'What is one example of a harm reduction service?',
      options: {
        'Mandatory treatment programs': false,
        'Free syringe service programs': true,
        'Police enforcement of substance use': false,
        'Public punishment for substance use': false,
      },
    ),
    Question(
      id: '4',
      title: 'Why is using new needles and equipment every time important?',
      options: {
        'It improves the strength of substances': false,
        'It reduces the chances of passing on conditions like HIV, Hepatitis B & C': true,
        'It makes injection easier': false,
        'It prevents overdoses completely': false,
      },
    ),
    Question(
      id: '5',
      title: 'What is one way naloxone helps reduce harm?',
      options: {
        'It prevents HIV transmission': false,
        'It treats addiction': false,
        'It can reverse an opioid overdose': true,
        'It replaces emergency care': false,
      },
    ),
  ];

  final List<Question> _retakeQuestions = [
    Question(
      id: 'r1',
      title: 'What does "start low, go slow" mean when using substances?',
      options: {
        'Begin with a small amount to test the strength': true,
        'Save money by using less': false,
        'Share substances slowly with others': false,
        'Avoid drinking water while using': false,
      },
    ),
    Question(
      id: 'r2',
      title: 'Why can sharing injection or smoking equipment increase the chances of passing on HIV?',
      options: {
        'Equipment absorbs HIV from the air': false,
        'Small amounts of blood can remain on used supplies': true,
        'HIV spreads through heat': false,
        'Sharing causes HIV to be passed immediately': false,
      },
    ),
    Question(
      id: 'r3',
      title: 'Which practice helps reduce harm when injecting substances?',
      options: {
        'Using the same supplies to save time': false,
        'Cleaning the injection site before injecting': true,
        'Injecting into any vein available': false,
        'Skipping alcohol swabs': false,
      },
    ),
    Question(
      id: 'r4',
      title: 'What is the safest way to dispose of used needles?',
      options: {
        'Place them in a sharps container or hard plastic bottle': true,
        'Throw them in the regular trash': false,
        'Flush them down the toilet': false,
        'Leave them in a public place': false,
      },
    ),
    Question(
      id: 'r5',
      title: 'What should someone do if they notice a wound from substance use?',
      options: {
        'Ignore it if it\'s small': false,
        'Treat it on their own only': false,
        'Tell a healthcare provider or harm reduction worker': true,
        'Stop all substance use immediately': false,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('Safer Substance Use', context: context),
      backgroundColor: AppColors.lightTeal,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonWidgets.buildMainHeading('Safer Substance Use'),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What is "safer substance use"?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Safer substance use is defined as "having the ability to use safe and sterile instruments to reduce the risk of transmitting conditions like HIV, Hepatitis B & C from through recreational substance use".',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Safer substance use helps individuals to:',
              ),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Reduce the transmission of HIV, Hepatitis B & C from sharing equipment',
                'Provide education on the benefits of using new needles, smoking and other substance use equipment',
                'Reduce the number of overdoses and deaths from substance use',
                'Provide a supportive safe environment where individuals can access health, counselling',
              ]),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Safer substance use also connects with harm reduction, which is reducing the harm and negativity attached to substance abuse in our society. The main goal of harm reduction is to save lives and decrease the stigma around addiction, high education rates on safe substance use, and connect individuals with social, emotional, and health support options when needed. It is an adaptable approach to meeting community and individual needs.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What does harm reduction look like?'),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Free syringe service programs',
                'Sterile injection or smoking equipment',
                'Overdose prevention sites',
                'Substance testing',
                'Naloxone kits and training',
              ]),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('How is HIV transmitted through sharing substance use equipment?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'HIV can be passed through blood that remains in used needles or other substance injection equipment, even if the amount of blood is so small it can\'t be seen. Sharing needles or other equipment used to inject substances is the most common way that HIV is transmitted through broken skin. When a used needle containing blood with HIV breaks the skin of another person, HIV can get directly into their bloodstream. A larger amount of residual blood in the needle or other equipment and a higher amount of HIV in the blood can both increase the risk of HIV transmission.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('How can safer substance use prevent HIV transmission?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'To prevent the transmission of HIV when using substances:',
              ),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Keep naloxone with you: Know how to use naloxone, call 911 and give breaths. It can save a life.',
                'Avoid using alone.',
                'Be aware of unknown ingredients: Your supply may contain unexpected substances. If possible, get substances checked and stay informed about the local supply.',
                'Start low, go slow: Always begin with a small amount to see how strong the substance is.',
                'Dispose of supplies safely: Place used injecting or smoking supplies in a sharps container or hard plastic bottle and drop it off at a harm reduction service.',
                'Know your status: The only way to know if you have a STBBI is to get tested.',
                'Wound care: Tell a trusted healthcare provider or harm reduction worker about any wound you may have, no matter how small.',
                'Seek support: If you\'re looking to reduce or stop your substance use, reach out to a harm reduction worker or a healthcare provider for help.',
              ]),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('To prevent HIV when injecting substances'),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Use new supplies every time: Always use a new needle and syringe, cooker, filter, sterile water and alcohol swab with each injection.',
                'Never share injection supplies: Sharing equipment can pass HIV, Hepatitis B & C through small amounts of blood.',
                'Access new supplies: Contact a harm reduction worker to get new supplies.',
                'Clean your environment: Wash your hands and prep surfaces with soap and water or an alcohol swab. Clean the injection site with an alcohol swab before injecting to prevent transmitting HIV, Hepatitis B & C.',
                'Inject into a vein: Avoid injecting into arteries or surrounding tissue to prevent serious health issues, such as abscesses, scarring and skin infections.',
                'Choose the safest vein and rotate sites: The veins in your arms are the safest places to inject. Avoid using veins in your neck, face, wrist, groin or genitals. Rotate injection sites to help prevent vein damage and skin infections.',
                'Inject toward the heart: Insert the needle in the direction of the blood flowing back toward the heart, at a shallow angle and with the needle hole facing up. This will prevent complications, like vein damage.',
              ]),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('To prevent HIV when smoking substances'),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Access new supplies: Get safer smoking supplies, including straight stems or bowl pipes, mouthpieces, brass screens, wooden push sticks and alcohol swabs, from a harm reduction worker.',
                'Never share smoking supplies: Sharing equipment can pass HIV, Hepatitis B & C through small amounts of blood.',
                'Take care of your mouth: Use pipes and mouthpieces from a harm reduction service to prevent burns, sores and cuts.',
                'Clean your environment: Wash your hands and prep surfaces with soap and water or an alcohol swab before smoking.',
                'Use proper equipment: Avoid makeshift pipes, which can release harmful fumes or cause injuries. Avoid steel wool (Brillo), which can lead to inhalation of small hot fragments and burn the mouth and throat.',
                'Exhale immediately: Holding in the vapour can burn your lungs.',
                'Replace damaged supplies: A scratched, chipped, cracked or burnt pipe may lead to burns, blisters and cuts, increasing the chance of skin infections.',
              ]),
              const SizedBox(height: 24),
              CommonWidgets.buildSourcesHeading('Sources'),
              CommonWidgets.buildHyperlink('CATIE - Safer Injecting and Safer Smoking Tips', _catieSaferTipsUrl, context),
              CommonWidgets.buildHyperlink('Lakehead University - Safer Substance Use and Illicit Substances', _lakeheadUrl, context),
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
