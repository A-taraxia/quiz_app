import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/services/auth/auth_services.dart';

import '../components/result_box.dart';

class StarterPage extends StatefulWidget {
  final String nickname;

  const StarterPage({super.key, required this.nickname});

  @override
  _StarterPageState createState() => _StarterPageState();
}

class _StarterPageState extends State<StarterPage> {
  final String _databaseUrl =
      'https://quizapp-3b15c-default-rtdb.firebaseio.com/Starter Quiz.json';
  final AuthServices _authServices = AuthServices();
  Map<String, dynamic>? _quizData;
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedOption;
  bool _showAnswers = false;

  @override
  void initState() {
    super.initState();
    _fetchQuizData();
  }

  void _fetchQuizData() async {
    try {
      final response = await http.get(Uri.parse(_databaseUrl));

      if (response.statusCode == 200) {
        setState(() {
          _quizData = json.decode(response.body) as Map<String, dynamic>?;
        });
      } else {
        throw Exception('Failed to load quiz data');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load quiz data: $error')),
      );
    }
  }

  void _selectOption(String option, bool isCorrect) {
    if (!_showAnswers) {
      setState(() {
        _selectedOption = option;
        if (isCorrect) {
          _score++;
          _showAnswers = true;
        }
        _showAnswers = true; // Show all options when an option is selected
      });
    }
  }

  void _nextQuestion() {
    final questionsLength = (_quizData?['questions'] as List<dynamic>).length;

    if (_currentIndex == questionsLength - 1) {
      _updateUserLevel(); // Update user's level based on their score
      // Show result dialog if it's the last question
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return ResultBox(
            result: _score,
            questionLength: questionsLength,
            nickname: widget.nickname,
          );
        },
      );
    } else {
      if (_showAnswers) {
        setState(() {
          _currentIndex++;
          _selectedOption = null; // Clear selected option
          _showAnswers = false; // Hide answers for the next question
        });
      } else {
        // Show a SnackBar if no option has been selected yet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an option'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          ),
        );
      }
    }
  }

  void _updateUserLevel() async {
    String level;
    if (_score <= 2) {
      level = 'beginner';
    } else if (_score <= 4) {
      level = 'intermediate';
    } else if (_score <= 6) {
      level = 'advanced';
    } else if (_score <= 8) {
      level = 'expert';
    } else {
      level = 'master';
    }

    User? currentUser = _authServices.getCurrentUser();
    if (currentUser != null) {
      await _authServices.updateUserLevel(currentUser.uid, level);
    }
  }

  void _startOver() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedOption = null;
      _showAnswers = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_quizData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Starter Quiz'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    List<dynamic> questions = _quizData?['questions'] ?? [];
    var currentQuestion = questions[_currentIndex];
    var questionTitle = currentQuestion['title'];
    var options =
        (currentQuestion['options'] as Map<String, dynamic>).entries.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Starter Quiz'),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Text('Score: $_score', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentIndex + 1}/${questions.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Text(
              questionTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  var option = options[index].key;
                  var isCorrect = options[index].value as bool;

                  Color color;

                  if (_showAnswers) {
                    if (isCorrect) {
                      color = Colors.green; // Correct answer
                    } else if (option == _selectedOption) {
                      color = Colors.red; // Incorrect selected answer
                    } else {
                      color = Colors.grey[200]!; // Other answers
                    }
                  } else {
                    color = Colors
                        .grey[200]!; // Default color for unselected options
                  }

                  return GestureDetector(
                    onTap: () => _selectOption(option, isCorrect),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        option,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.purple, // Set the background color to purple
                ),
                child: Text(
                  _currentIndex < (questions.length - 1)
                      ? 'Next Question'
                      : 'Finish Quiz',
                  style: TextStyle(
                      color: Colors
                          .white), // Optional: Change text color to white for better contrast
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
