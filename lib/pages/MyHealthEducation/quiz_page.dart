import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/widgets/common_widgets.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/widgets/question_widget.dart';
import 'package:my_health_core/widgets/next_button.dart';
import 'package:my_health_core/widgets/option_card.dart';


class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Question> _questions = [
    Question(
      id: '1',
      title: 'What is 2+2?',
      options: {
        'Option 1': false,
        'Option 2': true,
        'Option 3': false,
        'Option 4': false,
      },
    ),
    Question(
      id: '2',
      title: 'What is 3+3?',
      options: {
        'Option A': true,
        'Option B': false,
        'Option C': false,
        'Option D': false,
      },
    ),
    // Add more questions here
  ];

  int index = 0;

  bool isPressed = false;

  void nextQuestion() {
    if (index ==_questions.length - 1){
      return;
    } else{
      if(isPressed){
      setState(() {
        index++;
        isPressed = false;
      });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an option'),behavior:
            SnackBarBehavior.floating, margin: EdgeInsets.symmetric(vertical: 20.0),)
        );
      }
    }
  }

  void changeColor() {
    setState(() {
      isPressed = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('Quiz'),
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
            for(int i = 0; i <_questions[index].options.length; i++)
              OptionCard(option: _questions[index].options.keys.toList()[i],
              color: isPressed ? _questions[index].options.values.toList()[i] == true
                  ? AppColors.correct : AppColors.incorrect : AppColors.white,
              onTap: changeColor,
              )
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
