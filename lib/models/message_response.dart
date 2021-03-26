// To parse this JSON data, do
//
//     final messsageResponse = messsageResponseFromJson(jsonString);

import 'dart:convert';

import 'message.dart';

MesssageResponse messsageResponseFromJson(String str) => MesssageResponse.fromJson(json.decode(str));

String messsageResponseToJson(MesssageResponse data) => json.encode(data.toJson());

class MesssageResponse {
    MesssageResponse({
        this.results,
    });

    List<Message> results;

    factory MesssageResponse.fromJson(Map<String, dynamic> json) => MesssageResponse(
        results: List<Message>.from(json["results"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
    };
}
