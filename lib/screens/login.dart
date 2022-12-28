import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hejto/screens/screens.dart';
import 'package:hejto/services/hejtoapi.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      userAgent: 'random',
      javaScriptEnabled: true,
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      useOnLoadResource: true,
      cacheEnabled: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    )
  );

  late PullToRefreshController pullToRefreshController;

  final CookieManager cookieManager = CookieManager.instance();

  final String loginUrl = 'https://hejto.pl/logowanie?redirect=kontakt?loggedIn';
  final String cookiesUrl = 'https://www.hejto.pl';

  bool _sessionIsChecking = false;

  void checkSession () async {
    setState(() {
      _sessionIsChecking = true;
    });

    List<Cookie> cookies = await cookieManager.getCookies(url: Uri.parse(cookiesUrl));

    Map<String, String> cookiesMap = Map();

    for (var cookie in cookies) {
      cookiesMap[cookie.name] = cookie.value;
    }

    bool isLoggedIn = await HejtoApiService.instance.tryLogin(cookiesMap);

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(_createRoute(AccountScreen()));
      return;
    }

    setState(() {
      _sessionIsChecking = false;
    });
  }

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logowanie hejto.pl")),
      body: SafeArea(
        left: true,
        right: true,
        child: 
          !_sessionIsChecking ?
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: Uri.parse(loginUrl)),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              androidOnPermissionRequest: (controller, origin, resources) async {
                return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                if (!_sessionIsChecking && url?.path == '/kontakt' && url?.query == 'loggedIn') {
                  checkSession();
                }
              },
            )
          : Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                Text('Sprawdzanie sesji...')
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