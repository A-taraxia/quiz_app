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

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
