import 'package:flutter/material.dart';

final ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[850],
  colorScheme: ColorScheme.dark(
    primary: Colors.grey[850]!,
    secondary: Colors.teal,
    surface: Colors.grey[800]!,
    background: Colors.grey[900]!,
    onPrimary: Colors.grey[100]!,
    onSecondary: Colors.white,
    onSurface: Colors.grey[300]!,
    onBackground: Colors.grey[400]!,
  ),
  scaffoldBackgroundColor: Colors.grey[900],
  cardColor: Colors.grey[850],
  iconTheme: IconThemeData(color: Colors.teal),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.grey[300]),
    bodyMedium: TextStyle(color: Colors.grey[400]),
    headlineLarge: TextStyle(color: Colors.grey[100]),
    headlineMedium: TextStyle(color: Colors.grey[200]),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.teal,
    textTheme: ButtonTextTheme.primary,
  ),
);
