// This file is used for testing. This is not to be used as a public API.

import 'package:flutter/material.dart';
import 'package:localpkg/online.dart';
import 'package:localpkg/theme.dart';
import 'package:localpkg/tipjar.dart';
import 'package:localpkg/override.dart';
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
        ],
      ),
    );
  }
}
