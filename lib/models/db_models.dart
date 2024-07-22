import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz_app/models/level_model.dart';

class DBconnect {
  final url = Uri.parse(
      'https://quizapp-3b15c-default-rtdb.firebaseio.com/levels.json');

  // Function to sanitize keys by replacing special characters
  String sanitizeKey(String key) {
    return key
        .replaceAll('<', '%3C')
        .replaceAll('>', '%3E')
        .replaceAll('.', '%2E')
        .replaceAll('\$', '%24')
        .replaceAll('[', '%5B')
        .replaceAll(']', '%5D')
        .replaceAll('#', '%23');
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
}
