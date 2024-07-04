import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {

  QuestionWidget({
    Key? key,
    required this.indexAction,
    required this.question,
    required this.totalQuestions,
  }) : super(key: key);

  final int indexAction;
  final String question;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    print('Building QuestionWidget for indexAction: $indexAction');
    print('Question: $question');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${indexAction + 1} of $totalQuestions: $question',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8.0),
      ],
    );
  }
}
