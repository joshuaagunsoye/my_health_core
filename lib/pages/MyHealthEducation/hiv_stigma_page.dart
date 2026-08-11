// hiv_stigma_page.dart

import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/app_bottom_navigation_bar.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/services/favorites_service.dart';

class HIVStigmaPage extends StatefulWidget {
  @override
  _HIVStigmaPageState createState() => _HIVStigmaPageState();
}

class _HIVStigmaPageState extends State<HIVStigmaPage> {
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  Future<void> _checkIfFavorited() async {
    final isFav = await FavoritesService.isFavorited('hiv_stigma');
    setState(() => _isFavorited = isFav);
  }

  Future<void> _toggleFavorite() async {
    final item = FavoriteItem(
      id: 'hiv_stigma',
      title: 'Understanding HIV Stigma',
      route: '/hiv_stigma',
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
      title: 'What is HIV stigma?',
      options: {
        'Accurate information about HIV': false,
        'Being judged, blamed, or treated differently because of HIV': true,
        'A type of HIV prevention': false,
        'A medical diagnosis': false,
      },
    ),
    Question(
      id: '2',
      title: 'Which of the following can be part of HIV stigma?',
      options: {
        'Supportive healthcare': false,
        'Negative labels or stereotypes': true,
        'Access to prevention services': false,
        'Community-led programs': false,
      },
    ),
    Question(
      id: '3',
      title: 'HIV stigma often overlaps with which other forms of discrimination?',
      options: {
        'Only age-based discrimination': false,
        'Racism, sexism, homophobia, and transphobia': true,
        'Education level': false,
        'Income only': false,
      },
    ),
    Question(
      id: '4',
      title: 'How can HIV stigma affect people\'s health?',
      options: {
        'It encourages early testing': false,
        'It can prevent people from accessing care and support': true,
        'It improves mental wellbeing': false,
        'It has no effect on health': false,
      },
    ),
    Question(
      id: '5',
      title: 'Why do some people avoid HIV testing or care because of stigma?',
      options: {
        'They don\'t care about their health': false,
        'They fear judgment or being treated unfairly': true,
        'Services are not effective': false,
        'HIV is no longer a concern': false,
      },
    ),
  ];

  final List<Question> _retakeQuestions = [
    Question(
      id: 'r1',
      title: 'Which statement best describes how HIV stigma is reinforced?',
      options: {
        'Only by individual attitudes': false,
        'By systems as well as individuals': true,
        'Only through misinformation online': false,
        'By healthcare alone': false,
      },
    ),
    Question(
      id: 'r2',
      title: 'How can stigma make it harder for Black communities to access HIV care?',
      options: {
        'By increasing trust in institutions': false,
        'By discouraging open conversations and care-seeking': true,
        'By improving service availability': false,
        'By reducing myths about HIV': false,
      },
    ),
    Question(
      id: 'r3',
      title: 'What is one key part of culturally responsive HIV care?',
      options: {
        'Treating everyone exactly the same': false,
        'Centering lived experiences and cultural context': true,
        'Avoiding discussions about stigma': false,
        'Using medical language only': false,
      },
    ),
    Question(
      id: 'r4',
      title: 'Why is Black community leadership important in addressing HIV stigma?',
      options: {
        'It replaces healthcare systems': false,
        'It makes programs more relevant and trusted by Black communities': true,
        'It limits access to services for Black communities': false,
        'It focuses only on research': false,
      },
    ),
    Question(
      id: 'r5',
      title: 'Which approach helps reduce HIV stigma?',
      options: {
        'Blaming communities for health outcomes': false,
        'Ignoring cultural differences': false,
        'Highlighting strengths and addressing structural barriers': true,
        'Avoiding conversations about HIV': false,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('Understanding HIV Stigma', context: context),
      backgroundColor: AppColors.lightTeal,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonWidgets.buildMainHeading('Understanding HIV Stigma'),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('What is HIV stigma?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'HIV stigma happens when people are judged, blamed, or treated differently because of HIV. This can include negative labels or stereotypes, shame or fear around HIV, and discrimination in healthcare, workplaces, or communities.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'HIV stigma is not just about HIV itself. It often overlaps with racism, sexism, homophobia, transphobia, religious beliefs, and cultural expectations.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'HIV stigma can:',
              ),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Stop people from getting tested',
                'Delay treatment and care',
                'Spread misinformation and fear',
                'Harm mental, physical, and emotional wellbeing',
              ]),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('How does HIV stigma affect Black communities?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'HIV stigma is often reinforced by systems, not just people. For many Black communities, HIV stigma is shaped by multiple layers of discrimination. These experiences can make it harder to talk openly about HIV or sexual health, access testing, prevention services, or treatment, and trust healthcare providers or institutions.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Because of stigma, many people avoid care. They don\'t avoid seeking health support because they don\'t care about their health, but because they fear judgment, rejection, or being treated unfairly.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Healthcare, research, and public health systems have historically ignored or minimized Black experiences, focused on blame instead of support, and excluded Black communities from decision-making. These systems have sometimes treated Black communities as "problems" to be studied rather than partners with knowledge, leadership, and solutions.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('Why does cultural responsiveness in HIV prevention and care matter?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Culturally responsive care means that healthcare and HIV services respect people\'s lived experiences, recognize cultural values, beliefs, and histories, avoid stereotypes or assumptions, and provide information in accessible language and formats.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'For Black communities, this might include HIV information in multiple languages, programs designed for different age groups and identities, providers who understand how racism and stigma affect health, and services shaped by community voices, not imposed from outside.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'When care reflects people\'s realities, they are more likely to feel safe, respected, and supported.',
              ),
              const SizedBox(height: 16),
              CommonWidgets.buildHeading('How do Black communities address HIV stigma?'),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Black communities have long been leaders in HIV response, care, and advocacy. However, this leadership is often underfunded or overlooked. When Black communities lead, programs are more relevant, effective, and trusted.',
              ),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'Reducing HIV stigma requires:',
              ),
              const SizedBox(height: 8),
              ...CommonWidgets.buildBulletPoints([
                'Meaningful involvement of Black communities in research, policy, and programs',
                'Investment in Black-led organizations and services',
                'Respect for lived experience as expertise',
                'Moving away from language that blames communities and toward language that highlights strength, resilience, and structural barriers',
              ]),
              const SizedBox(height: 8),
              CommonWidgets.buildText(
                'When Black communities lead, programs are more relevant, effective, and trusted. When HIV prevention efforts are stigma-free, culturally responsive, and community-led, they help create safer spaces where everyone can take care of their health with dignity and respect.',
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
