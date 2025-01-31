import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localpkg/dialogue.dart';
import 'package:localpkg/environment.dart';
import 'package:localpkg/logger.dart';

bool? allowedlaunch;

bool launchinit({required List? arguments, bool block = true, bool bypassDebug = false}) {
  print("checking if allowed launch...");

  bool conclude(bool valid, String description) {
    print("${valid ? "valid" : "invalid"}: $description");
    allowedlaunch = valid;
    return valid;
  }

  if ((kDebugMode && bypassDebug == false) || !Environment.desktop) {
    return conclude(true, "invalid platform for launcher");
  }

  if (arguments == null) {
    return conclude(false, "no arguments");
  }

  if (arguments.contains('--launcher=true')) {
    return conclude(true, "arguments match");
  } else {
    return conclude(false, "arguments don't match");
  }
}

void launchcheck(BuildContext context) {
  if (allowedlaunch == true) {
    print("launch check passed");
  } else if (allowedlaunch == false) {
    print("launch check failed");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showConstantDialogue(context: context, title: "Unable to Run Application", message: "Please run this application from the Calebh101 launcher. If this is a mistake, please try to contact support.");
  });
  } else if (allowedlaunch == null) {
    error("Launch check not ran\nPlease run launchinit() at the head main() function, with the required argument handler.");
  }
}