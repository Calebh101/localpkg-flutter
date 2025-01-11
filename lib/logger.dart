import 'dart:convert';

import 'package:flutter/material.dart';

String _line = "----------------";

/// Takes any input and outputs a simple log
/// If this file is imported, it will override any print() called to use custom logging
/// Input: the log
/// Code: the log code
/// Bold: bolden the output
/// Color: the ANSI color for the terminal (default is default)
/// Trace: show stack trace (default is false)
void print(dynamic input, {String? code, bool bold = false, String? color, bool trace = false}) {
  _handle(input, "log", code, trace, color, bold);
}

/// Takes any input and code and outputs a warning
/// Input: the warning
/// Code: the warn code
/// Bold: bolden the output
/// Color: the ANSI color for the terminal (default is yellow)
/// Trace: show stack trace (default is true)
void warn(dynamic input, {String? code, bool bold = false, bool trace = true, String? color = "\x1B[33m"}) {
  _handle(input, "warning", code, trace, color, bold);
}

/// Takes any input and code and outputs an error
/// Input: the error
/// Code: the error code
/// Color: the ANSI color for the terminal (default is red)
/// Trace: show stack trace (default is true)
void error(dynamic input, {String? code, String? color = "\x1B[31m", bool bold = false, bool trace = true}) {
  _handle(input, "error", code, trace, color, bold);
}

/// Outputs the stack trace
/// Code: the log code
/// Bold: bolden the output
/// Color: the ANSI color for the terminal (default is default)
/// You don't have a choice to show the stack trace here lol
/// It looks weird though, calling a dedicated show stack trace function but disabling stack trace
void stack({String? code, bool bold = false, String? color}) {
  _handle("null", "stack", code, true, color, bold);
}

void _handle(dynamic input, String type, String? code, bool stackTrace, String? color, bool bold) {
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
    debugPrint("${bold ? "\x1b[1m]" : ""}$colorCode$line\x1B[0m");
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
