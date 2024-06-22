import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quiz_app/models/question_models.dart';

class DBconnect {
  final url = Uri.parse(
      'https://fooddeliveryapp-7a68f-default-rtdb.europe-west1.firebasedatabase.app/qusetions.json');
  Future<void> addQuestion(Question question) async {
    http.post(url,
        body: json.encode({
          'title': question.title,
          'options': question.options,
        }));
  }
}
