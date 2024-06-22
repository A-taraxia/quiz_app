import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/models/db_models.dart';
import 'package:quiz_app/models/question_models.dart';
import 'package:quiz_app/pages/home_page.dart';
import 'package:quiz_app/themes/theme_provider.dart';

void main() async {
  var questionsDB = DBconnect();
  questionsDB.addQuestion(Question(
      id: '20',
      title: 'Inside which HTML element do we put the JavaScript?',
      options: {
        '<scripting>': false,
        '<script>': true,
        '<javascript>': false,
        '<js>': false
      }));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(
        nickname: 'Athina',
      ),
      //home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
