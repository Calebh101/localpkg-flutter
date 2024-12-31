import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:localpkg/dialogue.dart';

String host = "localhost";
int mode = 1; // 1 is http, 2 is self-signed https, 3 is https

Future<http.Response> getServerData(String endpoint) async {
  http.Response response;
  if (mode == 1) {
    response = await http.get(Uri.parse('http://$host:5000$endpoint'));
  } else if (mode == 2) {
    final byteData = await rootBundle.load('assets/cert/cert.pem');
    final certificate = byteData.buffer.asUint8List();
    final context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(certificate);
    final httpClient = HttpClient(context: context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    final ioClient = IOClient(httpClient);
    response = await ioClient.get(Uri.parse('https://$host:5000$endpoint'));
  } else if (mode == 3) {
    response = await http.get(Uri.parse('https://$host:5000$endpoint'));
  } else {
    response = await http.get(Uri.parse('http://$host:5000$endpoint'));
  }
  return response;
}

/// For checking if the server has a message, warning, or is disabled, and showing messages based on that
Future<bool> serverlaunch(context) async {
  try {
    http.Response response = await getServerData("/api/launch/check");
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var status = true;
      print('server.launch data: $data');
      var general = data["general"];
      var config = general["config"];
      var message = general["message"];
      if (config["message"]) {
        print("server.launch status: message");
        await showAlertDialogue(context, "Server Message", message["message"], false, {"show": true});
        status = true;
      }
      if (config["warning"]) {
        print("server.launch status: warning");
        await showAlertDialogue(context, "Server Message: Warning", message["warning"], false, {"show": true});
        status = true;
      }
      if (config["disable"]) {
        print("server.launch status: disable");
        await showAlertDialogue(context, "Server Disabled", message["disable"], false, {"show": true});
        status = false;
      }
      return status;
    } else {
      print('server.launch error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('server.launch error: $e');
    return false;
  }
}