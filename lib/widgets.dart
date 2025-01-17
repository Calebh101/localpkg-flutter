import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Center(
      child: ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 40),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: const TextStyle(fontSize: 18),
        ),
        child: Text(title),
      ),
    ),
  );
}

Widget AboutSettings({
  required BuildContext context,
  required String version,
  required bool beta,
  required String about,
  bool debug = false,
  bool tipjar = false,
  bool instructionsPage = true,
  Widget? icon,
  GestureTapCallback? debugAction,
  GestureTapCallback? instructionsAction,
}) {
  return Column(
    children: [
      SettingTitle(title: "About"),
      Setting(
        title: "About",
        desc: about,
      ),
      if (instructionsPage)
      Setting(
        title: "Instructions",
        desc: "How to use this application and service.",
        action: instructionsAction,
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
            showLicensePage(
              context: context,
              applicationVersion: version,
              applicationLegalese: about,
              applicationIcon: icon,
            );
          }),
      if (tipjar)
        Setting(
            title: "Tip Jar",
            desc: "If you want to support me, here is the place!",
            action: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TipJar()),
              );
            }),
      if (debug)
        Setting(
          title: "Debug Options",
          desc:
              "Show debug options. This can mess up the user interface and/or show unreliable/empty data.",
          action: debugAction,
        ),
    ],
  );
}

Widget customFaIcon(
  IconData icon, {
  double size = 22,
  double? setWidth,
  double? setHeight,
  Color? color,
}) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(
      width: setWidth,
      height: setHeight,
      child: FaIcon(
        icon,
        size: size,
        color: color,
      ),
    ),
  ]);
}

Widget BlockButton({required String text, required double size, required VoidCallback action, double? width, double? height}) {
  width ??= size;
  height ??= size / 2;
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)), // Square edges
        ),
      ),
      onPressed: action,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size / 10,
        ),
      ),
    ),
  );
}

Widget Section({Widget? child, double? height}) {
  Widget childS = Center(
    child: child,
  );
  return Container(
    height: height,
    child: Expanded(
      child: childS,
    ),
  );
}
