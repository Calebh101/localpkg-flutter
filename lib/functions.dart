import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:localpkg/logger.dart';

String formatTime({
  required int input,
  /// amount of time that your input holds
  /// 1: milliseconds
  /// 2: seconds
  /// 3: minutes
  int mode = 1,
  /// type of output
  /// 1: hh:mm:ss
  /// 2: hh:mm
  /// 3: mm:ss
  int output = 2,
  bool army = false,
}) {
  int ms = input;
  switch (mode) {
    case 1:
      ms = input;
      break;
    case 2:
      ms = input % 1000;
      break;
    case 3:
      ms = input % (1000 * 60);
      break;
    default:
      error("Invalid mode: $mode");
      break;
  }

  DateTime time = DateTime.fromMillisecondsSinceEpoch(ms);
  int hour = time.hour;
  int minute = time.minute;
  int second = time.second;
  int roundedHour = hour;
  if (army == false) {
    if (hour > 12) {
      roundedHour = hour - 12;
    }
  }
  String formatted = "$roundedHour:${minute.toString().padLeft(2, '0')}${output == 1 || output == 3 ? (":${second.toString().padLeft(2, '0')}"): ""}${!army ? (" ${hour >= 12 ? "PM" : "AM"}") : ""}";
  return formatted;
}

String formatDuration(int ms, {int mode = 1}) {
  // modes
    // 1: hh:mm:ss.ms
    // 2: mm:ss.ms
    // 3: mm:ss
    // 4: hh:mm

  int hours = (ms ~/ 3600000);
  int minutes = (ms % 3600000) ~/ 60000;
  int seconds = (ms % 60000) ~/ 1000;
  int remainingms = ms % 1000;

  if (mode == 1) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${remainingms.toString().padLeft(3, '0')}';
  } else {
    throw Exception("Invalid mode: $mode");
  }
}

bool isWhole(num number) {
  return number % 1 == 0;
}

String cleanNumber(num number) {
  if (number is double && isWhole(number)) {
    return "${number.toInt()}";
  } else {
    return "$number";
  }
}

enum ColorType { theme, primary, secondary }

Color getColor({required BuildContext context, required ColorType type}) {
  if (type == ColorType.theme) {
    var brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.dark) {
      return Colors.white;
    } else if (brightness == Brightness.light) {
      return Colors.black;
    } else {
      throw Exception("Unknown brightness: $brightness");
    }
  } else if (type == ColorType.primary) {
    return Theme.of(context).primaryColor;
  } else if (type == ColorType.secondary) {
    return Theme.of(context).colorScheme.secondary;
  } else {
    throw Exception("Unknown ColorType: $type");
  }
}

Future<void> openUrl({required Uri url, LaunchMode launchMode = LaunchMode.externalApplication}) async {
  try {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: launchMode,
      );
    } else {
      throw Exception('Could not launch $url: canLaunchUrl returned false');
    }
  } catch (e) {
    throw Exception("Could not launch $url: $e");
  }
}

@Deprecated("Use openUrl instead.")
Future<void> launchURL(Uri url, LaunchMode? launchMode) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: launchMode ?? LaunchMode.externalApplication,
    );
  } else {
    throw 'Could not launch $url';
  }
}

String addHttpPrefix(String url, {String defaultPrefix = "http"}) {
  if (!url.startsWith('http://') && !url.startsWith('https://') && !url.startsWith('ws://') && !url.startsWith('wss://')) {
    return '$defaultPrefix://$url';
  }
  return url;
}

String removeHttpPrefix(String url, {bool removeWebsocket = true}) {
  url = url.replaceAll("http://", "");
  url = url.replaceAll("https://", "");
  if (removeWebsocket) {
    url = url.replaceAll("ws://", "");
    url = url.replaceAll("wss://", "");
  }
  return url;
}

String toSentenceCase(String input) {
  if (input.isEmpty) {
    return input;
  }
  return input[0].toUpperCase() + input.substring(1);
}

String toTitleCase(String input) {
  if (input.isEmpty) return input;

  return input
      .split(' ')
      .map((word) => word.isNotEmpty
          ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
          : word)
      .join(' ');
}

@Deprecated("Use shareText instead. shareText has a different parameter layout.")
Future<bool> shareTextFile(bool allowShareContent, String subject, String content, String extension) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.$extension');
    final file2 = await file.writeAsString(content);
    await Share.shareXFiles([XFile(file2.path)], text: subject);
    return true;
  } catch (e) {
    if (allowShareContent) {
      print("Unable to Share.shareXFiles: falling back on Share.share: $e");
      try {
        await Share.share(content, subject: subject);
        return true;
      } catch (e2) {
        print("Unable to Share.share: $e2");
        return false;
      }
    } else {
      print("Unable to Share.share: action not allowed");
      return false;
    }
  }
}

Future<bool> shareText({required String content, required String filename,bool allowTextShare = true, String? subject}) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    final file2 = await file.writeAsString(content);
    await Share.shareXFiles([XFile(file2.path)], text: subject);
    return true;
  } catch (e) {
    if (allowTextShare) {
      print("Unable to Share.shareXFiles: falling back on Share.share: $e");
      try {
        await Share.share(content, subject: subject);
        return true;
      } catch (e2) {
        print("Unable to Share.share: $e2");
        return false;
      }
    } else {
      print("Unable to Share.share: action not allowed");
      return false;
    }
  }
}

double getSizeFactor({
  required BuildContext context,
  int mode = 1,
  double maxSize = 3,
  bool forceUseWidth = true,
}) {
  double size;
  Size screenSize = MediaQuery.of(context).size;

  if ((screenSize.width > screenSize.height) && !forceUseWidth) {
    size = screenSize.height;
  } else {
    size = screenSize.width;
  }

  switch (mode) {
    case 1: // width
      size = screenSize.width;
      break;
    case 2: // height
      size = screenSize.height;
      break;
    case 3: // auto
      if (screenSize.width > screenSize.height) {
        size = screenSize.height;
      } else {
        size = screenSize.width;
      }
      break;
  }

  size = size * 0.003;
  size = size > maxSize ? maxSize : size;
  return size;
}

int getCrossAxisCount({required BuildContext context, int factor = 180}) {
  double screenWidth = MediaQuery.of(context).size.width;
  int crossAxisCount = (screenWidth / factor).floor();
  crossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;
  return crossAxisCount;
}

void navigate({required BuildContext context, required Widget page,
    /// mode 1: push
    /// mode 2: push and replace
    int mode = 1,
  }) {
  if (mode == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  } else if (mode == 2) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  } else {
    throw Exception("Invalid mode in navigate: $mode");
  }
}