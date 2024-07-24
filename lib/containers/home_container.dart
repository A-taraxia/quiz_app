import 'package:flutter/material.dart';
import 'package:quiz_app/components/progress_bar.dart';
import 'package:quiz_app/pages/starter_page.dart';

class HomeContainer extends StatelessWidget {
  final String nickname;

  const HomeContainer({
    super.key,
    required this.nickname,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
          child: Text(
            'Hello, $nickname',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ProgressBar(),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StarterPage(nickname: nickname),
                ),
              );
            },
            child: const Text('Starter Quiz'),
          ),
        ),
      ],
    );
  }
}
