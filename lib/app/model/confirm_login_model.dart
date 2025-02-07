// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ConfirmLoginModel {
  final String accessToken;
  final String refreshToken;

  ConfirmLoginModel({required this.accessToken, required this.refreshToken});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  factory ConfirmLoginModel.fromMap(Map<String, dynamic> map) {
    return ConfirmLoginModel(
      accessToken: map['access_token'] as String,
      refreshToken: map['refresh_token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfirmLoginModel.fromJson(String source) =>
      ConfirmLoginModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
