import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  User? _currentUser;
  Map<String, Map<String, bool>> _userProgress = {};

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    _currentUser = AuthServices().getCurrentUser();
    if (_currentUser != null) {
      await _fetchCourses();
      await _fetchUserProgress();
      _updateSelection();
    }
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

  Future<void> _fetchUserProgress() async {
    if (_currentUser == null) return;

    final uid = _currentUser!.uid;
    _userProgress = await AuthServices().getUserProgress(uid);
  }

  void _updateSelection() {
    setState(() {
      int index = 0;
      for (var level in _levels) {
        final levelKey = level.id;
        for (var course in level.courses) {
          final courseKey = '$index';
          _isSelected[index] = _userProgress[levelKey]?[courseKey] ?? false;
          index++;
        }
      }
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
                return _buildCourseCard(
                    context, entry.value, courseIndex, level.id);
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

  Widget _buildCourseCard(
      BuildContext context, Course course, int index, String levelId) {
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
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(course: course),
            ),
          );

          if (ModalRoute.of(context)!.isCurrent) {
            setState(() {
              _isSelected[index] = true;
            });
            if (_currentUser != null) {
              await AuthServices()
                  .updateUserProgress(_currentUser!.uid, levelId, index);
            }
          }
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

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<Map<String, Map<String, bool>>> getUserProgress(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        final courses = userSnapshot.data()?['courses'] as Map<String, dynamic>;
        return courses.map((key, value) => MapEntry(
              key,
              (value as Map<String, dynamic>).map(
                (k, v) => MapEntry(k, v as bool),
              ),
            ));
      } else {
        return {};
      }
    } catch (e) {
      print('Error fetching user progress from Firestore: $e');
      return {};
    }
  }

  Future<void> updateUserProgress(
      String uid, String level, int courseId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(uid).get();

      Map<String, dynamic> userData;

      if (userDoc.exists) {
        userData = userDoc.data()!;
      } else {
        userData = {
          'uid': uid,
          'nickname': 'defaultNickname',
          'level': 'beginner',
          'courses': {},
          'quizzes': {
            '1Beginner': 0,
            '2Intermediate': 0,
            '3Advanced': 0,
            '4Expert': 0,
            '5Master': 0,
          },
        };
      }

      // Ensure the courses map exists
      if (!userData.containsKey('courses')) {
        userData['courses'] = {};
      }

      // Update the course completion status
      if (!userData['courses'].containsKey(level)) {
        userData['courses'][level] = {};
      }
      userData['courses'][level]['$courseId'] = true;

      // Save the updated data back to Firestore
      await _firestore.collection('users').doc(uid).set(userData);
    } catch (e) {
      print('Error updating user progress: $e');
    }
  }

  Future<String?> getNicknameFromFirestore(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('users').doc(uid).get();
      if (userSnapshot.exists) {
        return userSnapshot.data()?['nickname'];
      } else {
        return null; // User document doesn't exist
      }
    } catch (e) {
      print('Error fetching nickname from Firestore: $e');
      return null; // Return null in case of any errors
    }
  }

  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> saveUserToFirestore(String uid, String nickname) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'nickname': nickname,
      'level': 'beginner',
      'courses': {
        '1Beginner': {'0': false, '1': false},
        '2Intermediate': {'0': false, '1': false},
        '3Advanced': {'0': false, '1': false},
        '4Expert': {'0': false, '1': false},
        '5Master': {'0': false, '1': false},
      },
      'quizzes': {
        '1Beginner': 0,
        '2Intermediate': 0,
        '3Advanced': 0,
        '4Expert': 0,
        '5Master': 0,
      },
    });
  }

  Future<void> updateUserLevel(String uid, String level) async {
    try {
      await _firestore.collection('users').doc(uid).update({'level': level});
    } catch (e) {
      print('Error updating user level: $e');
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
