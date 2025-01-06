import 'package:flutter/material.dart';

void print(dynamic input) {
  debugPrint("${DateTime.now().toIso8601String()} (${input.runtimeType}): $input");
}