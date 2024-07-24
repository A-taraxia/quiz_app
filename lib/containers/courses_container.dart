import 'package:flutter/material.dart';
import 'package:quiz_app/models/course_model.dart';
import 'package:quiz_app/models/db_models.dart';
import 'package:quiz_app/models/level_model.dart';

class CoursesContainer extends StatefulWidget {
  const CoursesContainer({Key? key}) : super(key: key);

  @override
  _CoursesContainerState createState() => _CoursesContainerState();
}

class _CoursesContainerState extends State<CoursesContainer> {
  List<Level> _levels = [];
  List<bool> _isSelected = [];

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    final DBconnect dbConnect = DBconnect();
    List<Level> levels = await dbConnect.fetchLevels();

    setState(() {
      _levels = levels;
      _isSelected = List<bool>.filled(
        levels.expand((level) => level.courses).length,
        false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: ListView.builder(
        itemCount: _levels.length,
        itemBuilder: (context, levelIndex) {
          final level = _levels[levelIndex];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLevelLabel(context, level.title),
              ...level.courses.asMap().entries.map((entry) {
                int courseIndex = entry.key +
                    _levels
                        .sublist(0, levelIndex)
                        .expand((l) => l.courses)
                        .length;
                return _buildCourseCard(context, entry.value, courseIndex);
              }).toList(),
            ],
          );
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

  Widget _buildCourseCard(BuildContext context, Course course, int index) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          course.title,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Theme.of(context).colorScheme.secondary),
        ),
        subtitle: Text(
          course.description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: IgnorePointer(
          ignoring: true,
          child: Checkbox(
            value: _isSelected[index],
            onChanged: null,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(course: course),
            ),
          ).then((_) {
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
  final Course course;

  const DetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          course.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.description,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              course.content,
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
