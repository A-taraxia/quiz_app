import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz_app/models/course_model.dart';
import 'package:quiz_app/models/level_model.dart';
import 'package:quiz_app/models/question_models.dart';

class DBconnect {
  final url = Uri.parse(
      'https://quizapp-3b15c-default-rtdb.firebaseio.com/levels.json');
  final userProgressUrl = Uri.parse(
      'https://quizapp-3b15c-default-rtdb.firebaseio.com/users/userID/completedCourses.json');

  // Function to sanitize keys by replacing special characters
  String sanitizeKey(String key) {
    return key
        .replaceAll('<', '%3C')
        .replaceAll('>', '%3E')
        .replaceAll('.', '%2E')
        .replaceAll('\$', '%24')
        .replaceAll('[', '%5B')
        .replaceAll(']', '%5D')
        .replaceAll('#', '%23')
        .replaceAll('/', '%2F');
  }

  // Function to desanitize keys by replacing encoded characters with original characters
  String desanitizeKey(String key) {
    return key
        .replaceAll('%3C', '<')
        .replaceAll('%3E', '>')
        .replaceAll('%2E', '.')
        .replaceAll('%24', '\$')
        .replaceAll('%5B', '[')
        .replaceAll('%5D', ']')
        .replaceAll('%23', '#')
        .replaceAll('%2F', '/');
  }

  Future<void> addLevel(Level level) async {
    final levelData = {
      'title': level.title,
      'questions': level.questions
          .map((q) => {
                'title': q.title,
                'options': q.options.map((key, value) =>
                    MapEntry(sanitizeKey(key), value)), // Sanitize keys
              })
          .toList(),
      'courses': level.courses
          .map((c) => {
                'title': c.title,
                'description': c.description,
                'content': c.content,
              })
          .toList(),
    };

    final jsonData = json.encode(levelData);
    print('JSON Data: $jsonData'); // Print the JSON data for debugging

    final response = await http.post(url, body: jsonData);

    if (response.statusCode != 200) {
      print('Failed to add level: ${response.body}');
      throw Exception('Failed to add level');
    } else {
      print('Successfully added level: ${level.title}');
    }
  }

  Future<List<Level>> fetchLevels() async {
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load levels');
    }

    final Map<String, dynamic>? data = json.decode(response.body);
    List<Level> levels = [];

    if (data != null) {
      data.forEach((key, value) {
        final level = Level(
          id: value['id'],
          title: value['title'],
          questions: (value['questions'] as List<dynamic>).map((q) {
            return Question(
              title: q['title'],
              options: Map<String, bool>.from(
                  q['options'].map((k, v) => MapEntry(desanitizeKey(k), v))),
            );
          }).toList(),
          courses: (value['courses'] as List<dynamic>).map((c) {
            return Course(
              title: c['title'],
              description: c['description'],
              content: c['content'],
            );
          }).toList(),
        );

        levels.add(level);
      });
    }

    return levels;
  }

  Future<Level> fetchLevel(String levelKey) async {
    final sanitizedKey = sanitizeKey(levelKey);
    final levelUrl = Uri.parse(
        'https://quizapp-3b15c-default-rtdb.firebaseio.com/levels/$sanitizedKey.json');

    print('Fetching level data from: $levelUrl');
    final response = await http.get(levelUrl);

    if (response.statusCode != 200) {
      print('Failed to load level: ${response.statusCode}');
      throw Exception('Failed to load level');
    }

    final Map<String, dynamic>? data = json.decode(response.body);
    print('Fetched level data: $data');

    if (data == null) {
      throw Exception('Level data is null');
    }

    final level = Level(
      id: data['id'],
      title: data['title'],
      questions: (data['questions'] as List<dynamic>).map((q) {
        return Question(
          title: q['title'],
          options: Map<String, bool>.from(
              q['options'].map((k, v) => MapEntry(desanitizeKey(k), v))),
        );
      }).toList(),
      courses: (data['courses'] as List<dynamic>).map((c) {
        return Course(
          title: c['title'],
          description: c['description'],
          content: c['content'],
        );
      }).toList(),
    );

    return level;
  }
}
