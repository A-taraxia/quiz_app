import 'course_model.dart';
import 'question_models.dart';

class Level {
  final String title;
  final String id;
  final List<Question> questions;
  final List<Course> courses;

  Level({
    required this.id,
    required this.title,
    required this.questions,
    required this.courses,
  });
}
