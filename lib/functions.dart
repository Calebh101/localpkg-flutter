import 'dart:io';

import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

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