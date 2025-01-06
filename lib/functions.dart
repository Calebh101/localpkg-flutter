import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:localpkg/override.dart';

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

String addHttpPrefix(String url) {
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    return 'http://$url';
  }
  return url;
}

String removeHttpPrefix(String url) {
  url = url.replaceAll("http://", "");
  url = url.replaceAll("https://", "");
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

Future<bool> shareTextFile(bool allowShareContent, String subject,
    String content, String extension) async {
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

double getSizeFactor(
    {required BuildContext context,
    int mode = 1,
    double maxSize = 3,
    bool forceUseWidth = true}) {
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