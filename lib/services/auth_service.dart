import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier{


  User user;
  bool _autenticando = false;

  final _storage =  new FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }


  //getter token

  static Future<String> getToken()async{
    final _storage =  new FlutterSecureStorage();
    final token = await _storage.read(key:'token');
    return token;
  }

  static Future<void> deleteToken()async{
    final _storage =  new FlutterSecureStorage();
    await _storage.delete(key:'token');
  }
  
  Future<bool> login(String email, String password)async{
    this.autenticando = true;

    final data = {
      'email':email,
      'password':password
    };


    final resp = await http.post('${Environment.apiUrl}/auth/login',
      body:jsonEncode(data),
      headers: {
        'Content-Type':'application/json'
      }
    );

    if(resp.statusCode==200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    }

    this.autenticando = false;
    return false;
  }

  Future register(String name,String email, String password)async{
    this.autenticando = true;

    final data = {
      "name":name,
      'email':email,
      'password':password
    };


    final resp = await http.post('${Environment.apiUrl}/auth/register',
      body:jsonEncode(data),
      headers: {
        'Content-Type':'application/json'
      }
    );

    if(resp.statusCode==200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    }

    this.autenticando = false;
    final respBody = jsonDecode(resp.body);

    return respBody["msg"];
  }


  Future<bool> isLoggedIn()async{
    final token = await this._storage.read(key:'token');

    if(token==null){
      this.logOut();
      return false;
    }
    
    final url = '${Environment.apiUrl}/auth/renew';
  
     final resp = await http.get(url,
      headers: {
        'Content-Type':'application/json',
        'Authorization':"Bearer "+token
      }
    );

    if(resp.statusCode==200){
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      
      await this._saveToken(loginResponse.token);
      return true;
    }else{
      this.logOut();
      return false;
    }

    
  }


  Future _saveToken(String token)async{
    return await _storage.write(key: 'token',value: token);
  }

  Future logOut()async{
    return await _storage.delete(key: 'token');
  }
}