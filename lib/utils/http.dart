import 'dart:collection';
import 'dart:io';

class Mai2HttpResponse {
  final int statusCode;
  final Map<String, String> headers;
  final List<int> body;

  Mai2HttpResponse(this.statusCode, this.headers, this.body);
}

class Mai2HttpClient {
  static Future<Mai2HttpResponse> post(
      Uri uri, LinkedHashMap<String, String> headers, List<int> body) async {
    final socket = await SecureSocket.connect(uri.host, uri.port);

    final request = 'POST ${uri.path} HTTP/1.1\r\n'
        '${headers.entries.map((e) => '${e.key}: ${e.value}\r\n').join()}'
        '\r\n';

    socket.add(request.codeUnits);
    socket.add(body);

    await socket.flush();

    var responseCode = "";
    final response = StringBuffer();
    final responseHeaders = <String, String>{};
    final responseBody = <int>[];

    socket.listen((data) {
      response.write(String.fromCharCodes(data));
      final responseString = response.toString();
      final responseParts = responseString.split('\r\n\r\n');

      if (responseParts.length == 2) {
        responseCode = responseParts[0];
        responseBody.addAll(responseParts[1].codeUnits);
      } else if (responseParts.length == 1) {
        responseCode = responseParts[0];
      }

      if (responseCode.isNotEmpty) {
        final responseLines = responseCode.split('\r\n');
        for (var i = 1; i < responseLines.length; i++) {
          final header = responseLines[i].split(':');
          if (header.length == 2) {
            responseHeaders[header[0].trim()] = header[1].trim();
          }
        }
      }

      if (responseHeaders.containsKey('Content-Length')) {
        final contentLength = int.parse(responseHeaders['Content-Length']!);
        if (responseBody.length >= contentLength) {
          socket.close();
        }
      }
    });

    await socket.done;

    return Mai2HttpResponse(
      int.parse(responseCode.split(' ')[1]),
      responseHeaders,
      responseBody,
    );
  }
}
