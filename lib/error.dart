import 'package:flutter/material.dart';
import 'package:localpkg/functions.dart';
import 'package:localpkg/logger.dart' as logger;

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

class CrashPage extends StatefulWidget {
  const CrashPage({super.key});

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
              Text("This application is meant to be run on desktop PCs or Macs. If this is a mistake, please contact support."),
              TextButton(
                child: Text("Support"),
                onPressed: () {
                  support(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}