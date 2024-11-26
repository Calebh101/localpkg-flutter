import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:personal/functions.dart';

void showSnackBar(context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}

Future<bool> showAlertDialogue(BuildContext context, String title, String text, bool cancel, Map copy) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          copy["show"] ? TextButton(
            child: const Text('Copy'),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: copy.containsKey("text") ? copy["text"] : text));
              showSnackBar(context, "Copied to clipboard!");
            },
          ) : const SizedBox.shrink(),
          cancel ? TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ) : const SizedBox.shrink(),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  ) as Future<bool>;
}

Future<void> openUrlConf(BuildContext context, Uri url) async {
  if (!kIsWeb) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Open Link?'),
          content: Text('Do you want to open "$url"? This will open in your default app.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                launchURL(url);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  } else {
    Navigator.of(context).pop();
    launchURL(url);
  }
}

Future<void> openUrl(BuildContext context, Uri url) async { // I am deprecating openUrl in favor of openUrlConf, so I made this is a backwards-compatibility layer
  await openUrlConf(context, url);
}

void showConstantDialogue(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [],
        ),
      );
    },
  );
}

Future<bool?> showConfirmDialogue(BuildContext context, String title) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Action'),
        content: Text(title),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}