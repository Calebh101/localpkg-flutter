import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:localpkg/dialogue.dart';

String host = kDebugMode ? "192.168.0.26" : "calebh101.ddns.net";
int mode = kDebugMode ? 1 : 2; // 1 is http, 2 is self-signed https, 3 is https

Future<http.Response> _getServerResponse({required Uri url, required String method, dynamic client, Map? body, String contentType = "application/json"}) async {
  Map<String, String> headers = {
    'Content-Type': contentType,
  };
  String? bodyS;
  if (body != null) {
    bodyS = jsonEncode(body);
  }
  print("--- sending server request ---\nurl:      $url\nheaders:  $headers\nbody:     $bodyS\n------------------------------");
  try {
    switch(method) {
      case 'GET':
        if (client == null) {
          return await http.get(url);
        } else {
          return await client.get(url);
        }
      case 'POST':
        if (client == null) {
          return await http.post(
            url,
            headers: headers,
            body: bodyS,
          );
        } else {
          return await client.post(
            url,
            headers: headers,
            body: bodyS,
          );
        }
      case 'OPTIONS':
        throw Exception("OPTIONS is currently not supported as a method.");
      default:
        throw Exception("Unknown method: $method (tip: it needs to be in all caps, like GET or OPTIONS)");
    }
  } catch (e) {
    throw Exception("_getServerResponse Exception: $e");
  }
}

Future<http.Response> getServerResponse({required String endpoint, String method = "POST", Map? body, bool? debug}) async {
  debug ??= kDebugMode;
  String host = debug ? "192.168.0.26" : "calebh101.ddns.net";
  int mode = debug ? 1 : 2; // 1 is http, 2 is self-signed https, 3 is https
  http.Response response;

  if (mode == 1) {
    response = await _getServerResponse(url: Uri.parse('http://$host:5000$endpoint'), method: method, body: body);
  } else if (mode == 2) {
    final byteData = await rootBundle.load('assets/cert/cert.pem');
    final certificate = byteData.buffer.asUint8List();
    final context = SecurityContext(withTrustedRoots: false);
    context.setTrustedCertificatesBytes(certificate);
    final httpClient = HttpClient(context: context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
    final client = IOClient(httpClient);
    response = await _getServerResponse(url: Uri.parse('https://$host:5000$endpoint'), method: method, client: client, body: body);
  } else if (mode == 3) {
    response = await _getServerResponse(url: Uri.parse('https://$host:5000$endpoint'), method: method, body: body);
  } else {
    throw Exception("Unknown mode: $mode");
  }

  return response;
}

@ Deprecated("Use getServerData instead.")
Future<dynamic> getServerJsonData(String endpoint) async {
  return await getServerData(endpoint: endpoint);
}

Future<dynamic> getServerData({required String endpoint}) async {
  http.Response response = await getServerResponse(endpoint: endpoint);
  try {
    return json.decode(response.body);
  } catch (e) {
    return response.body;
  }
}

/// For checking if the server has a message, warning, or is disabled, and showing messages based on that
Future<bool> serverlaunch(context) async {
  try {
    http.Response response = await getServerResponse(endpoint: "/api/launch/check", method: "GET");
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