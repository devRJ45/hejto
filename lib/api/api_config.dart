import 'package:hejto/api/models/models.dart';

class ApiConfig {
  
  String host;
  String useragent;

  Map<String, String> cookies = Map();
  Session session = Session();

  ApiConfig({
    required this.host,
    this.useragent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36'
  });

  void updateCookies (Map<String, String> cookies) {
    this.cookies = cookies;
  }

  void updateSession (Session session) {
    this.session = session;
  }
}