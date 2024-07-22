import 'package:quiz_app/models/course_model.dart';
import 'package:quiz_app/models/level_model.dart';
import 'package:quiz_app/models/question_models.dart';

List<Level> getLevels() {
  return [
    Level(
      title: 'Intermediate',
      questions: [
        Question(
          title:
              'What is the correct syntax for referring to an external script called "xxx.js"?',
          options: {
            '<script name="xxx.js">': false,
            '<script src="xxx.js">': true,
            '<script href="xxx.js">': false,
            '<script file="xxx.js">': false,
          },
        ),
        Question(
          title: 'How do you write "Hello World" in an alert box?',
          options: {
            'msg("Hello World");': false,
            'alertBox("Hello World");': false,
            'alert("Hello World");': true,
            'msgBox("Hello World");': false,
          },
        ),
      ],
      courses: [
        Course(
          title: 'Intermediate Javascript',
          description: 'This is an intermediate course',
          content: 'This is the content for intermediate learners',
        ),
        Course(
          title: 'Advanced Javascript Techniques',
          description: 'This is an advanced course',
          content: 'This is the content for advanced learners',
        ),
      ],
    ),
    Level(
      title: 'Beginner',
      questions: [
        Question(
          title: 'Inside which HTML element do we put the JavaScript?',
          options: {
            '<scripting>': false,
            '<script>': true,
            '<javascript>': false,
            '<js>': false,
          },
        ),
        Question(
          title: 'What does CSS stand for?',
          options: {
            'Colorful Style Sheets': false,
            'Creative Style Sheets': false,
            'Cascading Style Sheets': true,
            'Computer Style Sheets': false,
          },
        ),
      ],
      courses: [
        Course(
          title: 'Intro to Javascript',
          description: 'This is a course',
          content: 'This is the content you must learn',
        ),
        Course(
          title: 'Second lesson of Javascript',
          description: 'This is a second course',
          content: 'This is the content you must learn again',
        ),
      ],
    )
  ];
}
