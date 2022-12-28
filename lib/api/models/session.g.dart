// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      expires: json['expires'] as String?,
      accessToken: json['accessToken'] as String?,
      accessTokenExpiry: json['accessTokenExpiry'] as int?,
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'expires': instance.expires,
      'accessToken': instance.accessToken,
      'accessTokenExpiry': instance.accessTokenExpiry,
    };
