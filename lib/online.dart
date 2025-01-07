import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:localpkg/dialogue.dart';
import 'package:localpkg/override.dart';

bool? serverDisabled;
bool _checkServerDisabled = false;
bool _status = true;
final _serverDisabledFuture = Completer<String>();

Future<http.Response> _getServerResponse({required Uri url, required String method, dynamic client, Map? body, String contentType = "application/json"}) async {
  Map<String, String> headers = {
    'Content-Type': contentType,
  };
  String? bodyS;
  if (body != null) {
    bodyS = jsonEncode(body);
  } else {
    bodyS = "{}";
  }

  print("${'-' * ((75 - " SERVER REQUEST ".length) ~/ 2)} SERVER REQUEST ${'-' * ((75 - " SERVER REQUEST ".length + 1) ~/ 2)}");
  print("method".padRight(10) + method);
  print("url".padRight(10) + url.toString());
  print("headers".padRight(10) + jsonEncode(headers));
  print("body".padRight(10) + jsonEncode(body));
  print('-' * 75);

  try {
    switch(method) {
      case 'GET':
        if (client == null) {
          return await http.get(url);
        } else {
          return await client.get(url);
        }
      case 'POST':
        if (bodyS == "") {
          throw Exception("A body is required.");
        }
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

Map getFetchInfo({bool? debug}) {
  debug ??= kDebugMode;
  String host = debug ? "192.168.0.26" : "calebh101.ddns.net";
  int mode = debug ? 1 : 2; // 1 is http, 2 is self-signed https, 3 is https
  return {
    "debug": debug,
    "host": host,
    "mode": mode,
  };
}

Future<http.Response> getServerResponse({required String endpoint, String method = "POST", Map? body, bool? debug}) async {
  Map info = getFetchInfo(debug: debug);
  String host = info["host"];
  int mode = info["mode"];
  debug = info["debug"];
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

@Deprecated("Use getServerData instead.")
Future<dynamic> getServerJsonData(String endpoint) async {
  return await getServerData(endpoint: endpoint);
}

Future<dynamic> getServerData({required String endpoint, bool? debug}) async {
  http.Response response = await getServerResponse(endpoint: endpoint, debug: debug);
  try {
    return json.decode(response.body);
  } catch (e) {
    return response.body;
  }
}

/// For checking if the server has a message, warning, or is disabled, and showing messages based on that
Future<bool> serverlaunch({required BuildContext context, bool override = false}) async {
  if (_checkServerDisabled && !override) {
    return _status;
  }
  try {
    http.Response response = await getServerResponse(endpoint: "/api/launch/check", method: "GET");
    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      print('server.launch data: $data');
      Map general = data["general"];
      Map config = general["config"];
      Map message = general["message"];
      if (config["message"]) {
        print("server.launch status: message");
        showAlertDialogue(context, "Server Message", message["message"], false, {"show": true});
        _status = true;
      }
      if (config["warning"]) {
        print("server.launch status: warning");
        showAlertDialogue(context, "Server Message: Warning", message["warning"], false, {"show": true});
        _status = true;
      }
      if (config["disable"]) {
        print("server.launch status: disable");
        showAlertDialogue(context, "Server Disabled", message["disable"], false, {"show": true});
        _status = false;
        serverDisabled = true;
      } else {
        serverDisabled = false;
      }
      _checkServerDisabled = true;
      _serverDisabledFuture.complete('{"status":$_status}');
      return _status;
    } else {
      print('server.launch error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('server.launch error: $e');
    return false;
  }
}

Future<bool> checkDisabled() async {
  await _serverDisabledFuture.future;
  return !_status;
}