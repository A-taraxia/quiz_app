import 'course_model.dart';
import 'question_models.dart';

class Level {
  final String title;
  final List<Question> questions;
  final List<Course> courses;

  Level({
    required this.title,
    required this.questions,
    required this.courses,
  });
}
