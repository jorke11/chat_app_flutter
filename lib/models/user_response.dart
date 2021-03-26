// To parse this JSON data, do
//
//     final userResponse = userResponseFromJson(jsonString);

import 'dart:convert';

import 'package:chat_app/models/user.dart';

UserResponse userResponseFromJson(String str) => UserResponse.fromJson(json.decode(str));

String userResponseToJson(UserResponse data) => json.encode(data.toJson());

class UserResponse {
    UserResponse({
        this.results,
    });

    List<User> results;

    factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        results: List<User>.from(json["results"].map((x) => User.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}