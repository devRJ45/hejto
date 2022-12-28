import 'dart:io';

import 'package:hejto/api/api_config.dart';
import 'package:hejto/api/api_request.dart';
import 'package:hejto/api/models/models.dart';

class HejtoApi {

  static const String SESSION_URL = 'https://www.hejto.pl/api/auth/session';

  ApiConfig apiConfig = ApiConfig(host: 'api.hejto.pl');
  Function(Map<String, String>, Session) _saveSession = (cookies, session) => {};

  HejtoApi () {
    
  }

  void loadSession (Map<String, String> cookies, Session session) {
    apiConfig.updateCookies(cookies);
    apiConfig.updateSession(session);
  }

  setSession (Map<String, String> cookies, Session session) {
    apiConfig.updateCookies(cookies);
    apiConfig.updateSession(session);

    _saveSession(cookies, session);
  }

  setSaveSessionCallback (Function(Map<String, String>, Session) saveSessionCallback) {
    _saveSession = saveSessionCallback;
  }

  Future<bool> tryLogin (Map<String, String> cookies) async {
    Map<String, dynamic> result = await ApiRequest(apiConfig, Uri.parse(SESSION_URL), useCookiesAuth: true).request();
    Session session = Session.fromJson(result);

    if (session.accessToken == null) {
      return false;
    }

    setSession(cookies, session);

    return true;
  }

  Future<Account> getAccount () async {
    Uri uri = Uri.https(apiConfig.host, 'account');

    Map<String, dynamic> result = await ApiRequest(apiConfig, uri).request();
    return Account.fromJson(result);
  }
}