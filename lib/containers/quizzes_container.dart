import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/components/next_button.dart';
import 'package:quiz_app/components/option_card.dart';
import 'package:quiz_app/components/question_widget.dart';
import 'package:quiz_app/components/result_box.dart';
import 'package:quiz_app/models/db_models.dart';
import 'package:quiz_app/models/question_models.dart';
import 'package:quiz_app/services/auth/auth_services.dart';

class QuizzesContainer extends StatefulWidget {
  final String levelKey;

  const QuizzesContainer({Key? key, required this.levelKey}) : super(key: key);

  @override
  State<QuizzesContainer> createState() => _QuizzesContainerState();
}

class _QuizzesContainerState extends State<QuizzesContainer> {
  late Future<List<Question>> _questionsFuture;
  List<Question> _questions = [];
  final DBconnect _dbConnect = DBconnect();
  final AuthServices _authServices = AuthServices();

  String? nickname;
  bool coursesCompleted = false;

  @override
  void initState() {
    super.initState();
    _fetchNickname();
    _checkCoursesAndFetchQuestions();
  }

  Future<void> _fetchNickname() async {
    nickname = await _authServices.getNickname();
    setState(() {});
  }

  Future<void> _checkCoursesAndFetchQuestions() async {
    User? user = _authServices.getCurrentUser();
    if (user != null) {
      Map<String, Map<String, bool>> userProgress =
          await _authServices.getUserProgress(user.uid);
      Map<String, bool>? levelProgress = userProgress[widget.levelKey];

      if (levelProgress != null &&
          levelProgress['0'] == true &&
          levelProgress['1'] == true) {
        setState(() {
          coursesCompleted = true;
          _questionsFuture = _fetchQuestionsForLevel(widget.levelKey);
        });
      } else {
        setState(() {
          coursesCompleted = false;
        });
        _showCourseIncompleteDialog();
      }
    }
  }

  Future<List<Question>> _fetchQuestionsForLevel(String levelKey) async {
    final level = await _dbConnect.fetchLevel(levelKey);
    return level.questions;
  }

  void _showCourseIncompleteDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Course Incomplete'),
            content: const Text(
                'Complete all courses of this level to access the quiz.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  int index = 0;
  bool isPressed = false;
  int score = 0;

  void nextQuestion() async {
    if (index == _questions.length - 1) {
      try {
        // Save the quiz score to Firestore
        await _authServices.saveQuizScore(widget.levelKey, score);
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => ResultBox(
                  result: score,
                  questionLength: _questions.length,
                  startOver: startOver,
                  nickname: nickname ?? 'No nickname',
                ));
      } catch (e) {
        print('Error saving quiz score: $e');
      }
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please select an option'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        ));
      }
    }
  }

  void checkAnswerAndUpdate(bool value) {
    if (value) {
      score++;
    }
    setState(() {
      isPressed = true;
    });
  }

  void startOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Text('Score: $score', style: const TextStyle(fontSize: 18)),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: coursesCompleted
          ? FutureBuilder<List<Question>>(
              future: _questionsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No questions available.'));
                } else {
                  _questions = snapshot.data!;
                  return _buildQuizContent();
                }
              },
            )
          : Container(), // Do nothing and stay on the same page
      floatingActionButton: coursesCompleted
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: NextButton(nextQuestion: nextQuestion),
            )
          : null,
      floatingActionButtonLocation:
          coursesCompleted ? FloatingActionButtonLocation.centerFloat : null,
    );
  }

  Widget _buildQuizContent() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QuestionWidget(
            question: _questions[index].title,
            indexAction: index,
            totalQuestions: _questions.length,
          ),
          const SizedBox(height: 16),
          Divider(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _questions[index].options.length,
            itemBuilder: (context, i) {
              final option = _questions[index].options.keys.toList()[i];
              final isCorrect = _questions[index].options.values.toList()[i];
              return GestureDetector(
                onTap: () {
                  if (!isPressed) {
                    checkAnswerAndUpdate(isCorrect);
                  }
                },
                child: OptionCard(
                  option: option,
                  color: isPressed
                      ? isCorrect
                          ? Colors.green
                          : Colors.red
                      : Theme.of(context).colorScheme.onBackground,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
