import 'package:quiz_app/models/course_model.dart';
import 'package:quiz_app/models/level_model.dart';
import 'package:quiz_app/models/question_models.dart';

List<Level> getLevels() {
  return [
    Level(
      id: '1Beginner',
      title: 'Beginner',
      questions: [
        Question(
          title: 'What appears with the use of print(\'Hello\') in Python?',
          options: {
            'Hello': true,
            'Error': false,
          },
        ),
        Question(
          title:
              'How can I show the first character of the string a = "Hello World!"?',
          options: {
            'a[1]': false,
            'print(a[1])': false,
            'print([0])': false,
            'print(a[0])': true,
          },
        ),
        Question(
          title: 'What is the correct syntax to create a dictionary in Python?',
          options: {
            '{1, \'a\'; 2, \'b\'}': false,
            '{1: \'a\', 2: \'b\'}': true,
            '[1, \'a\', 2, \'b\']': false,
            '(1: \'a\', 2: \'b\')': false,
          },
        ),
        Question(
          title:
              'Which method can be used to remove an item from a list in Python?',
          options: {
            'remove()': true,
            'delete()': false,
            'discard()': false,
            'pop()': false,
          },
        ),
        Question(
          title: 'Which method can be used to add an item to a list in Python?',
          options: {
            'add()': false,
            'append()': true,
            'additional()': false,
            'Append()': false,
          },
        ),
        Question(
          title: 'Which method can be used to sort items in a list in Python?',
          options: {
            'sort(reverse = True)': false,
            'reverse()': false,
            'sOrt()': false,
            'sort()': true,
          },
        ),
        Question(
          title:
              'Can you assign multiple values to variables in a single line in Python?',
          options: {
            'Yes': true,
            'No': false,
          },
        ),
        Question(
          title: 'Can you copy and join lists in Python?',
          options: {
            'Yes': true,
            'No': false,
          },
        ),
      ],
      courses: [
        Course(
          title: 'Introduction to Programming with Python',
          description: 'Learn the basics of Python programming.',
          content:
              'This course covers basic syntax, variables, and control structures. You will learn how to write simple Python programs, understand the use of different data types, and control the flow of your program using loops and conditionals. By the end of this course, you should be able to write and run basic Python scripts.',
        ),
        Course(
          title: 'Basic Data Structures in Python',
          description: 'Understand the fundamental data structures in Python.',
          content:
              'This course covers lists, dictionaries, and sets. You will learn how to create, access, and manipulate these data structures to store and organize data efficiently. By the end of this course, you should be able to choose the appropriate data structure for various tasks and implement basic algorithms.',
        ),
      ],
    ),
    Level(
      id: '2Intermediate',
      title: 'Intermediate',
      questions: [
        Question(
          title: 'What is the correct syntax to create a class in Python?',
          options: {
            'class MyClass:': true,
            'class MyClass()': false,
            'class MyClass[]': false,
            'class MyClass{}': false,
          },
        ),
        Question(
          title: 'How do you create an instance of a class in Python?',
          options: {
            'my_instance = MyClass()': true,
            'my_instance = new MyClass()': false,
            'my_instance = MyClass': false,
            'my_instance = MyClass[]': false,
          },
        ),
        Question(
          title: 'Which method is called when an object is created in Python?',
          options: {
            '__init__': true,
            '__start__': false,
            '__create__': false,
            '__new__': false,
          },
        ),
        Question(
          title: 'What is the output of list(range(5)) in Python?',
          options: {
            '[0, 1, 2, 3, 4]': true,
            '[1, 2, 3, 4, 5]': false,
            '[0, 1, 2, 3, 4, 5]': false,
            '[1, 2, 3, 4]': false,
          },
        ),
        Question(
          title: 'How do you create a set in Python?',
          options: {
            'set = {1, 2, 3}': true,
            'set = [1, 2, 3]': false,
            'set = (1, 2, 3)': false,
            'set = {1: 2, 3}': false,
          },
        ),
      ],
      courses: [
        Course(
          title: 'Object-Oriented Programming with Python',
          description: 'Learn the principles of OOP using Python.',
          content:
              'This course covers classes, objects, inheritance, and polymorphism. You will learn how to create and use classes and objects, implement inheritance to create a hierarchy of classes, and use polymorphism to create flexible and reusable code. By the end of this course, you should be able to design and implement object-oriented programs in Python.',
        ),
        Course(
          title: 'Intermediate Python for Data Analysis',
          description: 'Enhance your Python skills for data analysis.',
          content:
              'This course covers NumPy, Pandas, and data visualization techniques. You will learn how to manipulate numerical data with NumPy, work with data frames using Pandas, and create various types of plots and charts to visualize data. By the end of this course, you should be able to perform complex data analysis tasks and present your findings effectively.',
        ),
      ],
    ),
    Level(
      id: '3Advanced',
      title: 'Advanced',
      questions: [
        Question(
          title: 'What is a lambda function in Python?',
          options: {
            'A small anonymous function': true,
            'A named function': false,
            'A class method': false,
            'An instance method': false,
          },
        ),
        Question(
          title: 'How do you handle exceptions in Python?',
          options: {
            'try/except': true,
            'try/catch': false,
            'handle/catch': false,
            'try/handle': false,
          },
        ),
        Question(
          title: 'What does the map() function do in Python?',
          options: {
            'Applies a function to all items in an iterable': true,
            'Maps values to keys in a dictionary': false,
            'Creates a new list': false,
            'Sorts a list': false,
          },
        ),
        Question(
          title: 'How do you create a virtual environment in Python?',
          options: {
            'python -m venv env': true,
            'virtualenv env': false,
            'python venv create': false,
            'create venv env': false,
          },
        ),
      ],
      courses: [
        Course(
          title: 'Advanced Python Programming',
          description: 'Master advanced Python programming concepts.',
          content:
              'This course covers decorators, generators, and metaprogramming. You will learn how to use decorators to modify the behavior of functions or classes, generators to create iterators in a memory-efficient way, and metaprogramming to write code that manipulates code. By the end of this course, you should be able to use these advanced features to write more efficient and flexible Python programs.',
        ),
        Course(
          title: 'Python for Data Science',
          description: 'Apply Python for data science and machine learning.',
          content:
              'This course covers data manipulation, visualization, and machine learning with Python. You will learn how to clean and preprocess data, create informative visualizations, and build machine learning models using libraries such as Scikit-Learn and TensorFlow. By the end of this course, you should be able to apply Python to solve real-world data science problems.',
        ),
      ],
    ),
    Level(
      id: '4Expert',
      title: 'Expert',
      questions: [
        Question(
          title:
              'What is the purpose of the __init__.py file in a Python package?',
          options: {
            'Initialize the package': true,
            'Define the main function': false,
            'Set package version': false,
            'Define package metadata': false,
          },
        ),
        Question(
          title: 'How can you improve the performance of a Python script?',
          options: {
            'Use built-in functions and libraries': true,
            'Avoid using dictionaries': false,
            'Use more loops': false,
            'Write longer functions': false,
          },
        ),
        Question(
          title: 'What is the purpose of the functools module in Python?',
          options: {
            'To provide higher-order functions': true,
            'To perform mathematical operations': false,
            'To handle file operations': false,
            'To manipulate strings': false,
          },
        ),
        Question(
          title: 'What does the with statement do in Python?',
          options: {
            'Simplifies exception handling': true,
            'Starts a new thread': false,
            'Imports a module': false,
            'Initializes a class': false,
          },
        ),
      ],
      courses: [
        Course(
          title: 'Expert Python Programming',
          description: 'Gain expertise in Python programming.',
          content:
              'This course covers advanced concepts such as asynchronous programming and concurrent execution. You will learn how to use the asyncio module to write concurrent code, handle I/O-bound tasks efficiently, and use threading and multiprocessing to improve performance. By the end of this course, you should be able to write highly efficient and scalable Python applications.',
        ),
        Course(
          title: 'Python for Web Development',
          description: 'Build web applications using Python.',
          content:
              'This course covers frameworks like Django and Flask for web development. You will learn how to create web applications, manage databases, and implement user authentication and authorization. By the end of this course, you should be able to build and deploy robust web applications using Python.',
        ),
      ],
    ),
    Level(
      id: '5Master',
      title: 'Master',
      questions: [
        Question(
          title: 'What is the Global Interpreter Lock (GIL) in Python?',
          options: {
            'A mutex that protects access to Python objects': true,
            'A lock for file operations': false,
            'A security feature for Python scripts': false,
            'A method to secure network connections': false,
          },
        ),
        Question(
          title: 'What is the purpose of the asyncio module in Python?',
          options: {
            'To write concurrent code using the async/await syntax': true,
            'To handle file I/O operations': false,
            'To perform mathematical computations': false,
            'To manipulate strings': false,
          },
        ),
        Question(
          title: 'What is a coroutine in Python?',
          options: {
            'A function that can be paused and resumed': true,
            'A function that runs in a separate thread': false,
            'A method in a class': false,
            'A built-in Python function': false,
          },
        ),
        Question(
          title:
              'How can you profile a Python script to identify performance bottlenecks?',
          options: {
            'Using the cProfile module': true,
            'Using the time module': false,
            'Using the os module': false,
            'Using the random module': false,
          },
        ),
      ],
      courses: [
        Course(
          title: 'Mastering Python Performance Optimization',
          description: 'Optimize the performance of your Python applications.',
          content:
              'This course covers profiling, optimization techniques, and memory management. You will learn how to use profiling tools to identify performance bottlenecks, apply optimization techniques to improve efficiency, and manage memory usage to prevent leaks and ensure scalability. By the end of this course, you should be able to fine-tune your Python applications for maximum performance.',
        ),
        Course(
          title: 'Python for Big Data and AI',
          description:
              'Leverage Python for big data and artificial intelligence.',
          content:
              'This course covers libraries and frameworks for big data processing and AI, such as TensorFlow, PyTorch, and Apache Spark. You will learn how to process and analyze large datasets, build and train AI models, and deploy scalable AI solutions. By the end of this course, you should be able to use Python to tackle complex big data and AI challenges.',
        ),
      ],
    )
  ];
}
