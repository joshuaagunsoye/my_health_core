import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/widgets/question_widget.dart';
import 'package:my_health_core/widgets/next_button.dart';
import 'package:my_health_core/widgets/option_card.dart';
import 'package:my_health_core/widgets/result_box.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Question> _questions = [
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

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;

  void nextQuestion() {
    if (index == _questions.length - 1) {
      showResultBox();
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an option'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          ),
        );
      }
    }
  }

  void showResultBox() {
    showDialog(
      context: context,
      barrierDismissible: false ,
      builder: (ctx) => ResultBox(
        result: score,
        questionLength: _questions.length,
        onPressed: startOver,
      ),
    );
  }

  void checkAnswerAndUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
        if (value == true) {
          score++;
        }
        // Trigger result box immediately if it's the last question
        if (index == _questions.length - 1) {
          showResultBox();
        }
      });
    }
  }

  void startOver(){
    setState(() {
      index =0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: AppColors.primary,
        shadowColor: AppColors.primary,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              'Score: $score',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            QuestionWidget(
              indexAction: index,
              question: _questions[index].title,
              totalQuestions: _questions.length,
            ),
            const SizedBox(height: 25.0),
            for (int i = 0; i < _questions[index].options.length; i++)
              GestureDetector(
                onTap: () => checkAnswerAndUpdate(_questions[index].options.values.toList()[i]),
                child: OptionCard(
                  option: _questions[index].options.keys.toList()[i],
                  color: isPressed
                      ? _questions[index].options.values.toList()[i] == true
                      ? AppColors.correct
                      : AppColors.incorrect
                      : AppColors.white,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: index < _questions.length - 1
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(nextQuestion: nextQuestion),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
