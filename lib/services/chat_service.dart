import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/message_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier{
  User userTo;

  Future<List<Message>> getChat(String userId)async{
    final token = await AuthService.getToken();

    final resp = await http.get('${Environment.apiUrl}/messages/${userId}',
    headers: {
      'Content-Type':'application/json',
      'Authorization':'Bearer '+ token
    });

    final messageResponse = messsageResponseFromJson(resp.body);

    return messageResponse.results;

  }

}