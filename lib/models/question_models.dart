class Question {
  final String title;
  final Map<String, bool> options;

  Question({
    required this.title,
    required this.options,
  });

  @override
  String toString() {
    return 'Question(title:$title ,options:$options) ';
  }
}
