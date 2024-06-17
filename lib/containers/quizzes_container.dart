import 'package:flutter/material.dart';
import 'package:quiz_app/components/next_button.dart';
import 'package:quiz_app/components/option_card.dart';
import 'package:quiz_app/components/question_widget.dart';
import 'package:quiz_app/models/question_models.dart';

class QuizzesContainer extends StatefulWidget {
  const QuizzesContainer({super.key});

  @override
  State<QuizzesContainer> createState() => _QuizzesContainerState();
}

class _QuizzesContainerState extends State<QuizzesContainer> {
  final List<Question> _questions = [
    Question(
        id: '10',
        title: '2+2=?',
        options: {'5': false, '30': false, '4': true, '10': false}),
    Question(
        id: '11',
        title: '2+5=?',
        options: {'7': true, '30': false, '4': false, '10': false}),
  ];

  int index = 0;

  void nextQuestion() {
    if (index == _questions.length - 1) {
      return;
    } else {
      setState(() {
        index++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: [
            QuestionWidget(
                question: _questions[index].title,
                indexAction: index,
                totalQuestions: _questions.length),
            Divider(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 25),
            for (int i = 0; i < _questions[index].options.length; i++)
              OptionCard(option: _questions[index].options.keys.toList()[i])
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
