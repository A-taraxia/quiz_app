import 'package:flutter/material.dart';

class CoursesContainer extends StatefulWidget {
  const CoursesContainer({Key? key}) : super(key: key);

  @override
  _CoursesContainerState createState() => _CoursesContainerState();
}

class _CoursesContainerState extends State<CoursesContainer> {
  final List<Map<String, String>> _courses = [
    {
      'title': 'Course For Python 1',
      'description': 'A detailed introduction to Python programming for beginners.',
      'text': 'This course covers the basics of Python programming, including syntax, variables, and data types.',
      'level': 'Novice'
    },
    {
      'title': 'Course For Python 2',
      'description': 'A continuation of the introduction to Python programming.',
      'text': 'This course goes deeper into Python basics and introduces new concepts.',
      'level': 'Novice'
    },
    {
      'title': 'Course 1',
      'description': 'A description of what needs to be done for Course 2',
      'text': 'This course covers the intermediate topics of the subject, including practical exercises and examples.',
      'level': 'Advanced Beginner'
    },
    {
      'title': 'Course 2',
      'description': 'Another intermediate course for advanced beginners.',
      'text': 'This course includes more exercises and examples to build on intermediate topics.',
      'level': 'Advanced Beginner'
    },
    {
      'title': 'Course 1',
      'description': 'A description of what needs to be done for Course 3',
      'text': 'This course focuses on advanced techniques and applications in the field.',
      'level': 'Competence'
    },
    {
      'title': 'Course 1',
      'description': 'A description of what needs to be done for Course 4',
      'text': 'This course provides a comprehensive review of all topics covered in previous courses.',
      'level': 'Proficient'
    },
    {
      'title': 'Course 1',
      'description': 'A description of what needs to be done for Course 5',
      'text': 'This course provides a comprehensive review of all topics covered in previous courses.',
      'level': 'Expert'
    },
  ];

  late List<bool> _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = List<bool>.filled(_courses.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView.builder(
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          if (index == 0 || _courses[index]['level'] != _courses[index - 1]['level']) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLevelLabel(context, _courses[index]['level']!),
                _buildCourseCard(context, _courses[index], index),
              ],
            );
          } else {
            return _buildCourseCard(context, _courses[index], index);
          }
        },
      ),
    );
  }

  Widget _buildLevelLabel(BuildContext context, String level) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        level,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, String> course, int index) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          course['title']!,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        subtitle: Text(
          course['description']!,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: IgnorePointer(
          ignoring: true,
          child: Checkbox(
            value: _isSelected[index],
            onChanged: null, // Set to null to make the checkbox non-clickable
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(course: course),
            ),
          ).then((_) {
            // Check if the user has viewed the details
            if (ModalRoute.of(context)!.isCurrent) {
              setState(() {
                _isSelected[index] = true;
              });
            }
          });
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Map<String, String> course;

  const DetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          course['title']!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,  // Center the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course['description']!,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              course['text']!,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
