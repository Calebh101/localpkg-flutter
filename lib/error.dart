import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localpkg/dialogue.dart';
import 'package:localpkg/functions.dart';
import 'package:localpkg/logger.dart' as logger;
import 'package:localpkg/theme.dart';

class ManualError extends Error {
  final String message;

  ManualError(
    this.message,
  );

  @override
  String toString() {
    return 'ManualError: $message';
  }

  void warn({String? code, bool? trace}) {
    logger.warn(toString(), code: code, trace: trace ?? false);
  }

  void error({String? code, bool? trace}) {
    logger.error(toString(), code: code, trace: trace ?? false);
  }

  void invoke({String? code, bool? trace}) {
    throw Exception(toString());
  }
}

class CrashPageApp extends StatelessWidget {
  final String? message;
  final String? description;
  final String? code;
  final bool support;
  final bool close;
  final Function? reset;
  final Function? closeFunction;

  const CrashPageApp({
    super.key,
    this.message,
    this.description,
    this.code,
    this.support = true,
    this.reset,
    this.close = false,
    this.closeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calebh101 Launcher: Error',
      theme: brandTheme(seedColor: Colors.red),
      darkTheme: brandTheme(seedColor: Colors.red, darkMode: true),
      home: CrashPage(message: message, description: description, code: code, support: support, reset: reset, close: close, closeFunction: closeFunction),
    );
  }
}

class CrashPage extends StatefulWidget {
  final String? message;
  final String? description;
  final String? code;
  final bool support;
  final bool close;
  final Function? reset;
  final Function? closeFunction;

  const CrashPage({
    super.key,
    this.message,
    this.description,
    this.code,
    this.support = true,
    this.reset,
    this.close = false,
    this.closeFunction,
  });

  @override
  State<CrashPage> createState() => _CrashPageState();
}

class _CrashPageState extends State<CrashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_rounded,
                color: Colors.amber,
                size: 72,
              ),
              Text("Whoa!", style: TextStyle(fontSize: 32, color: Colors.redAccent)),
              Text(widget.message ?? "A critical error occured.", style: TextStyle(fontSize: 18)),
              if (widget.description != null)
              Text(widget.description!, style: TextStyle(fontSize: 12)),
              if (widget.code != null)
              Text("Code ${widget.code}", style: TextStyle(fontSize: 12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.support)
                  TextButton(
                    child: Text("Support"),
                    onPressed: () {
                      support(context);
                    },
                  ),
                  if (widget.reset != null)
                  TextButton(
                    child: Text("Reset"),
                    onPressed: () async {
                      if (await showConfirmDialogue(context: context, title: "Are you sure?", description: "Are you sure you want to delete all app data? This cannot be undone. Only use this if closing and reopening the app or waiting for the issue to be resolved does not fix this issue.") ?? false) {
                        widget.reset!();
                      }
                    },
                  ),
                  if (widget.close)
                  TextButton(
                    child: Text("Close"),
                    onPressed: () {
                      (widget.closeFunction ?? () {
                        exit(0);
                      })();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void CrashScreen({String? message, String? description, String? code, Function? reset, bool support = true, bool close = false, Function? closeFunction}) {
  runApp(CrashPageApp(message: message, description: description, code: code, support: support, reset: reset, close: close, closeFunction: closeFunction));
}