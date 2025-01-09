import 'dart:convert';

import 'package:flutter/material.dart';

String _line = "----------------";

/// Takes any input and outputs a simple log
/// If this file is imported, it will override any print() called to use custom logging
void print(dynamic input, {String? code, bool trace = false, String? color}) {
  _handle(input, "log", code, trace, color);
}

/// Takes any input and code and outputs a warning in yellow text
void warn(dynamic input, {String? code, bool trace = true, String color = "\x1B[33m"}) {
  _handle(input, "warning", code, trace, color);
}

/// Takes any input and code and outputs an error in red text
void error(dynamic input, {String? code, bool trace = true, String color = "\x1B[31m"}) {
  _handle(input, "error", code, trace, color);
}

void stack({String? code, String? color}) {
  _handle("null", "stack", code, true, color);
}

void _handle(dynamic input, String type, String? code, bool stackTrace, String? color) {
  input = _encodeInput(input);
  String colorCode = "";
  if (color != null) {
    if (_validColor(color)) {
      colorCode = color;
    } else {
      error("Invalid ANSI color code: $color");
      return;
    }
  }
  String abbr = (type == "log" ? "log" : (type == "warning" ? "warn" : (type == "error" ? "err" : (type == "stack" ? "stack" : "null"))));
  String output = _getOutput(input, type.toUpperCase(), abbr.toUpperCase(), code, stackTrace);
  List<String> lines = output.split('\n');
  for (String line in lines) {
    debugPrint("$colorCode$line\x1B[0m");
  }
}

String _getOutput(dynamic input, String type, String abbr, String? code, bool stackTrace) {
  return "${(!stackTrace) ? "" : "${_getLine(abbr, code)}\n"}$abbr ${DateTime.now().toIso8601String()}: ${(type == "LOG" && !stackTrace) ? "$input ${code != null ? "(code $code)" : ""}" : "${type == "LOG" ? "" : "$type${code != null ? " (CODE $code) " : " "}${type == "STACK" ? "TRACE CALLED:" : "CAUGHT BY LOCALPKG HANDLER:\n$type: "}"}${type == "STACK" ? "" : "$input"}${stackTrace ? "\n\n${StackTrace.current}${type == "STACK" ? "" : "\n$type: $input"}\n" : "\n"}${_getLine(abbr, code)}"}";
}

String _getLine(String abbr, String? code) {
  return "$_line $abbr${code != null ? " (code $code) " : " "}$_line";
}

String _encodeInput(dynamic input) {
  if (input is Map) {
    input = jsonEncode(input);
  }
  return input;
}

bool _validColor(String input) {
  final ansiColorPattern = RegExp(r'^\x1B\[\d+(;\d+)*m$');
  return ansiColorPattern.hasMatch(input);
}
