import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    Key? key,
    required this.result,
    required this.questionLength,
    required this.onPressed,
  }) : super(key: key);

  final int result;
  final int questionLength;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.lightTeal,
      content: Padding(
        padding: const EdgeInsets.all(70.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Score',
              style: TextStyle(color: AppColors.black, fontSize: 22.0),
            ),
            const SizedBox(height: 20.0),
            CircleAvatar(
              child: Text(
                '$result/$questionLength',
                style: TextStyle(fontSize: 30.0),
              ),
              radius: 70.0,
              backgroundColor: result == questionLength / 2
                  ? AppColors.yellow
                  : result < questionLength / 2
                  ? AppColors.incorrect
                  : AppColors.correct,
            ),
            const SizedBox(height: 20.0),
            Text(
              result == questionLength / 2
                  ? 'Almost There'
                  : result < questionLength / 2
                  ? 'Give it another go!'
                  : 'Great!',
              style: const TextStyle(color: AppColors.black),
            ),
            const SizedBox(height: 25.0),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF94D1C5), // Hex color #94D1C5
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: GestureDetector(
                onTap: onPressed,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}