import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';

class NextButton extends StatelessWidget {
  final VoidCallback nextQuestion;
  final String label;  // Add this line

  const NextButton({
    Key? key,
    required this.nextQuestion,
    this.label = 'Next',  // Add this line with default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: nextQuestion,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        label,  // Use the label here
        style: const TextStyle(color: AppColors.white),
      ),
    );
  }
}
