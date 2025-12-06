import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' ${indexAction + 1} of $totalQuestions:',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.getTextColor(context),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          question,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.getTextColor(context),
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}