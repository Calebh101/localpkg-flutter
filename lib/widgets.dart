import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:localpkg/tipjar.dart';

Widget Setting({
  required String title,
  String? desc,
  String? text,
  GestureTapCallback? action,
  }) {
  return InkWell(
    onTap: action ?? () {},
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                if (desc != null)
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          if (text != null)
            Text(
              text,
            )
        ],
      ),
    ),
  );
}

Widget SettingTitle({
  required String title,
}) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
        ),
      ),
    ),
  );
}

Widget SettingButton({
  required String title,
  required GestureTapCallback action,
  required BuildContext context,
}) {
  return Center(
    child: ElevatedButton(
      onPressed: action,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 40),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: const TextStyle(fontSize: 18),
      ),
      child: Text(title),
    ),
  );
}

Widget AboutSettings({
  required BuildContext context,
  required String version,
  required bool beta,
  required String about,
  Widget? icon,
}) {
  return Column(
    children: [
      SettingTitle(title: "About"),
      Setting(
        title: "About",
        desc: about,
      ),
      Setting(
        title: "Version",
        desc: "Version and channel info.",
        text: "Version: $version\nChannel: ${beta ? "Beta" : "Stable"}",
      ),
      Setting(
        title: "Author",
        desc: "Author and ownership info.",
        text: "Author: Calebh101",
      ),
      Setting(
        title: "Licenses",
        desc: "License and engine info.",
        action: () {
          showLicensePage(context: context, applicationVersion: version, applicationLegalese: about, applicationIcon: icon);
        }
      ),
      Setting(
        title: "Tip Jar",
        desc: "If you want to support me, here is the place!",
        action: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TipJar()),
          );
        }
      ),
    ],
  );
}