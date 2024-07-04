import 'package:flutter/material.dart';
import 'package:my_health_core/common_widgets.dart';
import 'package:my_health_core/styles/app_colors.dart';

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.buildAppBar('Quiz'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'This is the quiz page!',
            style: TextStyle(
              fontSize: 24,
              color: AppColors.font,
            ),
          ),
        ),
      ),
    );
  }
}
