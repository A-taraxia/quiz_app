import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
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
        '2Intermediate': {'2': false, '3': false},
        '3Advanced': {'4': false, '5': false},
        '4Expert': {'6': false, '7': false},
        '5Master': {'8': false, '9': false},
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

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> saveQuizScore(String levelId, int newScore) async {
    User? user = getCurrentUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> quizzes = userDoc.data()?['quizzes'] ?? {};
        int currentScore = quizzes[levelId] ?? 0;

        if (newScore > currentScore) {
          await _firestore.collection('users').doc(user.uid).update({
            'quizzes.$levelId': newScore,
          });
        }
      }
    } catch (e) {
      print('Error saving quiz score: $e');
    }
  }

  Future<String?> getNickname() async {
    User? user = getCurrentUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
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

  Future<int> getTotalQuizScore() async {
    User? user = getCurrentUser();
    if (user == null) {
      throw Exception("User not logged in");
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
      if (userSnapshot.exists) {
        Map<String, dynamic> quizzes = userSnapshot.data()?['quizzes'] ?? {};
        int totalScore = 0;
        quizzes.forEach((key, value) {
          totalScore += value as int;
        });
        return totalScore;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error fetching total quiz score from Firestore: $e');
      return 0;
    }
  }
}
