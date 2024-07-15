import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/widgets/question_widget.dart';
import 'package:my_health_core/widgets/next_button.dart';
import 'package:my_health_core/widgets/option_card.dart';
import 'package:my_health_core/widgets/result_box.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;

  QuizPage({required this.questions});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;

  void nextQuestion() {
    if (index == widget.questions.length - 1) {
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
      barrierDismissible: false,
      builder: (ctx) => ResultBox(
        result: score,
        questionLength: widget.questions.length,
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
        if (index == widget.questions.length - 1) {
          showResultBox();
        }
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
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
              question: widget.questions[index].title,
              totalQuestions: widget.questions.length,
            ),
            const SizedBox(height: 25.0),
            for (int i = 0; i < widget.questions[index].options.length; i++)
              GestureDetector(
                onTap: () => checkAnswerAndUpdate(widget.questions[index].options.values.toList()[i]),
                child: OptionCard(
                  option: widget.questions[index].options.keys.toList()[i],
                  color: isPressed
                      ? widget.questions[index].options.values.toList()[i] == true
                      ? AppColors.correct
                      : AppColors.incorrect
                      : AppColors.white,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: index < widget.questions.length - 1
          ? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(nextQuestion: nextQuestion),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
