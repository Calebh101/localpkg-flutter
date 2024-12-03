import 'package:flutter/material.dart';

ThemeData customTheme({
  required bool darkMode,
  required Color seedColor,
  required TextTheme textStyle,
}) {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: darkMode ? Brightness.dark : Brightness.light,
    ),
    useMaterial3: true,
    textTheme: textStyle.apply(
      bodyColor: darkMode ? Colors.white : Colors.black,
      displayColor: darkMode ? Colors.white : Colors.black,
    ),
  );
}