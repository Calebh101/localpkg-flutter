import 'dart:ui';
import 'package:flutter/material.dart';

Widget Setting({
  required String title,
  required String desc,
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
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
}) {
  return Column(
    children: [
      SettingTitle(title: "About"),
      Setting(
        title: "About",
        desc: about,
        text: "",
        action: () {},
      ),
      Setting(
        title: "Version",
        desc: "Version and channel info.",
        text: "Version: $version\nChannel: ${beta ? "Beta" : "Stable"}",
        action: () {},
      ),
      Setting(
        title: "Author",
        desc: "Author and ownership info.",
        text: "Author: Calebh101",
        action: () {},
      ),
      Setting(
        title: "Licenses",
        desc: "License and engine info.",
        text: "",
        action: () {
          showLicensePage(context: context, applicationVersion: version, applicationLegalese: about);
        }
      ),
    ],
  );
}