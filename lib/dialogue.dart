import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localpkg/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showSnackBar(context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}

Future<bool?> showAlertDialogue(
  BuildContext context,
  String title,
  String text,
  bool cancel,
  Map copy,
) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(text),
        actions: [
          copy["show"] 
              ? TextButton(
                  child: const Text('Copy'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: copy.containsKey("text") ? copy["text"] : text));
                    showSnackBar(context, "Copied to clipboard!");
                  },
                )
              : const SizedBox.shrink(),
          cancel
              ? TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false); 
                  },
                )
              : const SizedBox.shrink(),
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop(true); 
            },
          ),
        ],
      );
    },
  );
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
                openUrl(url: url);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  } else {
    Navigator.of(context).pop();
    openUrl(url: url);
  }
}

void showConstantDialogue(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Text(message),
          actions: [],
        ),
      );
    },
  );
}

Future<bool?> showConfirmDialogue(BuildContext context, String title, String description) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(description),
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
              Navigator.of(context).pop(null);
            },
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}

Future<bool> showFirstTimeDialogue(context, String title, String description, bool cancel) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool firstTimeDialogueShown = prefs.getBool("firstTimeDialogueShown") ?? false;
  bool? selection = false;

  if (!firstTimeDialogueShown) {
    print("showing first time dialogue");
    prefs.setBool("firstTimeDialogueShown", true);
    selection = await showAlertDialogue(context, title, description, cancel, {"show": false}) ?? false;
  } else {
    print("not showing first time dialogue");
    selection = false;
  }

  return selection;
}