import 'package:flutter/material.dart';
import 'package:my_health_core/styles/app_colors.dart';
import 'package:my_health_core/models/question_model.dart';
import 'package:my_health_core/widgets/option_card.dart';
import 'package:my_health_core/widgets/result_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizPage extends StatefulWidget {
  final List<Question> questions;
  final List<Question>? retakeQuestions;

  QuizPage({required this.questions, this.retakeQuestions});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int index = 0;
  int score = 0;
  int quizCount = 0;
  int? selectedOptionIndex;  // Track selected option index
  bool isSubmitted = false;  // Track submission state
  Map<int, int> savedAnswers = {};  // Save answers per question index
  List<Question>? _currentQuestions;
  List<Question> get currentQuestions => _currentQuestions ?? widget.questions;
  bool isRetake = false;
  Set<int> incorrectQuestionIndices = {};  // Track which questions were answered incorrectly

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _currentQuestions = widget.questions;
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
    if (user == null) return;
    var userData = await _firestore.collection('users').doc(user.uid).get();
    if (!mounted) return;
    setState(() {
      quizCount = userData.data()?['quizCount'] ?? 0;
    });
  }

  Future<void> _updateQuizCount() async {
    User? user = _auth.currentUser;
    if (user == null) return;
    try {
      DocumentReference userDoc = _firestore.collection('users').doc(user.uid);
      await userDoc.update({
        'quizCount': FieldValue.increment(1),
      });
      if (!mounted) return;
      // Update UI without fetching from Firestore
      setState(() {
        quizCount += 1;
      });
    } catch (e) {
    }
  }

  void showResultBox() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ResultBox(
        result: score,
        questionLength: currentQuestions.length,
        onPressed: startOver,
        onExploreMore: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/my_health_education');
        },
        onBackToEducation: () {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/my_health_education');
        },
      ),
    );
  }

  Color getOptionColor(int optionIndex) {
    if (isSubmitted) {
      bool isCorrect = currentQuestions[index].options.values.toList()[optionIndex];
      if (isCorrect) return AppColors.correct;
      if (optionIndex == selectedOptionIndex) return AppColors.incorrect;
      return AppColors.white;
    }
    return optionIndex == selectedOptionIndex ? AppColors.selected : AppColors.white;
  }

  int _calculateScore() {
    int total = 0;
    savedAnswers.forEach((questionIndex, answerIndex) {
      bool isCorrect = currentQuestions[questionIndex].options.values.toList()[answerIndex];
      if (isCorrect) total++;
    });
    return total;
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

    if (isSubmitted) {
      // Already answered, just move to next question
      if (index < currentQuestions.length - 1) {
        setState(() {
          index++;
          selectedOptionIndex = savedAnswers[index];
          isSubmitted = savedAnswers.containsKey(index);
        });
      } else {
        try {
          score = _calculateScore();
          await _updateQuizCount();
          await _updateStreak();
          showResultBox();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save quiz progress. Please check your connection.'),
            ),
          );
        }
      }
      return;
    }

    // Save the answer
    savedAnswers[index] = selectedOptionIndex!;
    score = _calculateScore();

    setState(() => isSubmitted = true);

    // Proceed after 1 second
    Future.delayed(const Duration(seconds: 1), () async {
      if (index < currentQuestions.length - 1) {
        setState(() {
          index++;
          selectedOptionIndex = savedAnswers[index];
          isSubmitted = savedAnswers.containsKey(index);
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

  List<Question> _buildRetakeQuestions() {
    if (widget.retakeQuestions == null || widget.retakeQuestions!.isEmpty) {
      return widget.questions;
    }

    List<Question> retakeQuestionList = [];
    int bankIndex = 0;

    // Go through original questions and replace correctly answered ones
    for (int i = 0; i < widget.questions.length; i++) {
      if (incorrectQuestionIndices.contains(i)) {
        // Keep the question they got wrong
        retakeQuestionList.add(widget.questions[i]);
      } else {
        // Replace with a new question from the bank
        if (bankIndex < widget.retakeQuestions!.length) {
          retakeQuestionList.add(widget.retakeQuestions![bankIndex]);
          bankIndex++;
        } else {
          // If we run out of bank questions, keep original
          retakeQuestionList.add(widget.questions[i]);
        }
      }
    }

    return retakeQuestionList;
  }

  void startOver() {
    // Close the dialog first
    Navigator.pop(context);
    
    setState(() {
      index = 0;
      score = 0;
      selectedOptionIndex = null;
      isSubmitted = false;
      
      // Build new question set before clearing answers
      if (widget.retakeQuestions != null && !isRetake) {
        // Track which questions were incorrect
        incorrectQuestionIndices.clear();
        savedAnswers.forEach((questionIndex, answerIndex) {
          bool isCorrect = currentQuestions[questionIndex].options.values.toList()[answerIndex];
          if (!isCorrect) {
            incorrectQuestionIndices.add(questionIndex);
          }
        });
        
        _currentQuestions = _buildRetakeQuestions();
        isRetake = true;
      } else {
        // Cycle back to original questions
        _currentQuestions = widget.questions;
        isRetake = false;
        incorrectQuestionIndices.clear();
      }
      
      savedAnswers.clear();
    });
  }

  void goToPreviousQuestion() {
    if (index > 0) {
      setState(() {
        index--;
        selectedOptionIndex = savedAnswers[index];
        isSubmitted = savedAnswers.containsKey(index);
      });
    } else {
      // If on first question, exit the quiz
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.getButtonColor(context),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/images/education.png',
              height: 40,
              width: 40,
            ),
            SizedBox(width: 8),
            Text(
              'MyHealthEducation',
              style: TextStyle(
                color: AppColors.getTextColor(context),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.getTextColor(context)),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Exit quiz',
          ),
        ],
      ),
      backgroundColor: AppColors.getBackgroundColor(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.getTextColor(context)),
                    onPressed: goToPreviousQuestion,
                    iconSize: 28,
                  ),
                  Expanded(
                    child: Text(
                      'Question ${index + 1} of ${currentQuestions.length}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 48), // Balance the row
                ],
              ),
              const SizedBox(height: 40.0),
              Text(
                currentQuestions[index].title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: AppColors.getTextColor(context),
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30.0),
              for (int i = 0; i < currentQuestions[index].options.length; i++)
                GestureDetector(
                  onTap: () {
                    if (!isSubmitted) {
                      setState(() => selectedOptionIndex = i);
                    }
                  },
                  child: OptionCard(
                    option: currentQuestions[index].options.keys.toList()[i],
                    color: getOptionColor(i),
                    optionLabel: String.fromCharCode(65 + i), // A, B, C, D
                    isSelected: i == selectedOptionIndex,
                  ),
                ),
              const SizedBox(height: 40.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: handleNextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.getButtonColor(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text(
                    'Next Question',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}