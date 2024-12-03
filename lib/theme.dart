import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData customTheme({
  bool? darkMode,
  Color? seedColor,
  TextTheme? textStyle,
}) {
  TextTheme textTheme = textStyle ?? GoogleFonts.poppinsTextTheme();
  bool useDarkMode = darkMode ?? false;
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: seedColor ?? Colors.amber,
      brightness: useDarkMode ? Brightness.dark : Brightness.light,
    ),
    useMaterial3: true,
    textTheme: textTheme.apply(
      bodyColor: useDarkMode ? Colors.white : Colors.black,
      displayColor: useDarkMode ? Colors.white : Colors.black,
    ),
  );
}