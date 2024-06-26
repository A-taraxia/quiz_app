import 'package:flutter/material.dart';
import 'package:quiz_app/components/my_drawer.dart';
import 'package:quiz_app/containers/courses_container.dart';
import 'package:quiz_app/containers/quizzes_container.dart';
import 'package:quiz_app/containers/home_container.dart'; // Import the HomeContainer

class HomePage extends StatefulWidget {
  final String nickname;

  const HomePage({super.key, required this.nickname});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(_getAppBarTitle()),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                HomeContainer(nickname: widget.nickname), // Use HomeContainer here
                const CoursesContainer(),
                const QuizzesContainer()
              ],
            ),
          ),
          Divider(height: 1.0, color: Theme.of(context).dividerColor),
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.secondary,
              indicatorColor: Theme.of(context).colorScheme.secondary,
              tabs: const [
                Tab(icon: Icon(Icons.home), text: 'Home'),
                Tab(icon: Icon(Icons.menu_book), text: 'Courses'),
                Tab(icon: Icon(Icons.quiz), text: 'Quizzes'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_tabController.index) {
      case 0:
        return 'Home';
      case 1:
        return 'Courses';
      case 2:
        return 'Quizzes';
      default:
        return 'Home';
    }
  }
}