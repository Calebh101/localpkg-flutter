import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localpkg/dialogue.dart';
import 'package:localpkg/logger.dart';

bool useHttps = false;
bool? serverDisabled;
bool _checkServerDisabled = false;
bool _status = true;
List<String> featureFlags = [];
final _serverDisabledFuture = Completer<String>();

Future<http.Response> _getServerResponse({required Uri url, required String method, dynamic client, Map? body, String contentType = "application/json", String? authToken}) async {
  Map<String, String> headers = {
    'Content-Type': contentType,
  };

  if (authToken != null) {
    headers["Authorization"] = "Bearer $authToken";
  }

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
  String host = debug ? "192.168.0.26" : "calebh101.com";
  int mode = useHttps ? 3 : 1;
  return {
    "debug": debug,
    "host": host,
    "mode": mode,
  };
}

Future<http.Response> getServerResponse({required String endpoint, String method = "POST", Map? body, bool? debug, String? authToken}) async {
  Map info = getFetchInfo(debug: debug);
  String host = info["host"];
  int mode = info["mode"];
  debug = info["debug"];
  http.Response response;

  if (mode == 1) {
    response = await _getServerResponse(url: Uri.parse('http://$host:5000$endpoint'), method: method, body: body, authToken: authToken);
  } else if (mode == 2) {
    throw UnimplementedError("Using self-signed certificates is deprecated.");
  } else if (mode == 3) {
    response = await _getServerResponse(url: Uri.parse('https://$host:5000$endpoint'), method: method, body: body, authToken: authToken);
  } else {
    throw Exception("Unknown mode: $mode");
  }

  featureFlags = response.headers["X-Feature-Flags"]?.split(', ').map((item) => item.trim()).toList() ?? [];
  return response;
}

@Deprecated("Use getServerData instead.")
Future<dynamic> getServerJsonData(String endpoint) async {
  return await getServerData(method: "GET", endpoint: endpoint);
}

Future<dynamic> getServerData({required String endpoint, bool? debug, String? authToken, required String method, Map? body}) async {
  http.Response response = await getServerResponse(method: method, body: body, endpoint: endpoint, debug: debug, authToken: authToken);
  try {
    return jsonDecode(response.body);
  } catch (e) {
    warn("invalid response: ${response.body.runtimeType}");
    print("response: ${response.body.replaceAll("\n", "[newline]")}");
  }
}

Future<bool> serverlaunch({required BuildContext context, required String service, bool override = false, String? version}) async {
  if (_checkServerDisabled && !override) {
    return _status;
  }
  try {
    http.Response response = await getServerResponse(endpoint: "/api/launch/check?service=all", method: "GET");
    if (response.statusCode == 200) {
      Map data = json.decode(response.body);
      Map general = data["general"];
      _status = _checkDisabled(context, general);
      _status = service == "general" || service == "all" ? _status : _checkDisabled(context, data["services"][service]);
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

Future<Map> _report({required String event, required Map report, String? token, bool? debug}) async {
  return await getServerData(endpoint: '/api/analytics/add', method: 'POST', debug: debug, authToken: token, body: {
    "event": event,
    "report": report,
  });
}

Future<Map> report({required String event, required Map report}) async {
  report["feature-flags"] = featureFlags;
  return await _report(event: event, report: report);
}

bool _checkDisabled(context, data) {
  bool statusS = true;
  Map config = data["config"];
  Map message = data["message"];
  if (config["message"]) {
    print("server.launch status: message");
    showAlertDialogue(context, "Server Message", message["message"], false, {"show": true});
  }
  if (config["warning"]) {
    print("server.launch status: warning");
    showAlertDialogue(context, "Server Warning", message["warning"], false, {"show": true});
  }
  if (config["disable"]) {
    print("server.launch status: disable");
    showAlertDialogue(context, "Server Disabled", message["disable"], false, {"show": true});
    statusS = false;
  }
  return statusS;
}

Future<bool> checkDisabled() async {
  await _serverDisabledFuture.future;
  return !_status;
}

class User {
  String email;
  String password;
  String username;
  bool? debug;
  String? token;

  User({
    required this.email,
    required this.password,
    required this.username,
    this.debug,
  });

  int _crashSafe = 0;

  Map info() {
    return {
      "email": email,
      "password": password,
      "username": username,
      "token": token ?? "",
    };
  }

  @override
  String toString() {
    return username;
  }

  Future<Map> report({required String event, required Map report}) async {
    return await _report(event: event, report: report);
  }

  Future<Map> login() async {
    Map info = getFetchInfo(debug: debug);
    Map response = await getServerData(method: "POST", endpoint: "/api/auth/login", debug: info["debug"], body: {"email": email, "password": password});
    if (response.containsKey("error")) {
      report(event: "error-login", report: {"error": response["error"]});
      return response;
    } else {
      token = response["token"];
      report(event: "login", report: {});
      return response;
    }
  }

  Future<Map> register() async {
    Map info = getFetchInfo(debug: debug);
    Map response = await getServerData(endpoint: '/api/auth/register', method: "POST", debug: info["debug"], body: {"email": email, "password": password, "username": username});
    if (response.containsKey("error")) {
      report(event: "error-register", report: {"error": response["error"]});
      return response;
    } else {
      token = response["token"];
      report(event: "register", report: {});
      return response;
    }
  }

  void _resetCrashSafe() {
    _crashSafe = 0;
  }

  Future<Map> request({required String method, required String endpoint, Map? body}) async {
    _resetCrashSafe();
    return await _request(method: method, endpoint: endpoint, body: body);
  }

  Future<Map> _request({required String method, required String endpoint, Map? body}) async {
    _crashSafe++;
    if (_crashSafe >= 3) {
      error("crashSafe exception: _crashSafe is $_crashSafe");
      return {"error": "stack overflow"};
    }
    print("token: ${token.runtimeType}:${token?.isNotEmpty}");
    if (token?.isNotEmpty == true) {
      Map info = getFetchInfo(debug: debug);
      Map response = await getServerData(endpoint: endpoint, method: method, body: body, debug: info["debug"], authToken: token);
      return response;
    } else {
      Map response = await login();
      if (response.containsKey("error")) {
        return response;
      } else {
        return await _request(method: method, endpoint: endpoint, body: body);
      }
    }
  }
}