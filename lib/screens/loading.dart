import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hejto/screens/account.dart';
import 'package:hejto/screens/login.dart';

import '../api/models/models.dart';
import '../services/services.dart';

Map<String, String> mapCookiesFromString(String stringCookies) {
  List cookiesList = stringCookies.split('; ');
  cookiesList.map((e) => e.split('='));

  Map<String, String> cookies = Map();

  cookiesList.forEach((cookie) {
    cookies[cookie[0]] = cookie[1];
  });

  return cookies;
}

class LoadingScreen extends StatefulWidget {
  
  @override
  _LoadingScreenState createState() => new _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  _LoadingScreenState() {
    HejtoApiService apiService = HejtoApiService();
  }

  loadConfig () async {
    FlutterSecureStorage storage = const FlutterSecureStorage();

    HejtoApiService.instance.setSaveSessionCallback((cookies, session) {
      storage.write(key: 'cookies', value: stringifyCookies(cookies));
      storage.write(key: 'session', value: jsonEncode(session));
    });
    
    
    String stringCookies = await storage.read(key: 'cookies') ?? '';
    String stringSession = await storage.read(key: 'session') ?? '';

    if (stringCookies.length == 0 || stringSession == null) {
      log('[Loading] session not found in device');

      Navigator.of(context).pushReplacement(_createRoute(LoginScreen()));
      return;
    }


    Map<String, String> cookies = mapCookiesFromString(stringCookies);
    Session session = Session.fromJson(jsonDecode(stringSession));

    HejtoApiService.instance.loadSession(cookies, session);

    log('[Loading] session is loaded');
    Navigator.of(context).pushReplacement(_createRoute(AccountScreen()));
  }

   @override
  Widget build(BuildContext context) {
    loadConfig();

    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children:const [
              CircularProgressIndicator(),
              Text('Trwa ładowanie konfiguracji...')
            ],
          )
        )
      )
    );
  }
}

Route _createRoute(Widget screen) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}