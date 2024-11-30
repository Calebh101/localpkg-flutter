import 'package:url_launcher/url_launcher.dart';

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