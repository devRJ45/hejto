import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/models.dart';

enum RequestMethod {
  GET,
  POST,
  PUT,
  DELETE
}

class ApiRequest {

  final Uri uri;
  final RequestMethod method;

  Map<String, String>? headers;
  Map<String, String>? cookies;
  Session? session;
  bool useBearerAuth;

  ApiRequest(this.uri, {
    this.method = RequestMethod.GET,
    this.headers,
    this.cookies,
    this.session,
    this.useBearerAuth = false
  }) {
    headers ??= {};

    headers?['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36';

    if (cookies != null && !useBearerAuth) {
      headers?['Cookie'] = '';

      cookies!.forEach((key, value) {
        String oldValue = headers?['Cookie'] ?? '';
        if (oldValue.length == 0) {
          headers?['Cookie'] = '${key}=${value}';
        } else {
          headers?['Cookie'] = '${oldValue}; ${key}=${value}';
        }
      });
    }

    if (useBearerAuth) {
      String accessToken = session?.accessToken ?? '';
      headers?['authorization'] = 'Bearer ${accessToken}';
    }
  }

  Future<Map<String, dynamic>> request () async {
    http.Response res;

    switch (method) {
      case RequestMethod.GET:
      default:
        res = await http.get(uri, headers: headers);
        break;
    }

    return jsonDecode(res.body);
  }
}