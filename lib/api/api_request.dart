import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import 'models/models.dart';

enum RequestMethod {
  GET,
  POST,
  PUT,
  DELETE
}

class ApiRequest {

  final ApiConfig apiConfig;

  final Uri uri;
  final RequestMethod method;

  Map<String, String> headers = {};
  Map<String, String> cookies = {};
  bool useCookiesAuth;

  ApiRequest(this.apiConfig, this.uri, {
    this.method = RequestMethod.GET,
    this.useCookiesAuth = false
  }) {

    headers['User-Agent'] = apiConfig.useragent;

    if (useCookiesAuth) {
      headers['Cookie'] = '';

      apiConfig.cookies.forEach((key, value) {
        String oldValue = headers['Cookie'] ?? '';
        if (oldValue.isEmpty) {
          headers['Cookie'] = '$key=$value';
        } else {
          headers['Cookie'] = '$oldValue; $key=$value';
        }
      });
    }

    if (!useCookiesAuth) {
      String accessToken = apiConfig.session.accessToken ?? '';
      headers['authorization'] = 'Bearer $accessToken';
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