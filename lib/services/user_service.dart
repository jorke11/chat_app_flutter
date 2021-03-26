import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/user_response.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';

class UserService{
  Future<List<User>> getUsers()async{
    try{
      final token = await AuthService.getToken();

      print('token ${token}');

      final resp = await http.get('${Environment.apiUrl}/users/list-mongo',
      headers:{
        'Content-Type':'application/json',
        'Authorization': 'Bearer '+ token
      });

      
      final userResponse = userResponseFromJson(resp.body);
      
      return userResponse.results;

    }catch(e){
      return [];
    }
  }
}