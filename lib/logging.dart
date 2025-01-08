import 'package:flutter/material.dart';

void print(dynamic input) {
  debugPrint("LOGS ${DateTime.now().toIso8601String()} (${input.runtimeType}): $input");
}

void warn(dynamic input) {
  debugPrint("WARN ${DateTime.now().toIso8601String()} (${input.runtimeType}):\n--------- $input ---------");
}