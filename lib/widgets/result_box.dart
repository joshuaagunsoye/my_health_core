import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({
    Key? key,
    required this.result,
    required this.questionLength,
    required this.onPressed,
    this.onExploreMore,
    this.onBackToEducation,
  }) : super(key: key);

  final int result;
  final int questionLength;
  final VoidCallback onPressed;
  final VoidCallback? onExploreMore;
  final VoidCallback? onBackToEducation;

  String _getHeading(int score, int total) {
    if (score == total) {
      return 'Great job!';
    } else if (score == total - 1) {
      return 'Well done!';
    } else {
      return 'Keep learning!';
    }
  }

  String _getScoreMessage(int score, int total) {
    if (score == total) {
      return 'Congratulations for getting all the answers correct.';
    } else if (score == total - 1) {
      return 'You\'ve got a strong understanding of this topic.';
    } else {
      return 'Learning takes repetition. Keep exploring this topic and come back to the quiz.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.getBackgroundColor(context),
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.getTextColor(context)),
                      onPressed: onPressed,
                      iconSize: 28,
                    ),
                    Expanded(
                      child: Text(
                        'Results',
                        style: TextStyle(
                          color: AppColors.getTextColor(context),
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
                const SizedBox(height: 30.0),
                Text(
                  'You scored:',
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 22.0,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  '$result/$questionLength',
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20.0),
                Image.asset(
                  'assets/images/quizscore.png',
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20.0),
                Text(
                  _getHeading(result, questionLength),
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12.0),
                Text(
                  _getScoreMessage(result, questionLength),
                  style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 18.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30.0),
                if (result == questionLength) ...[
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onExploreMore ?? onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getButtonColor(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Explore More Content',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: onBackToEducation ?? onPressed,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.getButtonColor(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Back to MyHealthEducation',
                        style: TextStyle(
                          color: AppColors.getButtonColor(context),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ] else
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.getButtonColor(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        'Do Another Quiz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
