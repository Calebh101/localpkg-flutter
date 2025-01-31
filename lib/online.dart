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
Map versions = {};
final _serverDisabledFuture = Completer<String>();

Future<http.Response> _getServerResponse({required Uri url, required String method, dynamic client, Map? body, String contentType = "application/json", String? authToken}) async {
  body ??= {};
  String? bodyS;

  Map<String, String> headers = {
    'Content-Type': contentType,
  };

  if (authToken != null) {
    headers["Authorization"] = "Bearer $authToken";
  }

  if (body != {}) {
    bodyS = jsonEncode(body);
  } else {
    bodyS = "{}";
  }

  String title = "HTTP REQUEST";
  int length = 50;

  print("${'-' * ((length - " $title ".length) ~/ 2)} $title ${'-' * ((length - " $title ".length + 1) ~/ 2)}");
  print("method".padRight(10) + method);
  print("url".padRight(10) + url.toString());
  print("headers".padRight(10) + jsonEncode(headers));
  print("body".padRight(10) + jsonEncode(body));
  print("client".padRight(10) + client.runtimeType.toString());
  print('-' * length);

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

Future<http.Response> getServerResponse({required String endpoint, String method = "POST", Map? body, String? authToken}) async {
  Map info = getFetchInfo();
  String host = info["host"];
  int mode = info["mode"];
  String protocol = 'http';
  int? port;
  bool debug = info["debug"];
  http.Response response;

  if (mode == 3) {
    protocol = 'https';
  }

  if (debug) {
    port = 5000;
  }

  if (endpoint.startsWith('/')) {
    endpoint = endpoint.replaceFirst('/', '');
  }

  if (endpoint.startsWith('api/')) {
    warn('Endpoints should not start with \'api/\' or \'/api/\'. Prefixes like these are automatically handled.');
    endpoint = endpoint.replaceFirst('api/', '');
  }

  String url = "$protocol://$host${port != null ? ":$port" : ""}/api/$endpoint";
  Uri uri = Uri.parse(url);

  if (mode == 2) {
    throw UnimplementedError("Using self-signed certificates is deprecated.");
  } else if (mode == 1 || mode == 3) {
    response = await _getServerResponse(url: uri, method: method, body: body, authToken: authToken);
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

Future<dynamic> getServerData({required String endpoint, String? authToken, required String method, Map? body}) async {
  http.Response response = await getServerResponse(method: method, body: body, endpoint: endpoint, authToken: authToken);
  try {
    return jsonDecode(response.body);
  } catch (e) {
    warn("invalid response: ${response.body.runtimeType}");
    return response.body;
  }
}

Future<http.Response> getWebResponse({required Uri url, String method = "POST", Map? body}) async {
  Map info = getFetchInfo();
  bool debug = info["debug"];
  http.Response response = await _getServerResponse(url: url, method: method, body: body);
  return response;
}

Future<dynamic> getWebData({required Uri url, String? authToken, required String method, Map? body}) async {
  http.Response response = await getWebResponse(method: method, body: body, url: url);
  try {
    return jsonDecode(response.body);
  } catch (e) {
    warn("invalid response: ${response.body.runtimeType}");
    return response.body;
  }
}

double parseVersion(String input, {int base = 2}) {
  int letter = 0;
  RegExp regex = RegExp(r'^[a-zA-Z0-9.]*$');
  String letters = input.replaceAll(RegExp(r'[^a-zA-Z]'), '');

  if (letters.length == 1) {
    letter = letters[0].codeUnitAt(0) - 65;
  }

  if (!regex.hasMatch(input)) {
    throw Exception("Invalid version (not alphanumeric with periods): $input");
  }

  String inputS = input.replaceAll(RegExp(r'[^0-9.]'), '');
  String code = "$inputS${".${letter.toString().padLeft(base, '0')}"}";

  List<String> segments = code.split('.');
  String result = '';

  for (var segment in segments) {
    result += segment.toString().padLeft(base, '0');
  }

  print("parsed version $input to $result");
  return double.tryParse(result) ?? 0;
}

Future<bool> serverlaunch({required BuildContext context, required String service, bool override = false, String? version}) async {
  print("running server.launch...");
  Map info = getFetchInfo();
  if (_checkServerDisabled && !override && info["debug"] == false) {
    return _status;
  }
  try {
    http.Response response = await getServerResponse(endpoint: "launch/check?service=all", method: "GET");
    if (response.statusCode == 200) {
      bool update = false;
      bool generic = service == "general" || service == "all";
      Map data = json.decode(response.body);
      Map general = data["general"];

      Map versionsXS = general["version"];
      Map versions = {
        "server": versionsXS["server"],
        "account": versionsXS["account"],
        "localpkg": versionsXS["localpkg"],
      };

      if (!generic) {
        Map versionsSS = data["services"][service]["version"];
        versions["current"] = versionsSS["current"];
        versions["lowest"] = versionsSS["lowest"];
        if (version != null) {
          double current = parseVersion(version);
          double lowest = parseVersion(versions["lowest"]);
          if (current < lowest) {
            update = true;
          }
        }
      }

      _status = _checkDisabled(context, general, update: update);
      _status = generic ? _status : _checkDisabled(context, data["services"][service], update: update);
      _checkServerDisabled = true;
      if (!_serverDisabledFuture.isCompleted) {
        _serverDisabledFuture.complete('{"status":$_status}');
      }
      return _status;
    } else {
      print('server.launch[2] error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('server.launch[1] error: $e');
    return false;
  }
}

Future<Map> _report({required String event, required Map report, String? token}) async {
  return await getServerData(endpoint: 'analytics/add', method: 'POST', authToken: token, body: {
    "event": event,
    "report": report,
  });
}

Future<Map> report({required String event, required Map report}) async {
  report["feature-flags"] = featureFlags;
  return await _report(event: event, report: report);
}

bool _checkDisabled(context, data, {required bool update}) {
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
  String? token;

  User({
    required this.email,
    required this.password,
    required this.username,
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
    Map info = getFetchInfo();
    Map response = await getServerData(method: "POST", endpoint: "auth/login", body: {"email": email, "password": password});
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
    Map info = getFetchInfo();
    Map response = await getServerData(endpoint: 'auth/register', method: "POST", body: {"email": email, "password": password, "username": username});
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
      Map info = getFetchInfo();
      Map response = await getServerData(endpoint: endpoint, method: method, body: body, authToken: token);
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