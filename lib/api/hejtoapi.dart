import 'dart:io';

import 'package:hejto/api/api_request.dart';
import 'package:hejto/api/models/models.dart';

class HejtoApi {

  static const String SESSION_URL = 'https://www.hejto.pl/api/auth/session';

  //TODO (RJ45): move to config class
  Map<String, String>? cookies;
  Session? session;

  Function(Map<String, String>, Session) _saveSession = (cookies, session) => {};

  HejtoApi () {
    
  }

  void loadSession (Map<String, String> cookies, Session session) {
    this.cookies = cookies;
    this.session = session;
  }

  setSession (Map<String, String> cookies, Session session) {
    this.cookies = cookies;
    this.session = session;

    _saveSession(cookies, session);
  }

  setSaveSessionCallback (Function(Map<String, String>, Session) saveSessionCallback) {
    _saveSession = saveSessionCallback;
  }

  Future<bool> tryLogin (Map<String, String> cookies) async {
    Map<String, dynamic> result = await ApiRequest(Uri.parse(SESSION_URL), cookies: cookies).request();
    Session session = Session.fromJson(result);

    if (session.accessToken == null) {
      return false;
    }

    setSession(cookies, session);

    return true;
  }

  Future<Account> getAccount () async {
    Map<String, dynamic> result = await ApiRequest(Uri.parse('https://api.hejto.pl/account'), cookies: cookies, session: session, useBearerAuth: true).request();
    return Account.fromJson(result);
  }
}