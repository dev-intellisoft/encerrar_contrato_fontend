import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    primarySwatch: Colors.teal,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Color.fromRGBO(0, 111, 253, 1), fontWeight: FontWeight.bold),
        displayLarge: TextStyle(color: Color.fromRGBO(0, 111, 253, 1), fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      // headline6: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      // bodyText2: TextStyle(fontSize: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,

        backgroundColor: const Color.fromRGBO(0, 111, 253, 1),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide.none),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromRGBO(197, 198, 204, 1), width: 1),
          borderRadius: BorderRadius.circular(12)
      ),
    ),
    buttonTheme: ButtonThemeData(

    )
  );

// Add more themes if needed
}