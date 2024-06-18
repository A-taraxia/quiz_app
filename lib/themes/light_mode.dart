import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.grey[100],
  colorScheme: ColorScheme.light(
    primary: Colors.grey[100]!,
    secondary: Colors.teal,
    surface: Colors.grey[200]!,
    background: Colors.grey[100]!,
    onPrimary: Colors.grey[900]!,
    onSecondary: Colors.white,
    onSurface: Colors.grey[800]!,
    onBackground: Colors.grey[700]!,
    onError: Colors.red[600]!,
  ),
  scaffoldBackgroundColor: Colors.grey[100],
  cardColor: Colors.grey[50],
  iconTheme: IconThemeData(color: Colors.teal),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.grey[800]),
    bodyMedium: TextStyle(color: Colors.grey[700], fontSize: 20),
    headlineLarge: TextStyle(color: Colors.grey[900], fontSize: 30),
    headlineMedium: TextStyle(color: Colors.grey[800]),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.teal,
    textTheme: ButtonTextTheme.primary,
  ),
);
