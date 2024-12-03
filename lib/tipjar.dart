import 'package:flutter/material.dart';
import 'package:localpkg/dialogue.dart';
import 'package:localpkg/widgets.dart';

class TipJar extends StatefulWidget {
  const TipJar({super.key});

  @override
  State<TipJar> createState() => _TipJarState();
}

class _TipJarState extends State<TipJar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tip Jar"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SettingTitle(title: "One-time tips"),
          Setting(
            title: "\$1",
            action: () {
              _makeTipPurchase(context, "1o");
            }
          ),
        ],
      ),
    );
  }
}

Future<bool> _makeTipPurchase(BuildContext context, String id) async {
  bool response = await makeTipPurchase(id);
  if (response) {
    showSnackBar(context, "Thank you for buying a ${getTipString(id)} tip!");
    return true;
  } else {
    return false;
  }
}

Future<bool> makeTipPurchase(String id) async {
  return true;
}

String getTipString(String id) {
  switch (id) {
    case "1o":
      return "\$1.00";
    case "2o":
      return "\$2.00";
    case "5o":
      return "\$5.00";
    case "10o":
      return "\$10.00";
    case "1m":
      return "\$1.00 monthly";
    case "2m":
      return "\$2.00 monthly";
    case "3m":
      return "\$3.00 monthly";
    case "5m":
      return "\$5.00 monthly";
    case "10m":
      return "\$10.00 monthly";
    case "1w":
      return "\$1.00 weekly";
    case "3w":
      return "\$3.00 weekly";
    default:
      return id;
  }
}