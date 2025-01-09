import 'dart:convert';

import 'package:flutter/material.dart';

String _reset = "\x1B[0m";
String _line = "----------------";

/// Takes any input and outputs a simple log
/// If this file is imported, it will override any print() called to use custom logging
void print(dynamic input) {
  _handle(input, "log", "0");
}

/// Takes any input and code and outputs a warning in yellow text
void warn(dynamic input, {String? code}) {
  _handle(input, "warning", code);
}

/// Takes any input and code and outputs an error in red text
void error(dynamic input, {String? code}) {
  _handle(input, "error", code);
}

void _handle(dynamic input, String type, String? code) {
  input = _encodeInput(input);
  String abbr = (type == "log" ? "log" : (type == "warning" ? "warn" : (type == "error" ? "err" : "null-")));
  String output = _getOutput(input, type.toUpperCase(), abbr.toUpperCase(), code: code);
  List<String> lines = output.split('\n');
  for (String line in lines) {
    debugPrint("${type == "error" ? "\x1B[31m" : (type == "warning" ? "\x1B[33m" : "")}$line$_reset");
  }
}

String _getOutput(dynamic input, String type, String abbr, {String? code}) {
  return "${_getLine(abbr, code)}\n$abbr ${DateTime.now().toIso8601String()}: ${type == "log" ? "$input ${code != null ? "(code $code)" : ""}" : "$type${code != null ? " (CODE $code) " : " "}CAUGHT BY LOCALPKG HANDLER:\n$type: $input\n\n${StackTrace.current}\n$type: $input\n${_getLine(abbr, code)}"}";
}

String _getLine(String abbr, String? code) {
  return "$_line $abbr ${code != null ? "(code $code)" : ""} $_line";
}

String _encodeInput(dynamic input) {
  if (input is Map) {
    input = jsonEncode(input);
  }
  return input;
}
