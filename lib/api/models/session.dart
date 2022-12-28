import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  Session({this.expires, this.accessToken, this.accessTokenExpiry});

  String? expires;
  String? accessToken;
  int? accessTokenExpiry;

  factory Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}