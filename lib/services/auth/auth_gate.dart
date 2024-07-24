import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/pages/home_page.dart';
import 'package:quiz_app/services/auth/auth_services.dart';
import 'package:quiz_app/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null) {
            return FutureBuilder<String?>(
              future: AuthServices().getNicknameFromFirestore(user.uid),
              builder: (context, nicknameSnapshot) {
                if (nicknameSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  // Loading indicator while fetching nickname
                  return const Center(child: CircularProgressIndicator());
                }
                if (nicknameSnapshot.hasError) {
                  // Handle error while fetching nickname
                  return const Center(child: Text('Error fetching nickname'));
                }
                if (nicknameSnapshot.hasData && nicknameSnapshot.data != null) {
                  // Navigate to HomePage with the fetched nickname
                  return HomePage(nickname: nicknameSnapshot.data!);
                } else {
                  // Handle case where nickname is not found
                  return const LoginOrRegister();
                }
              },
            );
          }
        }
        // User is not signed in, navigate to login/register page
        return const LoginOrRegister();
      },
    );
  }
}
