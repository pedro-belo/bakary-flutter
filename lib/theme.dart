import 'package:flutter/material.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    background: Colors.black87,
    error: const Color.fromARGB(255, 252, 56, 102),
  ),
  textTheme: const TextTheme().copyWith(
    bodyLarge: const TextStyle(
      color: Colors.white,
    ),
    bodyMedium: const TextStyle(
      color: Colors.white,
    ),
    bodySmall: const TextStyle(
      color: Colors.white,
    ),
  ),
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black87,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
      )),
);
