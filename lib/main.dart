import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/firebase_options.dart';
import 'package:quiz_app/models/db_models.dart';
import 'package:quiz_app/pages/home_page.dart';
import 'package:quiz_app/themes/theme_provider.dart';

import 'data/level_data.dart';
import 'models/level_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  var levelsDB = DBconnect();
  List<Level> levels = getLevels();

  for (var level in levels) {
    try {
      await levelsDB.addLevel(level);
    } catch (e) {
      print('Error adding level: $e');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(
        nickname: 'Athina',
      ),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
