import 'package:chat_app/Widgets/btn_blue.dart';
import 'package:chat_app/Widgets/custom_input.dart';
import 'package:chat_app/Widgets/labels.dart';
import 'package:chat_app/Widgets/logo.dart';
import 'package:chat_app/helpers/show_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: SingleChildScrollView(
        child: SafeArea(
          child:Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Logo(title: "Messenger",),
              _FormState(),
              Labels(route: "register",title: "¿No tienes cuenta?",subtitle: "Crea una ahora!",),
              Text("Terminos y condiciones de uso",style: TextStyle(fontWeight: FontWeight.w200),)
            ],
        ),
          )
        ),
      ),
    );
  }
}



class _FormState extends StatefulWidget {

  @override
  __FormStateState createState() => __FormStateState();
}

class __FormStateState extends State<_FormState> {

final emailCtrl = TextEditingController();
final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: EdgeInsets.only(top:40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(icon: Icons.mail_outline,
          placeholder: "Correo",
          keyboardType: TextInputType.emailAddress,
          textEditingController: emailCtrl),
          CustomInput(
            icon: Icons.lock_outline,
          placeholder: "Password",
          keyboardType: TextInputType.emailAddress,
          textEditingController: passwordCtrl,
          isPassword: true,
          ),
          BtnBlue(
            text: "ingresar",
            onPress: authService.autenticando?null:()async{
              FocusScope.of(context).unfocus();
              final loginOk = await authService.login(emailCtrl.text.trim(),passwordCtrl.text.trim());

              if(loginOk){
                //Navegar a otra pantalla
                socketService.connect();
                Navigator.pushReplacementNamed(context,"user");

              }else{
                //Mostrar Alerta
                showAlert(context,'Login Incorrecto',"Revise sus credenciales");
              }

          },)
        ]
      )
      );
  }
}
