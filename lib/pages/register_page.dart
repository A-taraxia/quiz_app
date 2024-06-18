import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/components/my_button.dart';
import 'package:quiz_app/components/my_textfield.dart';
import 'package:quiz_app/pages/home_page.dart';
import 'package:quiz_app/services/auth/auth_services.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final TextEditingController nicknameController = TextEditingController();

  // Create an instance of AuthServices
  final AuthServices _authServices = AuthServices();

  void register() async {
    if (passwordController.text == confirmpasswordController.text) {
      try {
        UserCredential userCredential =
            await _authServices.signUpWithEmailPassword(
          emailController.text,
          passwordController.text,
        );

        // Get UID
        final uid = userCredential.user?.uid;

        if (uid != null) {
          await _authServices.saveUserToFirestore(uid, nicknameController.text);
          String? nickname = await _authServices.getNicknameFromFirestore(uid);
          if (nickname != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(nickname: nickname),
              ),
            );
          } else {
            // Handle case where nickname is not found
          }
        }
      } catch (e) {
        // Show an error message if registration fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    } else {
      // Show an error message if passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 25),
              Text(
                "Online Courses",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: emailController,
                hintText: "Enter your Email here",
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: "Enter your Password here",
                obscureText: true,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: confirmpasswordController,
                hintText: "Confirm your Password",
                obscureText: true,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: nicknameController,
                hintText: "Enter your Nickname here",
                obscureText: false,
              ),
              const SizedBox(height: 10),
              MyButton(
                  onTap: register,
                  text: "Sign Up"), // Update the onTap property
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Sign In now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
