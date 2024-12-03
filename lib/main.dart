// This file is used for testing. This is not to be used as a public API.

import 'package:flutter/material.dart';
import 'package:localpkg/tipjar.dart';
import 'package:quick_navbar/quick_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reminders+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light, // Explicitly specify light mode
        ),
        useMaterial3: true, // Enable Material 3
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark, // Explicitly specify dark mode
        ),
        useMaterial3: true, // Enable Material 3
      ),
      home: QuickNavBar(
        items: [
          {
            "label": "Home",
            "icon": Icons.home,
            "widget": TestPage(),
          },
          {
            "label": "Tip Jar",
            "icon": Icons.settings,
            "widget": TipJar(),
          },
        ], selectedColor: Colors.blue,
      ),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}