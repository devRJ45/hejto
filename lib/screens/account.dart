
import 'package:flutter/material.dart';
import 'package:hejto/screens/screens.dart';
import 'package:hejto/services/hejtoapi.dart';

import '../api/models/models.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => new _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  String _username = '';

  @override
  void initState() {
    super.initState();

    _username = '...';

    fetchAccount();
  }

  void fetchAccount () async {
    try {
      Account account = await HejtoApiService.instance.getAccount();
      
      setState(() {
        _username = account.username;
      });
    } catch (e) {
      Navigator.of(context).pushReplacement(_createRoute(LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Account screen")),
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Text('Zalogowano jako ${_username}'),
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