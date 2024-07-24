import 'package:flutter/material.dart';
import 'package:quiz_app/models/db_models.dart';
import 'package:quiz_app/models/level_model.dart';

import 'quizzes_container.dart';

class QuizMenu extends StatefulWidget {
  @override
  _QuizMenuState createState() => _QuizMenuState();
}

class _QuizMenuState extends State<QuizMenu> {
  late Future<List<Level>> futureLevels;
  final DBconnect dbConnect = DBconnect();

  @override
  void initState() {
    super.initState();
    futureLevels = dbConnect.fetchLevels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Levels'),
      ),
      body: FutureBuilder<List<Level>>(
        future: futureLevels,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No levels available.'));
          } else {
            final levels = snapshot.data!;
            return ListView.builder(
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return ListTile(
                  title: Text(level.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizzesContainer(levelKey: level.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
