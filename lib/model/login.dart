import 'dart:convert';

import 'package:unplan/model/user_detail.dart';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    this.message,
    this.token,
    this.userDetail,
  });

  String message;
  String token;
  UserDetail userDetail;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    message: json["message"],
    token: json["token"],
    userDetail: UserDetail.fromJson(json["User Detail"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "User Detail": userDetail.toJson(),
  };
}
