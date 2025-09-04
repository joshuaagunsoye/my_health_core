import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/widgets/question_widget.dart';
import 'package:my_health_core/widgets/next_button.dart';
import 'package:my_health_core/widgets/option_card.dart';
import 'package:my_health_core/widgets/result_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;

  QuizPage({required this.questions});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0;
  int score = 0;
  int quizCount = 0;
  int? selectedOptionIndex;  // Track selected option index
  bool isSubmitted = false;  // Track submission state

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadQuizCount();
  }

  Future<void> _updateStreak() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    final DateTime now = DateTime.now().toUtc();
    final DateTime today = DateTime(now.year, now.month, now.day);

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentReference userRef = _firestore.collection('users').doc(user.uid);
        DocumentSnapshot snapshot = await transaction.get(userRef);

        if (snapshot.exists) {
          Timestamp? lastActive = snapshot['lastActiveDate'];
          int currentStreak = snapshot['streak'] ?? 0;

          if (lastActive != null) {
            DateTime lastDate = lastActive.toDate().toUtc();
            DateTime lastActiveDate = DateTime(lastDate.year, lastDate.month, lastDate.day);

            final difference = today.difference(lastActiveDate).inDays;

            if (difference == 1) {
              currentStreak++;
            } else if (difference > 1) {
              currentStreak = 0;
            }
          }

          transaction.update(userRef, {
            'streak': currentStreak,
            'lastActiveDate': Timestamp.fromDate(today),
          });
        }
      });
    } catch (e) {
      print('Error updating streak: $e');
    }
  }

  Future<void> _loadQuizCount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      var userData = await _firestore.collection('users').doc(user.uid).get();
      setState(() {
        quizCount = userData.data()?['quizCount'] ?? 0;
      });
    }
  }

  Future<void> _updateQuizCount() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
        await userDoc.update({
          'quizCount': FieldValue.increment(1),
        });
        // Update UI without fetching from Firestore
        setState(() {
          quizCount += 1;
        });
      } catch (e) {
      }
    } else {
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

  Color getOptionColor(int optionIndex) {
    if (isSubmitted) {
      bool isCorrect = widget.questions[index].options.values.toList()[optionIndex];
      if (isCorrect) return AppColors.correct;
      if (optionIndex == selectedOptionIndex) return AppColors.incorrect;
      return AppColors.white;
    }
    return optionIndex == selectedOptionIndex ? AppColors.selected : AppColors.white;
  }

  void handleNextQuestion() async {
    if (selectedOptionIndex == null && !isSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ),
      );
      return;
    }

    if (!isSubmitted) {
      // Validate answer and update score
      bool isCorrect = widget.questions[index].options.values.toList()[selectedOptionIndex!];
      if (isCorrect) score++;

      setState(() => isSubmitted = true);

      // Proceed after 1 second
      Future.delayed(const Duration(seconds: 1), () async {
        if (index < widget.questions.length - 1) {
          setState(() {
            index++;
            selectedOptionIndex = null;
            isSubmitted = false;
          });
        } else {
          try {
            await _updateQuizCount();
            await _updateStreak();
            showResultBox();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to save quiz progress. Please check your connection.'),
              ),
            );
            setState(() => isSubmitted = false);
          }
        }
      });
    }
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      selectedOptionIndex = null;
      isSubmitted = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: AppColors.mintGreen,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('Score: $score', style: const TextStyle(fontSize: 18.0)),
          ),
        ],
      ),
      backgroundColor: AppColors.lightTeal, // Added light teal background
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
                onTap: () {
                  if (!isSubmitted) {
                    setState(() => selectedOptionIndex = i);
                  }
                },
                child: OptionCard(
                  option: widget.questions[index].options.keys.toList()[i],
                  color: getOptionColor(i),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(
          nextQuestion: handleNextQuestion,
          label: isSubmitted ? 'Continue' : 'Next Question',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}