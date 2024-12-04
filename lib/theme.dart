import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData customTheme({
  bool darkMode = false,
  Color seedColor = Colors.red,
  TextTheme? textStyle,
  double iconSize = 30,
}) {
  TextTheme textTheme = textStyle ?? GoogleFonts.poppinsTextTheme();
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: darkMode ? Brightness.dark : Brightness.light,
    ),
    useMaterial3: true,
    textTheme: textTheme.apply(
      bodyColor: darkMode ? Colors.white : Colors.black,
      displayColor: darkMode ? Colors.white : Colors.black,
    ),
    iconTheme: IconThemeData(size: iconSize),
  );
}