import 'package:hejto/api/hejtoapi.dart';

String stringifyCookies(Map<String, String> cookies) => cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');

class HejtoApiService {
  static final HejtoApiService _api = HejtoApiService._internal();

  static late HejtoApi instance;

  factory HejtoApiService () {
    instance = HejtoApi();
    
    return _api;
  }

  HejtoApiService._internal();
}