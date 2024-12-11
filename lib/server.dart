import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<Map> hostFile(File file, String name,
    {int port = 4285, bool useHttps = false, bool useHttpsUrl = false}) async {
  print("Hosting file...");

  try {
    // Get the application documents directory
    final directory = await getApplicationDocumentsDirectory();

    // Create the 'assets' subdirectory inside the app's documents directory
    final staticFilesDirectory = Directory('${directory.path}/assets');
    if (!await staticFilesDirectory.exists()) {
      await staticFilesDirectory.create(recursive: true);
    }

    // Save the file to the assets directory
    final filePath = '${staticFilesDirectory.path}/$name';
    await file.copy(filePath);
    print('File saved at: $filePath');

    // Set up the server URL
    const hostname = 'localhost';
    String url = "http${useHttpsUrl ? "s" : ""}://$hostname:$port/";

    // Set up the static file handler
    final staticFilesHandler = VirtualDirectory(staticFilesDirectory.path)
      ..allowDirectoryListing = true;

    // Try binding to the server. If port is in use, increment the port number.
    late HttpServer server;
    try {
      if (useHttps) {
        // Load the certificate and key as strings from the asset bundle
        final cert = await rootBundle.loadString('assets/cert/localhost.crt');
        final key = await rootBundle.loadString('assets/cert/localhost.key');

        // Create temporary files to hold the certificate and key
        final certFile = File('${Directory.systemTemp.path}/localhost.crt')
          ..writeAsStringSync(cert);
        final keyFile = File('${Directory.systemTemp.path}/localhost.key')
          ..writeAsStringSync(key);

        // Create a SecurityContext and load the certificate and key
        final securityContext = SecurityContext()
          ..useCertificateChain(certFile.path)
          ..usePrivateKey(keyFile.path);

        server = await HttpServer.bindSecure(hostname, port, securityContext,
            shared: true);
      } else {
        server = await HttpServer.bind(hostname, port, shared: true);
      }
      print('Server is now running at $url');
    } catch (e) {
      if (e is SocketException) {
        // If the port is in use, try a different port (or handle accordingly)
        print('Port $port is already in use. Trying a different port...');
        return await hostFile(file, name, port: port + 1);
      } else {
        rethrow; // Rethrow other exceptions
      }
    }

    handleRequests(server, staticFilesHandler, filePath);
    return {"status": true, "port": port, "url": url};
  } catch (e) {
    return {"status": false, "error": e.toString()};
  }
}

void handleRequests(
    HttpServer server, dynamic staticFilesHandler, String filePath) async {
  await for (final request in server) {
    try {
      print('incoming request: ${request.uri}');

      request.response
        ..headers.add('Access-Control-Allow-Origin', '*')
        ..headers.add(
            'Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
        ..headers.add('Access-Control-Allow-Headers', '*')
        ..headers.add('Access-Control-Allow-Credentials', 'true');

      if (request.method == 'OPTIONS') {
        print("outgoing options: ${request.uri}");
        printResponse(true, request, null, "options");
        request.response.statusCode = HttpStatus.ok;
        await request.response.close();
      } else {
        final file = File(filePath);
        if (await file.exists()) {
          print('outgoing serve: ${request.uri}');
          printResponse(true, request, null, "serve");
          staticFilesHandler.serveRequest(request);
        } else {
          print('file not found: ${request.uri}');
          printResponse(false, request, "404", "serve");
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('404');
          await request.response.close();
        }
      }
    } catch (e) {
      print("unable to handle incoming request from ${request.uri}");
      printResponse(false, request, e.toString(), "generic");
      request.response
        ..statusCode = HttpStatus.internalServerError
        ..write('500');
      await request.response.close();
    }
  }
}

void printResponse(bool success, request, String? error, String type) {
  if (success) {
    print("$type request successful: ${request.uri}");
  } else {
    print(
        "$type request unsuccessful: ${request.uri}${error != null ? ": ${error}" : ""}");
  }
}
