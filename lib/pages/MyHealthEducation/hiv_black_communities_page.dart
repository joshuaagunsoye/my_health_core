import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/services/favorites_service.dart';

class HivBlackCommunitiesPage extends StatefulWidget {
  @override
  _HivBlackCommunitiesPageState createState() => _HivBlackCommunitiesPageState();
}

class _HivBlackCommunitiesPageState extends State<HivBlackCommunitiesPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final isFav = await FavoritesService.isFavorited('hiv_black_communities');
    setState(() => _isFavorited = isFav);
  }

  Future<void> _toggleFavorite() async {
    final item = FavoriteItem(
      id: 'hiv_black_communities',
      title: 'HIV and Black Communities',
      route: '/hiv_black_communities',
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

  final Uri _manifestoUrl = Uri.parse('https://www.example.com'); // Replace with real link if available

  final List<Question> _questions = [
    Question(
      id: '1',
      title: 'What does current data in Canada show about HIV and Black communities?',
      options: {
        'HIV affects all communities equally': false,
        'Black communities are less affected by HIV': false,
        'Black communities are more affected by HIV than many other groups': true,
        'HIV is no longer a concern in Canada': false,
      },
    ),
    Question(
      id: '2',
      title: 'Why are Black communities more affected by HIV in Canada?',
      options: {
        'Because of individual sexual choices': false,
        'Because of intersecting social and structural barriers and limited culturally relevant services': true,
        'Because HIV testing is not available': false,
        'Because prevention tools do not work': false,
      },
    ),
    Question(
      id: '3',
      title: 'What is meant by "structural racism"?',
      options: {
        'Discrimination by one individual': false,
        'Cultural traditions': false,
        'Systems and policies that do not treat everyone fairly': true,
        'Personal beliefs about health': false,
      },
    ),
    Question(
      id: '4',
      title: 'How can experiences of racism in healthcare affect HIV prevention?',
      options: {
        'They improve access to care': false,
        'They reduce trust and discourage people from seeking care': true,
        'They increase HIV testing rates': false,
        'They have no impact': false,
      },
    ),
    Question(
      id: '5',
      title: 'Which of the following is an example of a social determinant of health?',
      options: {
        'Viral load': false,
        'Medication type': false,
        'Housing and income': true,
        'HIV testing method': false,
      },
    ),
  ];

  final List<Question> _retakeQuestions = [
    Question(
      id: 'r1',
      title: 'Which statement best describes Black communities in Canada?',
      options: {
        'They are a single, uniform group': false,
        'They share the same culture and language': false,
        'They are diverse, with many identities and experiences': true,
        'They are not affected by HIV': false,
      },
    ),
    Question(
      id: 'r2',
      title: 'Why shouldn\'t HIV prevention focus only on individual behaviour?',
      options: {
        'Individual choices do not matter': false,
        'HIV is unavoidable': false,
        'Social and living conditions also affect access to prevention and care': true,
        'Prevention tools are ineffective': false,
      },
    ),
    Question(
      id: 'r3',
      title: 'How can HIV stigma affect people\'s health?',
      options: {
        'It encourages open conversations': false,
        'It reduces myths about HIV': false,
        'It can lead people to avoid testing or care': true,
        'It improves access to services': false,
      },
    ),
    Question(
      id: 'r4',
      title: 'Why are culturally responsive HIV services important?',
      options: {
        'They replace medical treatment': false,
        'They help ensure services reflect people\'s experiences and needs': true,
        'They are only for research': false,
        'They reduce the need for prevention': false,
      },
    ),
    Question(
      id: 'r5',
      title: 'What is one benefit of engaging in HIV prevention?',
      options: {
        'It limits access to care': false,
        'It increases stigma': false,
        'It supports informed choices and community health': true,
        'It focuses only on HIV treatment': false,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('HIV and Black Communities', context: context),
      backgroundColor: AppColors.lightTeal,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonWidgets.buildMainHeading('HIV and Black Communities'),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('How is HIV still affecting Black communities?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'In Canada, nearly 2,000 people were newly diagnosed with HIV in 2024. While not all provinces collect the same data, the information we do have shows that Black communities are more affected by HIV than many other groups.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Black people make up a small percentage of Canada\'s population, but they account for a much larger share of new HIV cases in some provinces. Black communities in Canada are also very diverse, with different cultures, languages, migration experiences, and identities. Despite this, their specific needs are often not fully reflected in health services.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Why are Black communities more affected by HIV?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Black communities in Canada are disproportionately affected by HIV due to intersecting social and structural determinants of health and a lack of culturally relevant services along the HIV continuum of prevention, testing, treatment and care. This is worsened by HIV-related stigma and discrimination toward communities affected by HIV.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Structural Racism and Healthcare'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Many of the challenges Black communities face around HIV are not about individual choices, but about how systems are set up. Structural racism means that policies, institutions, and systems like healthcare, housing, and employment, do not always treat everyone fairly. For Black communities, this can lead to:',
              ),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Difficulty accessing HIV testing, PrEP, and treatment',
                'Fewer culturally responsive healthcare services',
                'Experiences of racism or discrimination in medical settings',
              ]),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'These experiences can reduce trust in healthcare and make people less likely to seek care early or regularly.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Social Determinants of Health'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Health is shaped by more than doctors and clinics. The social determinants of health can impact one\'s health. These include things like:',
              ),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Income and job security',
                'Housing',
                'Education',
                'Food access',
                'Immigration status',
              ]),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'When these needs are not met, it can become harder to access HIV prevention tools, testing, and ongoing care. This is why HIV prevention shouldn\'t focus only on individual behaviour. It must also address the conditions people are living in.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('HIV Stigma in Black Communities'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'HIV stigma is still a major barrier. Stigma can come from fear or misinformation about HIV, cultural or religious beliefs, and racism, sexism, homophobia, or transphobia. This stigma can make it hard to talk openly about HIV, sex, and prevention. It can also lead to shame, isolation, and myths about how HIV is transmitted or treated. When people feel judged or unsafe, they may avoid testing or care, even when services are available.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Why HIV Prevention Still Matters'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'HIV prevention is about knowledge, access, and support. When Black communities have access to accurate information, culturally responsive care, and prevention tools like testing, PrEP, condoms, and harm reduction services, they can maintain their health.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Engaging in HIV prevention is important because it:',
              ),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Helps people stay healthy',
                'Reduces the transmission of HIV',
                'Supports informed choices',
                'Challenges stigma and misinformation about sexual health',
              ]),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Everyone deserves access to HIV prevention that respects their experiences, culture, and needs.',
              ),
              const SizedBox(height: 24),
              CommonWidgets.buildSourcesHeading('Sources'),
              CommonWidgets.buildHyperlink(
                'Owino et al - A Manifesto for Transformative Action to address HIV among Black Canadian Communities',
                _manifestoUrl,
                context,
              ),
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
