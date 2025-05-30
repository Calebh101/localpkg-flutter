import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localpkg/theme.dart';
import 'package:localpkg/tipjar.dart';

export 'package:localpkg/theme.dart' show GradientColor, buildGradientColors;

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

Widget Section({Widget? child, bool expanded = true}) {
  Widget childS = Center(
    child: child,
  );
  return expanded ? Expanded(
    child: childS,
  ) : Container(
    child: childS,
  );
}

@Deprecated("Use Text().gradient() instead.")
class GradientText extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final List<GradientColor> colors;
  const GradientText(this.data, {super.key, this.style, required this.colors});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: buildGradientColors(colors),
      ).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        data,
        style: (style ?? TextStyle()).copyWith(color: Colors.white),
      ),
    );
  }
}

// ignore: must_be_immutable
class ScrollWidget extends StatelessWidget {
  final Key? scrollViewKey;
  final Key? scrollbarKey;
  final Widget child;
  final bool showScrollbar;
  final ScrollController? controller;
  final bool? thumbVisibility;
  final bool? trackVisibility;
  final double? scrollbarThickness;
  final Radius? scrollbarRadius;
  final bool Function(ScrollNotification)? scrollbarNotificationsPredicate;
  final bool? scrollbarInteractive;
  final ScrollbarOrientation? scrollbarOrientation;

  final Axis scrollViewScrollDirection;
  final bool scrollViewReverse;
  final EdgeInsetsGeometry? scrollViewPadding;
  final bool? scrollViewPrimary;
  final ScrollPhysics? scrollViewPhysics;
  final DragStartBehavior scrollViewDragStartBehavior;
  final Clip scrollViewClipBehavior;
  final HitTestBehavior scrollViewHitTestBehavior;
  final String? scrollViewRestorationId;
  final ScrollViewKeyboardDismissBehavior scrollViewKeyboardDismissBehavior;

  ScrollWidget({super.key, this.scrollViewKey, this.scrollbarKey, required this.child, this.showScrollbar = true, this.controller, this.thumbVisibility, this.trackVisibility, this.scrollbarThickness, this.scrollbarRadius, this.scrollbarNotificationsPredicate, this.scrollbarInteractive, this.scrollbarOrientation, this.scrollViewScrollDirection = Axis.vertical, this.scrollViewReverse = false, this.scrollViewPadding, this.scrollViewPrimary, this.scrollViewPhysics, this.scrollViewDragStartBehavior = DragStartBehavior.start, this.scrollViewClipBehavior = Clip.hardEdge, this.scrollViewHitTestBehavior = HitTestBehavior.opaque, this.scrollViewRestorationId, this.scrollViewKeyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual});

  ScrollController defaultController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Widget result;
    Widget scrollView = SingleChildScrollView(
      key: scrollViewKey,
      child: child,
      controller: controller ?? defaultController,
      scrollDirection: scrollViewScrollDirection,
      reverse: scrollViewReverse,
      padding: scrollViewPadding,
      primary: scrollViewPrimary,
      physics: scrollViewPhysics,
      dragStartBehavior: scrollViewDragStartBehavior,
      clipBehavior: scrollViewClipBehavior,
      hitTestBehavior: scrollViewHitTestBehavior,
      restorationId: scrollViewRestorationId,
      keyboardDismissBehavior: scrollViewKeyboardDismissBehavior,
    );

    if (showScrollbar) {
      result = Scrollbar(
        key: scrollbarKey,
        child: scrollView,
        controller: controller ?? defaultController,
        thumbVisibility: thumbVisibility,
        trackVisibility: trackVisibility,
        thickness: scrollbarThickness,
        radius: scrollbarRadius,
        notificationPredicate: scrollbarNotificationsPredicate,
        interactive: scrollbarInteractive,
        scrollbarOrientation: scrollbarOrientation,
      );
    } else {
      result = scrollView;
    }

    return result;
  }
}