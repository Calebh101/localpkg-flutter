import 'package:flutter/foundation.dart';
import 'package:flutter_environments/flutter_environments.dart';
import 'package:localpkg/error.dart';
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

bool launchcheck() {
  if (allowedlaunch == true) {
    print("launch check passed");
    return true;
  } else if (allowedlaunch == false) {
    print("launch check failed");
    return false;
  } else if (allowedlaunch == null) {
    error("Launch check not ran\nPlease run launchinit() at the head main() function, with the required argument handler.");
    return false;
  } else {
    print("launch check denied programming physics");
    return false;
  }
}

void launchcrash(List arguments, {bool bypassDebug = false}) {
  if (allowedlaunch == null) {
    launchinit(arguments: arguments, bypassDebug: bypassDebug);
  }

  if (launchcheck()) {
    print("launch check passed");
  } else {
    print("launch check failed");
    Future.delayed(Duration.zero, () {
      CrashScreen(message: "Please run this app from the Calebh101 launcher.");
    });
  }
}