import 'package:flutter/material.dart';
import 'package:quiz_app/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        drawer: const MyDrawer(),
        appBar: AppBar(
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.menu_book), text: 'Courses'),
              Tab(icon: Icon(Icons.quiz), text: 'Quizzes'),
            ],
          ),
          centerTitle: true,
          title: const Text('Home'),
          backgroundColor: Colors.transparent,
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Home Content')),
            Center(child: Text('Courses Content')),
            Center(child: Text('Quizzes Content')),
          ],
        ),
      ),
    );
  }
}
