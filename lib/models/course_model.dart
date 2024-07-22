class Course {
  final String title;
  final String description;
  final String content;

  Course(
      {required this.title, required this.description, required this.content});

  @override
  String toString() {
    return 'Question(title:$title ,options:$description ,content:$content) ';
  }
}
