import 'package:flutter/material.dart';
import 'package:quiz_app/components/next_button.dart';
import 'package:quiz_app/components/option_card.dart';
import 'package:quiz_app/components/question_widget.dart';
import 'package:quiz_app/components/result_box.dart';
import 'package:quiz_app/models/question_models.dart';

class QuizzesContainer extends StatefulWidget {
  const QuizzesContainer({Key? key}) : super(key: key);

  @override
  State<QuizzesContainer> createState() => _QuizzesContainerState();
}

class _QuizzesContainerState extends State<QuizzesContainer> {
  final List<Question> _questions = [
    Question(
        title: '2 + 2 = ?',
        options: {'5': false, '30': false, '4': true, '10': false}),
    Question(
        title: '2 + 5 = ?',
        options: {'7': true, '30': false, '4': false, '10': false}),
  ];

  int index = 0;
  bool isPressed = false;
  int score = 0;

  void nextQuestion() {
    if (index == _questions.length - 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                result: score,
                questionLength: _questions.length,
                startOver: startOver,
              ));
    } else {
      if (isPressed) {
        setState(() {
          index++;
          isPressed = false; // Reset isPressed when moving to the next question
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
      body: Container(
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
              physics: NeverScrollableScrollPhysics(),
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
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(nextQuestion: nextQuestion),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
