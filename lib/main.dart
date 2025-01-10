// This file is used for testing. This is not to be used as a public API.

import 'package:flutter/material.dart';
import 'package:localpkg/dialogue.dart';
import 'package:localpkg/online.dart';
import 'package:localpkg/theme.dart';
import 'package:localpkg/tipjar.dart';
import 'package:localpkg/logger.dart';
import 'package:localpkg/widgets.dart';
import 'package:quick_navbar/quick_navbar.dart';
import 'package:http/http.dart' as http;

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
      theme: brandTheme(
        darkMode: false,
        seedColor: Colors.orange,
        iconSize: 12,
      ),
      darkTheme: brandTheme(
        darkMode: true,
        seedColor: Colors.orange,
        iconSize: 12,
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
        ],
        selectedColor: Colors.blue,
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
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              child: Text("Test Server Launch"),
              onPressed: () {
                serverlaunch(context: context, service: "general");
              },
            ),
            TextButton(
              child: Text("Test Server Post"),
              onPressed: () async {
                http.Response response = await getServerResponse(endpoint: "/api/services/trafficlightsimulator/join", body: {"id": "999999999"});
                print("response[${response.statusCode}]: ${response.body}");
              },
            ),
            TextButton(
              child: Text("LOG NO STACK"),
              onPressed: () async {
                print("Test");
              },
            ),
            TextButton(
              child: Text("WARN NO STACK"),
              onPressed: () async {
                warn("Test", trace: false);
              },
            ),
            TextButton(
              child: Text("ERROR NO STACK"),
              onPressed: () async {
                error("Test", trace: false);
              },
            ),
            TextButton(
              child: Text("LOG (STACK)"),
              onPressed: () async {
                print("Test", trace: true);
              },
            ),
            TextButton(
              child: Text("WARN"),
              onPressed: () async {
                warn("Test");
              },
            ),
            TextButton(
              child: Text("ERROR"),
              onPressed: () async {
                error("Test");
              },
            ),
            TextButton(
              child: Text("WARN CODE"),
              onPressed: () async {
                warn("Test", code: "200");
              },
            ),
            TextButton(
              child: Text("ERROR CODE"),
              onPressed: () async {
                error("Test", code: "200");
              },
            ),
            TextButton(
              child: Text("STACK"),
              onPressed: () async {
                stack();
              },
            ),
            TextButton(
              child: Text("STACK CODE"),
              onPressed: () async {
                stack(code: "200");
              },
            ),
            BlockButton(text: "Size: 160", action: () {}, size: 160),
            BlockButton(text: "Size: 320", action: () {}, size: 320),
            BlockButton(text: "Size: 480", action: () {}, size: 480),
            AboutSettings(context: context, version: "0.0.0A", beta: true, about: "About", instructionsAction: () {showDialogue(context: context, title: "Instructions", text: "instructions");}),
          ],
        ),
      ),
    );
  }
}
