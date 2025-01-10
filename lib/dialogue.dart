import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localpkg/functions.dart';
import 'package:localpkg/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void showSnackBar(context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(content)),
  );
}

Future<bool?> showDialogue({
  required BuildContext context,
  required String title,
  required Widget content,
  bool cancel = false,
  bool fullscreen = false,
  bool copy = false,
  String? copyText,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          width: fullscreen ? MediaQuery.of(context).size.width * 0.95 : null,
          height: fullscreen ? MediaQuery.of(context).size.height * 0.95 : null,
          child: content,
        ),
        actions: [
          copy ? TextButton(
                  child: const Text('Copy'),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: copyText ?? ""));
                    showSnackBar(context, "Copied to clipboard!");
                  },
                )
              : const SizedBox.shrink(),
          cancel  ? TextButton(
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

@Deprecated("Use showDialogue instead.")
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

void showConstantDialogue({required BuildContext context, required String title, String? message}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: message != null ? Text(message) : SizedBox.shrink(),
          actions: [],
        ),
      );
    },
  );
}

Future<bool?> showConfirmDialogue({required BuildContext context, required String title, String? description, bool onOff = false}) async {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: description != null ? Text(description) : SizedBox.shrink(),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(onOff ? 'On' : 'Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(onOff ? 'Off' : 'No'),
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
    selection = await showDialogue(context: context, title: title, content: Text(description)) ?? false;
  } else {
    print("not showing first time dialogue");
    selection = false;
  }

  return selection;
}