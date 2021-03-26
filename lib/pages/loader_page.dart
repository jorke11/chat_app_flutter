import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/user_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context,snapshot){
          return Center(child: Text("Espere..."));
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context)async{
    final authService = Provider.of<AuthService>(context,listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);

    final autenticado = await authService.isLoggedIn();

    if(autenticado){
      //Navigator.pushReplacementNamed(context,"user");
      socketService.connect();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_,__,___)=>UserPage(),
          transitionDuration: Duration(milliseconds: 0)
          ),
        
      );
    }else{
       Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_,__,___)=>LoginPage(),
          transitionDuration: Duration(milliseconds: 0)
          ),
        
      );
    }
  }
}