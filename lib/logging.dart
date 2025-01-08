import 'package:flutter/material.dart';
String _reset = "\x1B[0m";
String _line = "----------------";

void print(dynamic input) {
  String output = _getOutput(input, "log");
  debugPrint(output);
}

void warn(dynamic input, {String? code}) {
  String output = _getOutput(input, "warning", code: code);
  debugPrint(output);
}

void error(dynamic input, {String? code}) {
  String output = _getOutput(input, "error", code: code);
  debugPrint(output);
  try {
    throw Exception(output);
  } catch (e) {
    // do nothing
  }
}

String _getOutput(dynamic input, String type, {String? code}) {
  return "${type == "error" ? "\x1B[31m" : (type == "warning" ? "\x1B[33m" : "")}${type.toUpperCase()} ${DateTime.now().toIso8601String()}: ${type == "log" ? "$input" : "${type.toUpperCase()}${code != null ? " (CODE $code) " : " "}CAUGHT BY LOCALPKG HANDLER:\n${StackTrace.current}\n$_line $input${code != null ? " (code $code) " : " "}$_line$_reset"}";
}