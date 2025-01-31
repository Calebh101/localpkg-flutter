// This file is used for testing. This is not to be used as a public API.

import 'package:flutter/material.dart';
import 'package:localpkg/dialogue.dart';
import 'package:localpkg/launcher.dart';
import 'package:localpkg/online.dart';
import 'package:localpkg/theme.dart';
import 'package:localpkg/tipjar.dart';
import 'package:localpkg/logger.dart';
import 'package:localpkg/widgets.dart';
import 'package:quick_navbar/quick_navbar.dart';
import 'package:http/http.dart' as http;

void main(List<String> arguments) {
  print("${arguments.runtimeType}: $arguments");
  launchinit(arguments: arguments);
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
  String email = "calebharper5@gmail.com";
  String username = "Calebh77";
  String password = "Beach6781!";
  User? user;

  @override
  void initState() {
    launchcheck(context);
    user = User(email: email, username: username, password: password);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              child: Text("Test Version Parse"),
              onPressed: () {
                parseVersion('0.0.0A');
                parseVersion('0.1.0D');
                parseVersion('4.0.0A');
                parseVersion('0.0.0C');
                parseVersion('35.0.4A');
                parseVersion('8.5.7T');
                parseVersion('0.70.0A');
                parseVersion('0.70.1A');
                parseVersion('0.70.2A');
                parseVersion('0.71.0B');
                parseVersion('0.71.1C');
                parseVersion('0.71.2Z');
                parseVersion('0.72.2');
                parseVersion('1.72.2S');
                parseVersion('2.0.0G');
              },
            ),
            TextButton(
              child: Text("Test Server Launch"),
              onPressed: () {
                serverlaunch(context: context, service: "test", version: "0.0.0A");
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
            BlockButton(text: "Info", action: () {
              print(user!.info());
            }, size: 160),
            BlockButton(text: "Login", action: () async {
              print(await user!.login());
            }, size: 160),
            BlockButton(text: "Register", action: () async {
              print(await user!.register());
            }, size: 160),
            BlockButton(text: "Test", action: () async {
              print(await user!.request(method: "POST", endpoint: "/api/auth/info"));
            }, size: 160),
            AboutSettings(context: context, version: "0.0.0A", beta: true, about: "About", instructionsAction: () {showDialogue(context: context, title: "Instructions", content: Text("instructions"));}),
          ],
        ),
      ),
    );
  }
}
